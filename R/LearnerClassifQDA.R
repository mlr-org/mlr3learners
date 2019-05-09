#' @title Quadratic Discriminant Analysis Classification Learner
#'
#' @aliases mlr_learners_classif.qda
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerClassif].
#'
#' @description
#' Quadratic discriminant analysis.
#' Calls [MASS::qda()] from package \CRANpkg{MASS}.
#'
#' @export
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

    train = function(task) {
      f = task$formula()
      self$model = invoke(MASS::qda, f, data = task$data(), .args = self$params("train"))
      self
    },

    predict = function(task) {

      pars = self$params("predict")
      if (!is.null(pars$predict.method)) {
        pars$predict = pars$predict.method
        pars$predict.method = NULL
      }

      response = prob = NULL
      newdata = task$data(cols = task$feature_names)
      p = invoke(predict, self$model, newdata = newdata, .args = pars)

      if (self$predict_type == "response") {
        response = p$class
      }
      if (self$predict_type == "prob") {
        prob = p$posterior
      }

      PredictionClassif$new(task, response, prob)
    })
)
