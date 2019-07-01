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
      self$model = invoke(MASS::lda, f, data = task$data(), .args = self$param_set$get_values(tags ="train"))
      self
    },

    predict = function(task) {
      pars = self$param_set$get_values(tags ="predict")
      if (!is.null(pars$predict.method)) {
        pars$method = pars$predict.method
        pars$predict.method = NULL
      }
      newdata = task$data(cols = task$feature_names)
      p = invoke(predict, self$model, newdata = newdata, .args = self$param_set$get_values(tags ="predict"))

      if (self$predict_type == "response") {
        self$new_prediction(task, response = p$class)
      } else {
        self$new_prediction(task, prob = p$posterior)
      }
    }
  )
)
