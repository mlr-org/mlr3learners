#' @title k-Nearest-Neighbor Regression Learner
#'
#' @aliases mlr_learners_regr.kknn
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerRegr].
#'
#' @description
#' k-Nearest-Neighbor regression.
#' Calls [kknn::kknn()] from package \CRANpkg{kknn}.
#'
#' @export
LearnerRegrKKNN = R6Class("LearnerRegrKKNN", inherit = LearnerRegr,
  public = list(
    initialize = function(id = "regr.kknn") {
      super$initialize(
        id = id,
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

    train = function(task) {
      self$model = task$data()
      self
    },

    predict = function(task) {
      withr::with_package("kknn", { # https://github.com/KlausVigo/kknn/issues/16
        m = invoke(kknn::kknn, formula = task$formula(), train = self$model, test = task$data(cols = task$feature_names), .args = self$params("predict"))
      })
      self$model = NULL
      PredictionRegr$new(task, response = m$fitted.values)
    }
  )
)
