#' @rawNamespace import(data.table, except = transpose)
#' @import paradox
#' @import mlr3misc
#' @importFrom R6 R6Class
#' @importFrom mlr3 mlr_learners LearnerClassif LearnerRegr
"_PACKAGE"

register_mlr3 = function() {
  x = getFromNamespace("mlr_learners", ns = "mlr3")

  # classification learners
  x$add("classif.glmnet", LearnerClassifGlmnet)
  x$add("classif.kknn", LearnerClassifKKNN)
  x$add("classif.lda", LearnerClassifLDA)
  x$add("classif.logreg", LearnerClassifLogReg)
  x$add("classif.ranger", LearnerClassifRanger)
  x$add("classif.svm", LearnerClassifSvm)
  x$add("classif.xgboost", LearnerClassifXgboost)

  # regression learners
  x$add("regr.glmnet", LearnerRegrGlmnet)
  x$add("regr.kknn", LearnerRegrKKNN)
  x$add("regr.km", LearnerRegrKM)
  x$add("regr.lm", LearnerRegrLm)
  x$add("regr.ranger", LearnerRegrRanger)
  x$add("regr.svm", LearnerRegrSvm)
  x$add("regr.xgboost", LearnerRegrXgboost)
}

.onLoad = function(libname, pkgname) { # nocov start
  register_mlr3()
  setHook(packageEvent("mlr3", "onLoad"), function(...) register_mlr3(), action = "append")
} # nocov end

.onUnload = function(libpath) { # nocov start
  event = packageEvent("mlr3", "onLoad")
  hooks = getHook(event)
  pkgname = vapply(hooks, function(x) environment(x)$pkgname, NA_character_)
  setHook(event, hooks[pkgname != "mlr3learners"], action = "replace")
} # nocov end
