#' @import data.table
#' @import paradox
#' @import mlr3misc
#' @importFrom R6 R6Class
#' @importFrom mlr3 mlr_learners LearnerClassif LearnerRegr
#'
#' @section Classification Learners:
#' \tabular{lll}{
#'   [classif.glmnet]      \tab \CRANpkg{glmnet}  \tab Penalized Logistic Regression
#'   [classif.kknn]        \tab \CRANpkg{kknn}    \tab k-Nearest Neighbors
#'   [classif.lda]         \tab \CRANpkg{MASS}    \tab Linear Discriminant Analysis
#'   [classif.log_reg]     \tab \CRANpkg{stats}   \tab Logistic Regression
#'   [classif.naive_bayes] \tab \CRANpkg{e1071}   \tab Naive Bayes
#'   [classif.qda]         \tab \CRANpkg{MASS}    \tab Quadratic Discriminant Analysis
#'   [classif.ranger]      \tab \CRANpkg{ranger}  \tab Random Classification Forest
#'   [classif.svm]         \tab \CRANpkg{e1071}   \tab Support Vector Machine
#'   [classif.xgboost]     \tab \CRANpkg{xgboost} \tab Gradient Boosting
#' }
#'
#' @section Regression Learners:
#' \tabular{lll}{
#'   [regr.glmnet]  \tab \CRANpkg{glmnet}      \tab Penalized Linear Regression
#'   [regr.kknn]    \tab \CRANpkg{kknn}        \tab k-Nearest Neighbors
#'   [regr.km]      \tab \CRANpkg{DiceKriging} \tab Kriging
#'   [regr.lm]      \tab \CRANpkg{stats}       \tab Linear Regression
#'   [regr.ranger]  \tab \CRANpkg{ranger}      \tab Random Regression Forest
#'   [regr.svm]     \tab \CRANpkg{e1071}       \tab Support Vector Machine
#'   [regr.xgboost] \tab \CRANpkg{xgboost}     \tab Gradient Boosting
#' }
"_PACKAGE"

register_mlr3 = function() {

  x = utils::getFromNamespace("mlr_learners", ns = "mlr3")

  # classification learners
  x$add("classif.glmnet", LearnerClassifGlmnet)
  x$add("classif.kknn", LearnerClassifKKNN)
  x$add("classif.lda", LearnerClassifLDA)
  x$add("classif.log_reg", LearnerClassifLogReg)
  x$add("classif.naive_bayes", LearnerClassifNaiveBayes)
  x$add("classif.qda", LearnerClassifQDA)
  x$add("classif.ranger", LearnerClassifRanger)
  x$add("classif.svm", LearnerClassifSVM)
  x$add("classif.xgboost", LearnerClassifXgboost)

  # regression learners
  x$add("regr.glmnet", LearnerRegrGlmnet)
  x$add("regr.kknn", LearnerRegrKKNN)
  x$add("regr.km", LearnerRegrKM)
  x$add("regr.lm", LearnerRegrLM)
  x$add("regr.ranger", LearnerRegrRanger)
  x$add("regr.svm", LearnerRegrSVM)
  x$add("regr.xgboost", LearnerRegrXgboost)
}

.onLoad = function(libname, pkgname) {
  # nocov start
  register_mlr3()
  setHook(packageEvent("mlr3", "onLoad"), function(...) register_mlr3(), action = "append")
} # nocov end

.onUnload = function(libpath) {
  # nocov start
  event = packageEvent("mlr3", "onLoad")
  hooks = getHook(event)
  pkgname = vapply(hooks, function(x) environment(x)$pkgname, NA_character_)
  setHook(event, hooks[pkgname != "mlr3learners"], action = "replace")
} # nocov end
