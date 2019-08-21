#' @title k-Nearest-Neighbor Classification Learner
#'
#' @usage NULL
#' @aliases mlr_learners_classif.kknn
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerClassif].
#'
#' @section Construction:
#' ```
#' LearnerClassifKKNN$new()
#' mlr3::mlr_learners$get("classif.kknn")
#' mlr3::lrn("classif.kknn")
#' ```
#'
#' @description
#' k-Nearest-Neighbor classification.
#' Calls [kknn::kknn()] from package \CRANpkg{kknn}.
#'
#' @export
#' @template seealso_learner
#' @templateVar learner_name classif.kknn
#' @template example
LearnerClassifKKNN = R6Class("LearnerClassifKKNN", inherit = LearnerClassif,
  public = list(
    initialize = function() {
      super$initialize(
        id = "classif.kknn",
        param_set = ParamSet$new(
          params = list(
            ParamInt$new(id = "k", default = 7L, lower = 1L, tags = "predict"),
            ParamDbl$new(id = "distance", default = 2, lower = 0, tags = "predict"),
            ParamFct$new(id = "kernel", levels = c("rectangular", "triangular", "epanechnikov", "biweight",
              "triweight", "cos", "inv", "gaussian", "rank", "optimal"), default = "optimal", tags = "predict"),
            ParamLgl$new(id = "scale", default = TRUE, tags = "predict")
          )
        ),
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric", "factor", "ordered"),
        properties = c("twoclass", "multiclass"),
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
      PredictionClassif$new(task = task, response = m$fitted.values, prob = m$prob)
    }
  )
)
