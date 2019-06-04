#' @title Logistic Regression Classification Learner
#'
#' @aliases mlr_learners_classif.log_reg
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerClassif].
#'
#' @description
#' Classification via logistic regression.
#' Calls [stats::glm()].
#'
#' @export
LearnerClassifLogReg = R6Class("LearnerClassifLogReg", inherit = LearnerClassif,
  public = list(
    initialize = function(id = "classif.log_reg") {
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
      if ("weights" %in% task$properties) {
        pars = insert_named(pars, list(weights = task$weights$weight))
      }

      self$model = invoke(stats::glm, formula = task$formula(), data = task$data(), family = "binomial", .args = pars)
      self
    },

    predict = function(task) {
      newdata = task$data(cols = task$feature_names)

      p = unname(predict(self$model, newdata = newdata, type = "response"))
      levs = levels(self$model$data[[task$target_names]])

      if (self$predict_type == "response") {
        list(response = ifelse(p < 0.5, levs[1L], levs[2L]))
      } else {
        list(prob = probVectorToMatrix(p, levs))
      }
    }
  )
)
