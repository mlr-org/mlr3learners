#' @title Logistic Regression Classification Learner
#'
#' @name mlr_learners_classif.log_reg
#'
#' @description
#' Classification via logistic regression.
#' Calls [stats::glm()] with `family` set to `"binomial"`.
#' Argument `model` is set to `FALSE`.
#'
#' @templateVar id classif.log_reg
#' @template section_dictionary_learner
#'
#' @template section_contrasts
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerClassifLogReg = R6Class("LearnerClassifLogReg", inherit = LearnerClassif,
  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      super$initialize(
        id = "classif.log_reg",
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric", "character", "factor", "ordered"),
        properties = c("weights", "twoclass"),
        packages = "stats",
        man = "mlr3learners::mlr_learners_classif.log_reg"
      )
    }
  ),

  private = list(
    .train = function(task) {
      pars = self$param_set$get_values(tags = "train")
      if ("weights" %in% task$properties) {
        pars = insert_named(pars, list(weights = task$weights$weight))
      }

      invoke(stats::glm, formula = task$formula(), data = task$data(),
        family = "binomial", model = FALSE,
        .args = pars, .opts = opts_default_contrasts)
    },

    .predict = function(task) {
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
