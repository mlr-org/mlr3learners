#' @title Linear Model Regression Learner
#'
#' @name mlr_learners_regr.lm
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerRegr].
#'
#' @description
#' A [mlr3::LearnerRegr] for linear regression implemented in [stats::glm()].
#'
#' @export
LearnerRegrLm = R6Class("LearnerRegrLm", inherit = LearnerRegr,
  public = list(
    initialize = function(id = "regr.lm", predict_type = "response") {
      super$initialize(
        id = id,
        predict_types = c("response", "se"),
        feature_types = c("integer", "numeric", "factor"),
        properties = "weights",
        packages = "stats"
      )
    },

    train = function(task) {
      pars = self$params("train")
      if ("weights" %in% task$properties)
        pars = insert_named(pars, list(weights = task$weights$weight))

      self$model = invoke(stats::lm,
        formula = task$formula(),
        data = task$data(),
        .args = pars
      )
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
