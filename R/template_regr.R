#' @title [Your learner name] Regression Learner
#'
#' @name mlr_learners_regr.template
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerRegr].
#'
#' @description
#' A [mlr3::LearnerRegr] for [short description of your learner, mentioning the package it comes from].
#'
#' @export
LearnerRegrTEMPLATE = R6Class("LearnerRegrTEMPLATE", inherit = LearnerRegr,
  public = list(
    initialize = function(id = "regr.template") {
      super$initialize(
        id = id,
        param_set = ParamSet$new(
          params = list(
            # TODO: Add your parameters here.
          )
        ),

        # TODO: Fix these two arrays to correspond with your learner.
        feature_types = c("logical", "integer", "numeric", "factor", "ordered"),
        packages = c()
      )
    },

    train = function(task) {
      # TODO: Train your model here.
      self
    },

    predict = function(task) {
      # TODO: Predict here.
      PredictionRegr$new(task, response = m$fitted.values)
    }
  )
)
