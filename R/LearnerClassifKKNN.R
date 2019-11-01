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
#' @references
#' \cite{mlr3learners}{hechenbichler_2004}
#'
#' \cite{mlr3learners}{samworth_2012}
#'
#' \cite{mlr3learners}{cover_1967}
#'
#' @export
#' @template seealso_learner
#' @templateVar learner_name classif.kknn
#' @template example
LearnerClassifKKNN = R6Class("LearnerClassifKKNN", inherit = LearnerClassif,
  public = list(
    initialize = function() {
      ps = ParamSet$new(list(
        ParamInt$new("k", default = 7L, lower = 1L, tags = "train"),
        ParamDbl$new("distance", default = 2, lower = 0, tags = "train"),
        ParamFct$new("kernel", levels = c("rectangular", "triangular", "epanechnikov", "biweight", "triweight", "cos", "inv", "gaussian", "rank", "optimal"), default = "optimal", tags = "train"),
        ParamLgl$new("scale", default = TRUE, tags = "train")
      ))

      super$initialize(
        id = "classif.kknn",
        param_set = ps,
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric", "factor", "ordered"),
        properties = c("twoclass", "multiclass"),
        packages = c("withr", "kknn"),
        man = "mlr3learners::mlr_learners_classif.kknn"
      )
    },

    train_internal = function(task) {
      list(
        formula = task$formula(),
        data = task$data(),
        pars = self$param_set$get_values(tags = "train")
      )
    },

    predict_internal = function(task) {
      model = self$model
      newdata = task$data(cols = task$feature_names)

      withr::with_package("kknn", { # https://github.com/KlausVigo/kknn/issues/16
        p = invoke(kknn::kknn, formula = model$formula, train = model$data, test = newdata, .args = model$pars)
      })

      if (self$predict_type == "response") {
        PredictionClassif$new(task = task, response = p$fitted.values)
      } else {
        PredictionClassif$new(task = task, prob = p$prob)
      }
    }
  )
)
