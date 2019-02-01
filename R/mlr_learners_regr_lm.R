#' @title Linear Regression Learner
#' @name mlr_learners_regr_lm
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerRegr].
#' @description
#' A learner for linear regression implemented in [stats::glm()].
#' @export
LearnerRegrLm = R6Class("LearnerRegrLm", inherit = LearnerRegr,
  public = list(
    initialize = function() {
      super$initialize(
        id = "regr.lm",
        packages = "stats",
        feature_types = c("integer", "numeric", "factor"),
        predict_types = c("response", "se"),
        param_set = ParamSet$new(
          params = list()
        ),
        properties = c("weights")
      )
    },

    train = function(task) {
      self$model = invoke(stats::lm,
        formula = task$formula,
        data = task$data()
      ) # FIXME: weights = task$weights
      self
    },

    predict = function(task) {
      newdata = task$data(cols = task$feature_names)
      response = se = NULL

      if (self$predict_type == "response") {
        response = predict(self$model, newdata = newdata, se.fit = FALSE)
      } else {
        pred = predict(self$model, newdata = newdata, se.fit = TRUE)
        response = pred$fit
        se = pred$se.fit
      }

      PredictionRegr$new(task, response, se)
    },

    plot = function() {
      plot(self$model)
    }
  )
)
