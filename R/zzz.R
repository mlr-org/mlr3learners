#' @import data.table
#' @import paradox
#' @import mlr3misc
#' @importFrom R6 R6Class
#' @importFrom mlr3 mlr_learners LearnerClassif LearnerRegr
#'
#' @section Classification Learners:
#' \tabular{lll}{
#'   **ID**                                                  \tab **Package**       \tab **Learner** \cr
#'   [classif.glmnet][mlr_learners_classif.glmnet]           \tab \CRANpkg{glmnet}  \tab Penalized Logistic Regression \cr
#'   [classif.kknn][mlr_learners_classif.kknn]               \tab \CRANpkg{kknn}    \tab k-Nearest Neighbors \cr
#'   [classif.lda][mlr_learners_classif.lda]                 \tab \CRANpkg{MASS}    \tab Linear Discriminant Analysis \cr
#'   [classif.log_reg][mlr_learners_classif.log_reg]         \tab \CRANpkg{stats}   \tab Logistic Regression \cr
#'   [classif.naive_bayes][mlr_learners_classif.naive_bayes] \tab \CRANpkg{e1071}   \tab Naive Bayes \cr
#'   [classif.qda][mlr_learners_classif.qda]                 \tab \CRANpkg{MASS}    \tab Quadratic Discriminant Analysis \cr
#'   [classif.ranger][mlr_learners_classif.ranger]           \tab \CRANpkg{ranger}  \tab Random Classification Forest \cr
#'   [classif.svm][mlr_learners_classif.svm]                 \tab \CRANpkg{e1071}   \tab Support Vector Machine \cr
#'   [classif.xgboost][mlr_learners_classif.xgboost]         \tab \CRANpkg{xgboost} \tab Gradient Boosting \cr
#' }
#'
#' @section Regression Learners:
#' \tabular{lll}{
#'   **ID**                                    \tab **Package**           \tab **Learner** \cr
#'   [regr.glmnet][mlr_learners_regr.glmnet]   \tab \CRANpkg{glmnet}      \tab Penalized Linear Regression \cr
#'   [regr.kknn][mlr_learners_regr.kknn]       \tab \CRANpkg{kknn}        \tab k-Nearest Neighbors \cr
#'   [regr.km][mlr_learners_regr.km]           \tab \CRANpkg{DiceKriging} \tab Kriging \cr
#'   [regr.lm][mlr_learners_regr.lm]           \tab \CRANpkg{stats}       \tab Linear Regression \cr
#'   [regr.ranger][mlr_learners_regr.ranger]   \tab \CRANpkg{ranger}      \tab Random Regression Forest \cr
#'   [regr.svm][mlr_learners_regr.svm]         \tab \CRANpkg{e1071}       \tab Support Vector Machine \cr
#'   [regr.xgboost][mlr_learners_regr.xgboost] \tab \CRANpkg{xgboost}     \tab Gradient Boosting \cr
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
