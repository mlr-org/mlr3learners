#include <R.h>
#include <Rinternals.h>
#include <math.h>

/* 
//FIXME:
    * make most funs static
    * use the 1e-8 trick for variance = 0? check paper again
*/

// Debug printer system - can be switched on/off
#define DEBUG_ENABLED 1  // Set to 1 to enable debug output

#if DEBUG_ENABLED
#define DEBUG_PRINT(fmt, ...) Rprintf(fmt, ##__VA_ARGS__)
#else
#define DEBUG_PRINT(fmt, ...) do {} while(0)
#endif


// for tree with index j_tree:
// computes a matrix with 2 columns: mu and sigma^2 for each term-node, term-nodes are rows
// the matrix is stored in s_res, which is a list of matrices, one for each tree
void c_ranger_mu_sigma_per_tree(int j_tree, int n_obs, int n_trees, int *pred_tab, double *y, SEXP s_res) {
    DEBUG_PRINT("tree: %d\n", j_tree);
    int n_terms = 0; // FIXME: careful some ids might be missing
    int term; 
    // get max term-node id, we need to know the size of the arrays
    for (int i = 0; i < n_obs; i++) {
      term = pred_tab[i + j_tree * n_obs];
      if (term > n_terms) n_terms = term;
    }
    DEBUG_PRINT("n_terms: %d\n", n_terms);
    // +1 because our C arrays are 0-indexed
    int counts[n_terms + 1]; // 
    double means[n_terms + 1]; // 
    double m2s[n_terms + 1]; //
    memset(counts, 0, sizeof(counts));
    memset(means, 0, sizeof(means));
    memset(m2s, 0, sizeof(m2s));

    // Welford's variance algorithm (numerically stable)
    for (int i = 0; i < n_obs; i++) {
      term = pred_tab[i + j_tree * n_obs];
      counts[term]++;
      double yy = y[i];
      double delta = yy - means[term];
      means[term] += delta / counts[term];
      m2s[term] += delta * (yy - means[term]);
      DEBUG_PRINT("i: %d, term: %d, yy: %f, delta: %f, means: %f, m2s: %f\n", i, term, yy, delta, means[term], m2s[term]);
    }

    // Create result array with dimensions [n_terms, 2] for mu and sigma^2
    SEXP s_mu_sigma2_mat = PROTECT(allocMatrix(REALSXP, n_terms, 2));
    SEXP s_dimnames = PROTECT(allocVector(VECSXP, 2));
    SEXP s_colnames = PROTECT(allocVector(STRSXP, 2));
    SET_STRING_ELT(s_colnames, 0, mkChar("mu"));
    SET_STRING_ELT(s_colnames, 1, mkChar("sigma2")); 
    SET_VECTOR_ELT(s_dimnames, 1, s_colnames);
    setAttrib(s_mu_sigma2_mat, R_DimNamesSymbol, s_dimnames);
    
    double *res = REAL(s_mu_sigma2_mat);
    for (int i = 1; i <= n_terms; i++) {
      res[i-1]           = means[i];         
      // if we only have one observation in a terminal node, we set sigma2 to 0
      if (counts[i] > 1) {
        res[i-1 + n_terms] = m2s[i] / (counts[i] - 1);
      } else {
        res[i-1 + n_terms] = 0;
      }
    }
    SET_VECTOR_ELT(s_res, j_tree, s_mu_sigma2_mat);
    UNPROTECT(3); // s_mu_sigma2_mat, s_dimnames, s_colnames
}

// computes a list of matrices, one for each tree, each matrix has 2 columns: mu and sigma^2 for each term-node, term-nodes are rows
// we simply call c_ranger_mu_sigma_per_tree for each tree for each tree
SEXP c_ranger_mu_sigma(SEXP s_ranger, SEXP s_pred_tab, SEXP s_y) {
  int n_obs = Rf_nrows(s_pred_tab);
  int n_trees = Rf_ncols(s_pred_tab);
  int *pred_tab = INTEGER(s_pred_tab); // n_obs x n_trees, column-major
  double *y = REAL(s_y);
  DEBUG_PRINT("n_obs: %d, n_trees: %d\n", n_obs, n_trees);

  SEXP s_res = PROTECT(allocVector(VECSXP, n_trees));

  for (int j_tree = 0; j_tree < n_trees; j_tree++) {
    c_ranger_mu_sigma_per_tree(j_tree, n_obs, n_trees, pred_tab, y, s_res);
  }

  UNPROTECT(1); // s_res
  return s_res;
}

// computes a list of 2 elements: response and se

// "simple" method:
// for each observation:
// we get all mu values of all terminal nodes, that the observation belongs to, these are exactly "ntrees" values
// we then compute the mean (response) and the sd (se) of the mu-values

// "law_of_total_variance" method:
// for each observation:
// we get all mu values of all terminal nodes, that the observation belongs to, these are exactly "ntrees" values
// response: compute the mean of the mu-values
// se: compute the variance of the mu-values and compute the mean of the sigma2-values
//     sum both and take sqrt

SEXP c_ranger_var(SEXP s_pred_tab, SEXP s_mu_sigma2_mat, SEXP s_method) {
  DEBUG_PRINT("c_ranger_var_simple\n");
  int n_obs = Rf_nrows(s_pred_tab);
  int n_trees = Rf_ncols(s_pred_tab);
  DEBUG_PRINT("n_obs: %d, n_trees: %d\n", n_obs, n_trees);
  int *pred_tab = INTEGER(s_pred_tab); // n_obs x n_trees, column-major

  SEXP s_res = PROTECT(allocVector(VECSXP, 2));
  SEXP s_response = PROTECT(allocVector(REALSXP, n_obs));
  SEXP s_se = PROTECT(allocVector(REALSXP, n_obs));
  double *response = REAL(s_response);
  double *se = REAL(s_se);

  int method = asInteger(s_method);

  for (int i = 0; i < n_obs; ++i) {
    // Welford's variance algorithm (numerically stable)
    double mu_mean, mu_m2 = 0, sigma2_sum = 0;
    for (int j = 0; j < n_trees; ++j) {
      SEXP s_mu_sigma2_mat_j = VECTOR_ELT(s_mu_sigma2_mat, j); // n_terms x 2 
      int n_terms = Rf_nrows(s_mu_sigma2_mat_j);
      double *mu_sigma2_mat = REAL(s_mu_sigma2_mat_j);
      int term = pred_tab[i + j * n_obs];
      double mu = mu_sigma2_mat[term - 1];
      double mu_delta = mu - mu_mean;
      mu_mean += mu_delta / (j + 1);
      mu_m2 += mu_delta * (mu - mu_mean);
      double sigma2 = mu_sigma2_mat[term - 1 + n_terms];
      sigma2_sum += sigma2;
      DEBUG_PRINT("i: %d, j: %d, term: %d, mu: %f, delta: %f, mean: %f, m2: %f\n", i, j, term, mu, mu_delta, mu_mean, mu_m2);
    }
    response[i] = mu_mean;
    if (method == 0) {
      se[i] = sqrt(mu_m2 / (n_trees - 1));
    } else {
      // FIXME: it is somewhat weird if the biased estimator is used here
      // for "simple" the unbiased estimator is used, but this is how it was in lennarts code
      // and maybe in smac
      se[i] = sqrt(mu_m2 / (n_trees ) + sigma2_sum / n_trees);
      DEBUG_PRINT("mu_m2: %f, sigma2_sum: %f, n_trees: %d\n", mu_m2, sigma2_sum, n_trees);
      DEBUG_PRINT("i: %d, se: %f\n", i, se[i]);
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

