#' @title Logistic Regression Classification Learner
#'
#' @usage NULL
#' @aliases mlr_learners_classif.log_reg
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerClassif].
#'
#' @section Construction:
#' ```
#' LearnerClassifLogReg$new()
#' mlr3::mlr_learners$get("classif.log_reg")
#' mlr3::lrn("classif.log_reg")
#' ```
#'
#' @description
#' Classification via logistic regression.
#' Calls [stats::glm()].
#'
#' @export
#' @template seealso_learner
#' @templateVar learner_name classif.log_reg
#' @template example
LearnerClassifLogReg = R6Class("LearnerClassifLogReg", inherit = LearnerClassif,
  public = list(
    initialize = function() {
      super$initialize(
        id = "classif.log_reg",
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric", "character", "factor", "ordered"),
        properties = c("weights", "twoclass"),
        packages = "stats"
      )
    },

    train_internal = function(task) {
      pars = self$param_set$get_values(tags = "train")
      if ("weights" %in% task$properties) {
        pars = insert_named(pars, list(weights = task$weights$weight))
      }

      invoke(stats::glm, formula = task$formula(), data = task$data(), family = "binomial", .args = pars)
    },

    predict_internal = function(task) {
      newdata = task$data(cols = task$feature_names)

      p = unname(predict(self$model, newdata = newdata, type = "response"))
      levs = levels(self$model$data[[task$target_names]])

      if (self$predict_type == "response") {
        PredictionClassif$new(task = task, response = ifelse(p < 0.5, levs[1L], levs[2L]))
      } else {
        PredictionClassif$new(task = task, prob = prob_vector_to_matrix(p, levs))
      }
    }
  )
)
