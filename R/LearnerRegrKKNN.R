#' @title k-Nearest-Neighbor Regression Learner
#'
#' @usage NULL
#' @aliases mlr_learners_regr.kknn
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerRegr].
#'
#' @section Construction:
#' ```
#' LearnerRegrKKNN$new()
#' mlr3::mlr_learners$get("regr.kknn")
#' mlr3::lrn("regr.kknn")
#' ```
#'
#' @description
#' k-Nearest-Neighbor regression.
#' Calls [kknn::kknn()] from package \CRANpkg{kknn}.
#'
#' @export
#' @templateVar learner_name regr.kknn
#' @template example
LearnerRegrKKNN = R6Class("LearnerRegrKKNN", inherit = LearnerRegr,
  public = list(
    initialize = function() {
      super$initialize(
        id = "regr.kknn",
        param_set = ParamSet$new(
          params = list(
            ParamInt$new(id = "k", default = 7L, lower = 1L, tags = "predict"),
            ParamDbl$new(id = "distance", default = 2, lower = 0, tags = "predict"),
            ParamFct$new(id = "kernel", levels = c("rectangular", "triangular", "epanechnikov", "biweight",
              "triweight", "cos", "inv", "gaussian", "rank", "optimal"), default = "optimal", tags = "predict"),
            ParamLgl$new(id = "scale", default = TRUE, tags = "predict")
          )
        ),
        feature_types = c("logical", "integer", "numeric", "factor", "ordered"),
        packages = c("withr", "kknn")
      )
    },

    train_internal = function(task) {
      task$data()
    },

    predict_internal = function(task) {
      withr::with_package("kknn", { # https://github.com/KlausVigo/kknn/issues/16
        m = invoke(kknn::kknn, formula = task$formula(), train = self$model, test = task$data(cols = task$feature_names), .args = self$param_set$get_values(tags = "predict"))
      })
      PredictionRegr$new(task = task, response = m$fitted.values)
    }
  )
)
