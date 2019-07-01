#' @title Naive Bayes Classification Learner
#'
#' @aliases mlr_learners_classif.naive_bayes
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerClassif].
#'
#' @description
#' Naive Bayes classification.
#' Calls [e1071::naiveBayes()] from package \CRANpkg{e1071}.
#'
#' @export
LearnerClassifNaiveBayes = R6Class("LearnerClassifNaiveBayes", inherit = LearnerClassif,
  public = list(
    initialize = function(id = "classif.naive_bayes") {
      super$initialize(
        id = id,
        param_set = ParamSet$new(
          params = list(
            ParamDbl$new(id = "laplace", default = 0, lower = 0, tags = "train")
          )
        ),
        predict_types = c("response", "prob"),
        properties = c("twoclass", "multiclass"),
        feature_types = c("logical", "integer", "numeric", "factor"),
        packages = "e1071"
      )
    },

    train_internal = function(task) {
      y = task$truth()
      x = task$data(cols = task$feature_names)
      invoke(e1071::naiveBayes, x = x, y = y, .args = self$param_set$get_values(tags ="train"))
    },

    predict_internal = function(task) {
      newdata = task$data(cols = task$feature_names)

      if (self$predict_type == "response") {
        list(response = predict(self$model, newdata = newdata, type = "class"))
      } else {
        list(prob = predict(self$model, newdata = newdata, type = "raw"))
      }
    }
  )
)
