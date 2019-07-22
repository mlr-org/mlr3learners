#' @title Quadratic Discriminant Analysis Classification Learner
#'
#' @aliases mlr_learners_classif.qda
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerClassif].
#'
#' @description
#' Quadratic discriminant analysis.
#' Calls [MASS::qda()] from package \CRANpkg{MASS}.
#'
#' @references
#' Venables, W. N. & Ripley, B. D (2002).
#' Modern Applied Statistics with S.
#' Fourth Edition. Springer, New York. ISBN 0-387-95457-0
#'
#' @export
#' @templateVar learner_name classif.qda
#' @template example
LearnerClassifQDA = R6Class("LearnerClassifQDA", inherit = LearnerClassif,
  public = list(
    initialize = function(id = "classif.qda") {
      super$initialize(
        id = id,
        param_set = ParamSet$new(
          params = list(
            ParamFct$new(id = "method", default = "moment", levels = c("moment", "mle", "mve", "t"), tags = "train"),
            ParamFct$new(id = "predict.method", default = "plug-in", levels = c("plug-in", "predictive", "debiased", "looCV"), tags = "predict")
          )
        ),
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric", "factor", "ordered"),
        properties = c("weights", "twoclass", "multiclass"),
        packages = "MASS"
      )
    },

    train_internal = function(task) {
      invoke(MASS::qda, task$formula(), data = task$data(), .args = self$param_set$get_values(tags ="train"))
    },

    predict_internal = function(task) {
      pars = self$param_set$get_values(tags ="predict")
      if (!is.null(pars$predict.method)) {
        pars$method = pars$predict.method
        pars$predict.method = NULL
      }

      newdata = task$data(cols = task$feature_names)
      p = invoke(predict, self$model, newdata = newdata, .args = pars)

      if (self$predict_type == "response") {
        PredictionClassif$new(task = task, response = p$class)
      } else {
        PredictionClassif$new(task = task, prob = p$posterior)
      }
    }
  )
)
