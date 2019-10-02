#' @title Support Vector Machine
#'
#' @usage NULL
#' @aliases mlr_learners_regr.svm
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerRegr].
#'
#' @section Construction:
#' ```
#' LearnerRegrSVM$new()
#' mlr3::mlr_learners$get("regr.svm")
#' mlr3::lrn("regr.svm")
#' ```
#'
#' @description
#' A learner for a regression support vector machine implemented in [e1071::svm()].
#'
#' @references
#' \cite{mlr3learners}{cortes_1995}
#'
#' @export
#' @template seealso_learner
#' @templateVar learner_name regr.svm
#' @template example
LearnerRegrSVM = R6Class("LearnerRegrSVM", inherit = LearnerRegr,
  public = list(
    initialize = function() {
      ps = ParamSet$new(list(
        ParamFct$new("type", default = "eps-regression", levels = c("eps-regression", "nu-regression"), tags = "train"),
        ParamFct$new("kernel", default = "radial", levels = c("linear", "polynomial", "radial", "sigmoid"), tags = "train"),
        ParamInt$new("degree", default = 3L, lower = 1L, tags = "train"), # requires = quote(kernel == "polynomial")),
        ParamDbl$new("coef0", default = 0, tags = "train"), # requires = quote(kernel == "polynomial" || kernel == "sigmoid")),
        ParamDbl$new("cost", default = 1, lower = 0, tags = "train"), # , requires = quote(type == "C-regrication")),
        ParamDbl$new("nu", default = 0.5, tags = "train"), # , requires = quote(type == "nu-regression")),
        ParamDbl$new("gamma", lower = 0, tags = "train"), # requires = quote(kernel != "linear")),
        ParamDbl$new("cachesize", default = 40L, tags = "train"),
        ParamDbl$new("tolerance", default = 0.001, lower = 0, tags = "train"),
        ParamDbl$new("epsilon", lower = 0, tags = "train"), # , requires = quote(type == "eps-regression")),
        ParamLgl$new("shrinking", default = TRUE, tags = "train"),
        ParamInt$new("cross", default = 0L, lower = 0L, tags = "train"), # tunable = FALSE),
        ParamLgl$new("fitted", default = TRUE, tags = "train"), # tunable = FALSE),
        ParamUty$new("scale", default = TRUE, tags = "train") # , tunable = TRUE)
      ))

      super$initialize(
        id = "regr.svm",
        param_set = ps,
        feature_types = c("integer", "numeric"),
        packages = "e1071"
      )
    },

    train_internal = function(task) {
      pars = self$param_set$get_values(tags = "train")
      data = as.matrix(task$data(cols = task$feature_names))
      self$state$feature_names = colnames(data)

      invoke(e1071::svm, x = data, y = task$truth(), .args = pars)
    },

    predict_internal = function(task) {
      pars = self$param_set$get_values(tags = "predict")
      newdata = as.matrix(task$data(cols = task$feature_names))
      newdata = newdata[, self$state$feature_names, drop = FALSE]
      response = invoke(predict, self$model, newdata = newdata, type = "response", .args = pars)
      PredictionRegr$new(task = task, response = response)
    }
  )
)
