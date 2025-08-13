#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* .Call calls */
extern SEXP c_ranger_mu_sigma(SEXP, SEXP);
extern SEXP c_ranger_var(SEXP, SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
    {"c_ranger_mu_sigma", (DL_FUNC) &c_ranger_mu_sigma, 2},
    {"c_ranger_var", (DL_FUNC) &c_ranger_var, 3},
    {NULL, NULL, 0}
};

void R_init_mlr3learners(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
