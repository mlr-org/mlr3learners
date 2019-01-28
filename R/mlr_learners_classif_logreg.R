#' @title Classification Logistic Regression Learner
#' @name mlr_learners_classif_logreg
#' @format [R6::R6Class()] inheriting from [LearnerClassif].
#' @description
#' A learner for a classification logistic regression implemented in [stats::glm()].
#' @export
LearnerClassifLogReg = R6Class("LearnerClassifLogReg", inherit = LearnerClassif,
  public = list(
    initialize = function() {
      super$initialize(
        id = "classif.logreg",
        packages = "stats",
        feature_types = c("logical", "integer", "numeric", "character", "factor", "ordered"),
        predict_types = c("response", "prob"),
        param_set = ParamSet$new(
          params = list()
        ),
        properties = c("weights", "twoclass")
      )
    },

    train = function(task) {
      self$model = invoke(stats::glm,
        formula = task$formula,
        data = task$data(),
        family = "binomial"
      ) # FIXME: weights = task$weights
      self
    },

    predict = function(task) {
      newdata = task$data(cols = task$feature_names)
      response = prob = NULL

      pred = predict(self$model, newdata = newdata, type = "response")
      levs = task$class_names

      if (self$predict_type == "prob") {
        prob = propVectorToMatrix(pred, levs) # FIXME
      } else {
        p = as.factor(ifelse(pred > 0.5, levs[1L], levs[2L]))
        response = unname(p)
      }

      PredictionClassif$new(task, response, prob)
    }
  )
)
