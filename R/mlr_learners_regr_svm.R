#' @title Support Vector Machine
#'
#' @name mlr_learners_regr.svm
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerRegr].
#'
#' @description
#' A learner for a regression support vector machine implemented in [e1071::svm()].
#'
#' @export
LearnerRegrSvm = R6Class("LearnerRegrSvm", inherit = LearnerRegr,
  public = list(
    initialize = function(id = "regr.svm") {
      super$initialize(
        id = id,
        param_set = ParamSet$new(
          params = list(
            ParamFct$new(id = "type", default = "eps-regression", levels = c("eps-regression", "nu-regression"), tag = "train"),
            ParamFct$new(id = "kernel", default = "radial", levels = c("linear", "polynomial", "radial", "sigmoid"), tag = "train"),
            ParamInt$new(id = "degree", default = 3L, lower = 1L, tag = "train"), #requires = quote(kernel == "polynomial")),
            ParamDbl$new(id = "coef0", default = 0, tag = "train"), #requires = quote(kernel == "polynomial" || kernel == "sigmoid")),
            ParamDbl$new(id = "cost",  default = 1, lower = 0, tag = "train"),#, requires = quote(type == "C-regrication")),
            ParamDbl$new(id = "nu", default = 0.5, tag = "train"),#, requires = quote(type == "nu-regression")),
            ParamDbl$new(id = "gamma", lower = 0, tag = "train"), #requires = quote(kernel != "linear")),
            ParamDbl$new(id = "cachesize", default = 40L, tag = "train"),
            ParamDbl$new(id = "tolerance", default = 0.001, lower = 0, tag = "train"),
            ParamDbl$new(id = "epsilon", lower = 0, tag = "train"),#, requires = quote(type == "eps-regression")),
            ParamLgl$new(id = "shrinking", default = TRUE, tag = "train"),
            ParamInt$new(id = "cross", default = 0L, lower = 0L, tag = "train"), #tunable = FALSE),
            ParamLgl$new(id = "fitted", default = TRUE, tag = "train"), #tunable = FALSE),
            ParamUty$new(id = "scale", default = TRUE, tag = "train")#, tunable = TRUE)
          )
        ),
        feature_types = c("integer", "numeric"),
        packages = "e1071"
      )
    },

    train = function(task) {
      pars = self$params("train")
      data = as.matrix(task$data(cols = task$feature_names))
      target = as.matrix(task$data(cols = task$target_names))

      browser()

      self$model = invoke(e1071::svm,
        x = data,
        y = target,
        .args = pars
      )

      self
    },

    predict = function(task) {
      pars = self$params("predict")
      newdata = as.matrix(task$data(cols = task$feature_names))
      response = invoke(predict, self$model, newdata = newdata, type = "response", .args = pars)

      PredictionRegr$new(task, response)
    }
  )
)

