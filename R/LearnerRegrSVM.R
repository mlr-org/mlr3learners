#' @title Support Vector Machine
#'
#' @aliases mlr_learners_regr.svm
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerRegr].
#'
#' @description
#' A learner for a regression support vector machine implemented in [e1071::svm()].
#'
#' @export
#' @templateVar learner_name regr.svm
#' @template example
LearnerRegrSVM = R6Class("LearnerRegrSVM", inherit = LearnerRegr,
  public = list(
    initialize = function(id = "regr.svm") {
      super$initialize(
        id = id,
        param_set = ParamSet$new(
          params = list(
            ParamFct$new(id = "type", default = "eps-regression", levels = c("eps-regression", "nu-regression"), tag = "train"),
            ParamFct$new(id = "kernel", default = "radial", levels = c("linear", "polynomial", "radial", "sigmoid"), tag = "train"),
            ParamInt$new(id = "degree", default = 3L, lower = 1L, tag = "train"), # requires = quote(kernel == "polynomial")),
            ParamDbl$new(id = "coef0", default = 0, tag = "train"), # requires = quote(kernel == "polynomial" || kernel == "sigmoid")),
            ParamDbl$new(id = "cost", default = 1, lower = 0, tag = "train"), # , requires = quote(type == "C-regrication")),
            ParamDbl$new(id = "nu", default = 0.5, tag = "train"), # , requires = quote(type == "nu-regression")),
            ParamDbl$new(id = "gamma", lower = 0, tag = "train"), # requires = quote(kernel != "linear")),
            ParamDbl$new(id = "cachesize", default = 40L, tag = "train"),
            ParamDbl$new(id = "tolerance", default = 0.001, lower = 0, tag = "train"),
            ParamDbl$new(id = "epsilon", lower = 0, tag = "train"), # , requires = quote(type == "eps-regression")),
            ParamLgl$new(id = "shrinking", default = TRUE, tag = "train"),
            ParamInt$new(id = "cross", default = 0L, lower = 0L, tag = "train"), # tunable = FALSE),
            ParamLgl$new(id = "fitted", default = TRUE, tag = "train"), # tunable = FALSE),
            ParamUty$new(id = "scale", default = TRUE, tag = "train") # , tunable = TRUE)
          )
        ),
        feature_types = c("integer", "numeric"),
        packages = "e1071"
      )
    },

    train_internal = function(task) {
      pars = self$param_set$get_values(tags ="train")
      invoke(e1071::svm, x = as.matrix(task$data(cols = task$feature_names)), y = task$truth(), .args = pars)
    },

    predict_internal = function(task) {
      pars = self$param_set$get_values(tags ="predict")
      newdata = as.matrix(task$data(cols = task$feature_names))
      response = invoke(predict, self$model, newdata = newdata, type = "response", .args = pars)
      list(response = response)
    }
  )
)
