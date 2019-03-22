#' @title Classification Logistic Regression Learner
#'
#' @name mlr_learners_classif.logreg
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerClassif].
#'
#' @description
#' A learner for a classification logistic regression implemented in [stats::glm()].
#'
#' @export
LearnerClassifLogReg = R6Class("LearnerClassifLogReg", inherit = LearnerClassif,
  public = list(
    initialize = function(id = "classif.logreg") {
      super$initialize(
        id = id,
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric", "character", "factor", "ordered"),
        properties = c("weights", "twoclass"),
        packages = "stats"
      )
    },

    train = function(task) {
      pars = self$params("train")
      if ("weights" %in% task$properties)
        pars = insert_named(pars, list(weights = task$weights$weight))

      self$model = invoke(stats::glm,
        formula = task$formula(),
        data = task$data(),
        family = "binomial",
        .args = pars
      )
      self
    },

    predict = function(task) {
      newdata = task$data(cols = task$feature_names)
      response = prob = NULL

      p = unname(predict(self$model, newdata = newdata, type = "response"))
      levs = as.character(task$class_names)

      if (self$predict_type == "response") {
        response = ifelse(p < 0.5, levs[1L], levs[2L])
      }
      if (self$predict_type == "prob") {
        prob = propVectorToMatrix(1 - p, levs)
      }

      PredictionClassif$new(task, response, prob)
    }
  )
)
