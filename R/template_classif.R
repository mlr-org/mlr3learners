#' @title [Your learner name] Classification Learner
#'
#' @name mlr_learners_classif.[learner abbreviation]
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerClassif].
#'
#' @description
#' A [mlr3::LearnerClassif] for [short description of your learner, mentioning the package it comes from].
#'
#' @export
LearnerClassifTEMPLATE = R6Class("LearnerClassifTEMPLATE", inherit = LearnerClassif,
  public = list(
    initialize = function(id = "classif.template") {
      super$initialize(
        id = id,
        param_set = ParamSet$new(
          params = list(
            # TODO: Add your parameters here.
          )
        ),

        # TODO: Fix these four arrays to correspond with your learner.
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric", "factor", "ordered"),
        properties = c("twoclass", "multiclass"),
        packages = c()
      )
    },

    train = function(task) {
      # TODO: Train your model here.
      self
    },

    predict = function(task) {
      # TODO: Predict here.
      PredictionClassif$new(task, response, prob)
    }
  )
)
