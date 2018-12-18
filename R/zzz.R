#' @rawNamespace import(data.table, except = transpose)
#' @import paradox
#' @import mlr3misc
#' @importFrom R6 R6Class
#' @importFrom mlr3 mlr_learners LearnerClassif LearnerRegr
"_PACKAGE"

.onLoad = function(libname, pkgname) {
  mlr_learners$add("classif.ranger", LearnerClassifRanger)
  mlr_learners$add("classif.logreg", LearnerClassifLogReg)
}
