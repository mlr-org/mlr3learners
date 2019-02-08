#' @title Classification k-Nearest-Neighbor Learner
#' @name mlr_learners_classif_kknn
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerClassif].
#' @description
#' A learner for a classification k-Nearest-Neighbor implemented in [kknn::kknn()].
#' @export
LearnerClassifKKNN = R6Class("LearnerClassifKKNN", inherit = LearnerClassif,
  public = list(
    initialize = function(id = "classif.kknn", param_vals = list(), predict_type = "response") {
      super$initialize(
        id = id,
        packages = c("withr", "kknn"),
        feature_types = c("logical", "integer", "numeric", "factor", "ordered"),
        predict_type = predict_type,
        predict_types = c("response", "prob"),
        param_set = ParamSet$new(
          params = list(
            ParamInt$new(id = "k", default = 7L, lower = 1L, tags = "predict"),
            ParamDbl$new(id = "distance", default = 2, lower = 0, tags = "predict"),
            ParamFct$new(id = "kernel", levels = c("rectangular", "triangular", "epanechnikov", "biweight",
          "triweight", "cos", "inv", "gaussian", "rank", "optimal"), default = "optimal", tags = "predict"),
            ParamLgl$new(id = "scale", default = TRUE, tags = "predict")
          )
        ),
        param_vals = param_vals,
        properties = c("twoclass", "multiclass")
      )
    },

    train = function(task) {
      self$model = task$data()
      self
    },

    predict = function(task) {
      withr::with_package("kknn", { # https://github.com/KlausVigo/kknn/issues/16
        m = invoke(kknn::kknn, formula = task$formula, train = self$model, test = task$data(cols = task$feature_names), .args = self$params("predict"))
      })
      self$model = NULL
      PredictionClassif$new(task, response = m$fitted.values, prob = m$prob)
    }
  )
)
