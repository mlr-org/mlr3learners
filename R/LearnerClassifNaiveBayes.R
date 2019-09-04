#' @title Naive Bayes Classification Learner
#'
#' @usage NULL
#' @aliases mlr_learners_classif.naive_bayes
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerClassif].
#'
#' @section Construction:
#' ```
#' LearnerClassifNaiveBayes$new()
#' mlr3::mlr_learners$get("classif.naive_bayes")
#' mlr3::lrn("classif.naive_bayes")
#' ```
#'
#' @description
#' Naive Bayes classification.
#' Calls [e1071::naiveBayes()] from package \CRANpkg{e1071}.
#'
#' @export
#' @template seealso_learner
#' @templateVar learner_name classif.naive_bayes
#' @template example
LearnerClassifNaiveBayes = R6Class("LearnerClassifNaiveBayes", inherit = LearnerClassif,
  public = list(
    initialize = function() {
      ps = ParamSet$new(list(
        ParamDbl$new("laplace", default = 0, lower = 0, tags = "train")
      ))

      super$initialize(
        id = "classif.naive_bayes",
        param_set = ps,
        predict_types = c("response", "prob"),
        properties = c("twoclass", "multiclass"),
        feature_types = c("logical", "integer", "numeric", "factor"),
        packages = "e1071"
      )
    },

    train_internal = function(task) {
      y = task$truth()
      x = task$data(cols = task$feature_names)
      invoke(e1071::naiveBayes, x = x, y = y, .args = self$param_set$get_values(tags = "train"))
    },

    predict_internal = function(task) {
      newdata = task$data(cols = task$feature_names)

      if (self$predict_type == "response") {
        response = predict(self$model, newdata = newdata, type = "class")
        PredictionClassif$new(task = task, response = response)
      } else {
        prob = predict(self$model, newdata = newdata, type = "raw")
        PredictionClassif$new(task = task, prob = prob)
      }
    }
  )
)
