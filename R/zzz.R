#' @import data.table
#' @import paradox
#' @import mlr3misc
#' @importFrom R6 R6Class
#' @importFrom mlr3 mlr_learners LearnerClassif LearnerRegr
#'
#' @description
#' More learners are available in the `mlr3learners` repository on Github
#' (\url{https://github.com/mlr3learners}). There also is a wiki page listing
#' all currently available custom learners
#' (\url{https://github.com/mlr-org/mlr3learners/wiki/Extra-Learners}). A guide
#' on how to create custom learners is covered in the book:
#' \url{https://mlr3book.mlr-org.com}. Feel invited to contribute a missing
#' learner to the \CRANpkg{mlr3} ecosystem!
"_PACKAGE"

register_mlr3 = function() {

  x = utils::getFromNamespace("mlr_learners", ns = "mlr3")

  # classification learners
  x$add("classif.cv_glmnet", LearnerClassifCVGlmnet)
  x$add("classif.glmnet", LearnerClassifGlmnet)
  x$add("classif.kknn", LearnerClassifKKNN)
  x$add("classif.lda", LearnerClassifLDA)
  x$add("classif.log_reg", LearnerClassifLogReg)
  x$add("classif.naive_bayes", LearnerClassifNaiveBayes)
  x$add("classif.qda", LearnerClassifQDA)
  x$add("classif.ranger", LearnerClassifRanger)
  x$add("classif.svm", LearnerClassifSVM)
  x$add("classif.xgboost", LearnerClassifXgboost)
  x$add("classif.multinom", LearnerClassifMultinom)

  # regression learners
  x$add("regr.cv_glmnet", LearnerRegrCVGlmnet)
  x$add("regr.glmnet", LearnerRegrGlmnet)
  x$add("regr.kknn", LearnerRegrKKNN)
  x$add("regr.km", LearnerRegrKM)
  x$add("regr.lm", LearnerRegrLM)
  x$add("regr.ranger", LearnerRegrRanger)
  x$add("regr.svm", LearnerRegrSVM)
  x$add("regr.xgboost", LearnerRegrXgboost)

  # survival learners
  x$add("surv.glmnet", LearnerSurvGlmnet)
  x$add("surv.cv_glmnet", LearnerSurvCVGlmnet)
  x$add("surv.xgboost", LearnerSurvXgboost)
  x$add("surv.ranger", LearnerSurvRanger)
}

.onLoad = function(libname, pkgname) { # nolint
  register_mlr3()
  setHook(packageEvent("mlr3", "onLoad"), function(...) register_mlr3(), action = "append")
} # nocov end

.onUnload = function(libpath) { # nolint
  event = packageEvent("mlr3", "onLoad")
  hooks = getHook(event)
  pkgname = vapply(hooks, function(x) environment(x)$pkgname, NA_character_)
  setHook(event, hooks[pkgname != "mlr3learners"], action = "replace")
} # nocov end
