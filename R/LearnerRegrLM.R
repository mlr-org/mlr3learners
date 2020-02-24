#' @title Linear Model Regression Learner
#'
#' @name mlr_learners_regr.lm
#'
#' @description
#' Ordinary linear regression.
#' Calls [stats::lm()].
#'
#' @templateVar id regr.lm
#' @template section_dictionary_learner
#'
#' @template section_contrasts
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerRegrLM = R6Class("LearnerRegrLM", inherit = LearnerRegr,
  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      super$initialize(
        id = "regr.lm", ,
        predict_types = c("response", "se"),
        feature_types = c("logical", "integer", "numeric", "factor"),
        properties = "weights",
        packages = "stats",
        man = "mlr3learners::mlr_learners_regr.lm"
      )
    }
  ),

  private = list(
    .train = function(task) {
      pars = self$param_set$get_values(tags = "train")
      if ("weights" %in% task$properties) {
        pars = insert_named(pars, list(weights = task$weights$weight))
      }

      invoke(stats::lm, formula = task$formula(), data = task$data(),
        .args = pars, .opts = opts_default_contrasts)
    },

    .predict = function(task) {
      newdata = task$data(cols = task$feature_names)

      if (self$predict_type == "response") {
        PredictionRegr$new(task = task, response = predict(self$model, newdata = newdata, se.fit = FALSE))
      } else {
        pred = predict(self$model, newdata = newdata, se.fit = TRUE)
        PredictionRegr$new(task = task, response = pred$fit, se = pred$se.fit)
      }
    }
  )
)
