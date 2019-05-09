#' @title Linear Discriminant Analysis Classification Learner
#'
#' @aliases mlr_learners_classif.lda
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerClassif].
#'
#' @description
#' Linear discriminant analysis.
#' Calls [MASS::lda()] from package \CRANpkg{MASS}.
#'
#' @export
LearnerClassifLDA = R6Class("LearnerClassifLDA", inherit = LearnerClassif,
  public = list(
    initialize = function(id = "classif.lda") {
      super$initialize(
        id = id,
        param_set = ParamSet$new(
          params = list(
            ParamFct$new(id = "method", default = "moment", levels = c("moment", "mle", "mve", "t"), tags = "train"),
            ParamFct$new(id = "predict.method", default = "plug-in", levels = c("plug-in", "predictive", "debiased"), tags = "predict")
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
      self$model = invoke(MASS::lda, f, data = task$data(), .args = self$params("train"))
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
      p = invoke(predict, self$model, newdata = newdata, .args = self$params("predict"))

      if (self$predict_type == "response") {
        response = p$class
      }
      if (self$predict_type == "prob") {
        prob = p$posterior
      }

      PredictionClassif$new(task, response, prob)
    })
)
