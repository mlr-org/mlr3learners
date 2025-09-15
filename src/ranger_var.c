#include <R.h>
#include <Rinternals.h>
#include <math.h>
#include <R_ext/Memory.h>
#include <string.h>


// Debug printer system - can be switched on/off
#define DEBUG_ENABLED 0  // Set to 1 to enable debug output

#if DEBUG_ENABLED
#define DEBUG_PRINT(fmt, ...) Rprintf(fmt, ##__VA_ARGS__)
#else
#define DEBUG_PRINT(fmt, ...) do {} while(0)
#endif


/*
funcions below use an "s_pred_tab" prediction table,
for a given ranger model and 'n_obs' observations, which where predicted by the RF
  int matrix, n_obs x n_trees, no row or column names
  each row is an observation, each cell states the
  terminal node id that the obs falls into for the tree of the col
  the terminnal node IDs are 0-based, and might have -- or will have -- gaps
*/

/////////////////////////////////////////////////////////////////////////////


/*
for tree with index j_tree:
computes a matrix with 2 columns: mu and sigma^2 for each term-node, term-nodes are rows

arguments:
j_tree: int, index of the tree, 0-based
n_obs: int, number of observations
n_trees: int, number of trees
pred_tab: flat int-matrix, n_obs x n_trees, see above
y: double-array(n_obs) of responses
sigma2_threshold: double, threshold for sigma2
s_res: result list where to store the j_tree-th matrix as jth element

result: set in s_res, see above.
the created matrix has 2 columns: "mu" and "sigma2"
its rows correspond to the terminal nodes, in the sense that a (0-based)
row-index is the node-id that ranger used to label it
NB: this can mean that some row are "gap-rows" if the row-index is not
present as a node id. such rows will be 0, but this shouldnt even matter
as you should not access them as the node doesnt exist.

*/
void c_ranger_mu_sigma_per_tree(int j_tree, int n_obs, int n_trees, const int *pred_tab,
    const double *y, double sigma2_threshold, SEXP s_res) {

    DEBUG_PRINT("tree: %d\n", j_tree);
    int max_term_id = 0;
    int term;
    // get max term-node id, we need to know the size of the arrays
    for (int i = 0; i < n_obs; i++) {
      term = pred_tab[i + j_tree * n_obs];
      if (term > max_term_id) max_term_id = term;
    }
    DEBUG_PRINT("max_term_id: %d\n", max_term_id);
    // these are the rows of the result objects, 1 per terminal node
    // +1 because our C arrays are 0-indexed
    int n_term_rows = max_term_id + 1;
    int *counts = (int*) R_alloc(n_term_rows, sizeof(int));
    double *means = (double*) R_alloc(n_term_rows, sizeof(double));
    double *m2s = (double*) R_alloc(n_term_rows, sizeof(double));
    memset(counts, 0, n_term_rows * sizeof(int));
    memset(means, 0, n_term_rows * sizeof(double));
    memset(m2s, 0, n_term_rows * sizeof(double));

    // Welford's variance algorithm (numerically stable)
    // we iterate over all observations
    // a) count the number of observations in each terminal node
    // b) compute the mean and var of y in each terminal node
    for (int i = 0; i < n_obs; i++) {
      term = pred_tab[i + j_tree * n_obs];
      counts[term]++;
      double yy = y[i];
      double delta = yy - means[term];
      means[term] += delta / counts[term];
      m2s[term] += delta * (yy - means[term]);
      DEBUG_PRINT("i: %d, term: %d, yy: %f, delta: %f, means: %f, m2s: %f\n", i, term, yy, delta, means[term], m2s[term]);
    }

    // Create result array with dimensions [n_term_rows, 2] for mu and sigma^2
    SEXP s_mu_sigma2_mat = PROTECT(allocMatrix(REALSXP, n_term_rows, 2));
    SEXP s_dimnames = PROTECT(allocVector(VECSXP, 2));
    SEXP s_colnames = PROTECT(allocVector(STRSXP, 2));
    SET_STRING_ELT(s_colnames, 0, mkChar("mu"));
    SET_STRING_ELT(s_colnames, 1, mkChar("sigma2"));
    SET_VECTOR_ELT(s_dimnames, 1, s_colnames);
    setAttrib(s_mu_sigma2_mat, R_DimNamesSymbol, s_dimnames);

    // iterate terminal nodes
    double *res = REAL(s_mu_sigma2_mat);
    for (int i = 0; i < n_term_rows; i++) {
      DEBUG_PRINT("i: %d, means: %f, counts: %d, m2s: %f\n", i, means[i], counts[i], m2s[i]);
      res[i] = means[i];
      double var = (counts[i] > 1) ? (m2s[i] / (counts[i] - 1)) : 0.0;
      res[i + n_term_rows] = fmax(var, sigma2_threshold);
    }
    SET_VECTOR_ELT(s_res, j_tree, s_mu_sigma2_mat);
    UNPROTECT(3); // s_mu_sigma2_mat, s_dimnames, s_colnames
}

/*
given an "s_pred_tab" prediction table and an "s_y" vector of responses
computes a list of mu-sigma2-matrices, one for each tree
we simply call c_ranger_mu_sigma_per_tree for each tree
for further details see function above
*/

SEXP c_ranger_mu_sigma(SEXP s_pred_tab, SEXP s_y, SEXP s_sigma2_threshold) {
  int n_obs = Rf_nrows(s_pred_tab);
  int n_trees = Rf_ncols(s_pred_tab);
  const int *pred_tab = INTEGER(s_pred_tab); // n_obs x n_trees, column-major
  double *y = REAL(s_y);
  double sigma2_threshold = asReal(s_sigma2_threshold);
  DEBUG_PRINT("n_obs: %d, n_trees: %d, sigma2_threshold: %f\n", n_obs, n_trees, sigma2_threshold);

  SEXP s_res = PROTECT(allocVector(VECSXP, n_trees));

  for (int j_tree = 0; j_tree < n_trees; j_tree++) {
    c_ranger_mu_sigma_per_tree(j_tree, n_obs, n_trees, pred_tab, y, sigma2_threshold, s_res);
  }

  UNPROTECT(1); // s_res
  return s_res;
}


/*
given the "s_pred_tab" prediction table (from prediction time)
and the "s_mu_sigma2_mats" (from training), we compute the response and se for each observation.
------------------------------------------------------
arguments:
s_pred_tab:
  int matrix, n_obs x n_trees, see above

argument s_mu_sigma2_mats:
  list of matrices, one for each tree, result of c_ranger_mu_sigma

argument s_method, integer, 0 or 1
  0 = "simple";  1 = "law_of_total_variance"
----------------------------------------------------
"simple" method:
for each observation:
we get all mu values of all terminal nodes, that the observation belongs to, these are exactly "ntrees" values
we then compute the mean (response) and the sd (se) of the mu-values

"law_of_total_variance" method:
for each observation:
we get all mu values of all terminal nodes, that the observation belongs to, these are exactly "ntrees" values
response: compute the mean of the mu-values
se: compute the variance of the mu-values and compute the mean of the sigma2-values
    sum both and take sqrt
--------------------------------------------------
returns a list of 2 elements: response and se
  both are numeric vectors of length n_obs
  contain the prediction mean and se for each observation
*/
SEXP c_ranger_var(SEXP s_pred_tab, SEXP s_mu_sigma2_mats, SEXP s_method) {
  DEBUG_PRINT("c_ranger_var\n");
  int n_obs = Rf_nrows(s_pred_tab);
  int n_trees = Rf_ncols(s_pred_tab);
  DEBUG_PRINT("n_obs: %d, n_trees: %d\n", n_obs, n_trees);
  const int *pred_tab = INTEGER(s_pred_tab); // n_obs x n_trees, column-major

  SEXP s_res = PROTECT(allocVector(VECSXP, 2));
  SEXP s_response = PROTECT(allocVector(REALSXP, n_obs));
  SEXP s_se = PROTECT(allocVector(REALSXP, n_obs));
  double *response = REAL(s_response);
  double *se = REAL(s_se);

  int method = asInteger(s_method);


  // Pre-compute per-tree matrix pointers and row counts
  int *n_term_rows = (int*) R_alloc(n_trees, sizeof(int));
  double **mu_ptr = (double**) R_alloc(n_trees, sizeof(double*));
  double **sig_ptr = (double**) R_alloc(n_trees, sizeof(double*));
  for (int j = 0; j < n_trees; ++j) {
    SEXP s_mu_sigma2_mat = VECTOR_ELT(s_mu_sigma2_mats, j);
    n_term_rows[j] = Rf_nrows(s_mu_sigma2_mat);
    double *base = REAL(s_mu_sigma2_mat);
    mu_ptr[j] = base;
    sig_ptr[j] = base + n_term_rows[j];
  }

  // Per-observation accumulators (improves cache locality)
  double *mu_mean_acc = (double*) R_alloc(n_obs, sizeof(double));
  double *mu_m2_acc   = (double*) R_alloc(n_obs, sizeof(double));
  memset(mu_mean_acc, 0, n_obs * sizeof(double));
  memset(mu_m2_acc,   0, n_obs * sizeof(double));
  double *sigma2_sum_acc = NULL;
  if (method != 0) {
    sigma2_sum_acc = (double*) R_alloc(n_obs, sizeof(double));
    memset(sigma2_sum_acc, 0, n_obs * sizeof(double));
  }

   // Welford's variance algorithm (numerically stable)
  for (int j = 0; j < n_trees; ++j) {
    int n_term_rows_j = n_term_rows[j];
    double *mu_j = mu_ptr[j];
    double *sig_j = sig_ptr[j];
    for (int i = 0; i < n_obs; ++i) {
      int term = pred_tab[i + j * n_obs];
      // Assumes 0 <= term < nrows_j as produced by training
      double mu_val = mu_j[term];
      double delta = mu_val - mu_mean_acc[i];
      mu_mean_acc[i] += delta / (j + 1);
      mu_m2_acc[i]   += delta * (mu_val - mu_mean_acc[i]);
      if (method != 0) {
        sigma2_sum_acc[i] += sig_j[term];
      }
    }
  }

  for (int i = 0; i < n_obs; ++i) {
    response[i] = mu_mean_acc[i];
    if (method == 0) {
      se[i] = (n_trees > 1) ? sqrt(mu_m2_acc[i] / (n_trees - 1)) : 0.0;
    } else {
      // FIXME (?): it is somewhat weird if the biased estimator is used here
      // for "simple" the unbiased estimator is used, but this is how it was in lennarts code
      // and maybe in smac
      // but i checked paper; and thats what is used there
      // Algorithm Runtime Prediction: Methods & Evaluation
      // https://arxiv.org/pdf/1211.0906
      se[i] = (n_trees > 0) ? sqrt(mu_m2_acc[i] / n_trees + sigma2_sum_acc[i] / n_trees) : 0.0;
    }
  }

  // store response and se in result list
  SEXP s_names = PROTECT(allocVector(STRSXP, 2));
  SET_STRING_ELT(s_names, 0, mkChar("response"));
  SET_STRING_ELT(s_names, 1, mkChar("se"));
  SET_VECTOR_ELT(s_res, 0, s_response);
  SET_VECTOR_ELT(s_res, 1, s_se);
  setAttrib(s_res, R_NamesSymbol, s_names);

  UNPROTECT(4); // s_res, s_response, s_se, s_names
  return s_res;
}

