#' @import data.table
#' @import paradox
#' @import mlr3misc
#' @import checkmate
#' @importFrom R6 R6Class
#' @importFrom mlr3 mlr_learners LearnerClassif LearnerRegr default_values
#' @importFrom stats predict reformulate
#'
#' @description
#' More learners are implemented in the [mlr3extralearners package](https://github.com/mlr-org/mlr3extralearners).
#' A guide on how to create custom learners is covered in the book:
#' \url{https://mlr3book.mlr-org.com}.
#' Feel invited to contribute a missing learner to the \CRANpkg{mlr3} ecosystem!
"_PACKAGE"

register_mlr3 = function() {
  x = utils::getFromNamespace("mlr_learners", ns = "mlr3")

  # classification learners
  x$add("classif.cv_glmnet", LearnerClassifCVGlmnet)
  x$add("classif.glmnet", LearnerClassifGlmnet)
  x$add("classif.kknn", LearnerClassifKKNN)
  x$add("classif.lda", LearnerClassifLDA)
  x$add("classif.log_reg", LearnerClassifLogReg)
  x$add("classif.multinom", LearnerClassifMultinom)
  x$add("classif.naive_bayes", LearnerClassifNaiveBayes)
  x$add("classif.nnet", LearnerClassifNnet)
  x$add("classif.qda", LearnerClassifQDA)
  x$add("classif.ranger", LearnerClassifRanger)
  x$add("classif.svm", LearnerClassifSVM)
  x$add("classif.xgboost", LearnerClassifXgboost)

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
  x$add("surv.cv_glmnet", LearnerSurvCVGlmnet)
  x$add("surv.glmnet", LearnerSurvGlmnet)
  x$add("surv.ranger", LearnerSurvRanger)
  x$add("surv.xgboost", LearnerSurvXgboost)
}

.onLoad = function(libname, pkgname) { # nolint
  register_namespace_callback(pkgname, "mlr3", register_mlr3)
} # nocov end

leanify_package()
