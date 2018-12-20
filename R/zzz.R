#' @rawNamespace import(data.table, except = transpose)
#' @import paradox
#' @import mlr3misc
#' @importFrom R6 R6Class
#' @importFrom mlr3 mlr_learners LearnerClassif LearnerRegr
"_PACKAGE"

.onLoad = function(libname, pkgname) {
  # classification learners
  mlr_learners$add("classif.ranger", LearnerClassifRanger)
  mlr_learners$add("classif.logreg", LearnerClassifLogReg)
  mlr_learners$add("classif.glmnet", LearnerClassifGlmnet)
  mlr_learners$add("classif.xgboost", LearnerClassifXgboost)

  # regression learners
  mlr_learners$add("regr.lm", LearnerRegrLm)
  mlr_learners$add("regr.ranger", LearnerRegrRanger)
}
