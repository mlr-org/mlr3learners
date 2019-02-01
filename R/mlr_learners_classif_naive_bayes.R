#' @title Classification Naive Bayes Learner
#' @name mlr_learners_classif_naive_bayes
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerClassif].
#' @description
#' A learner for naive Bayes implemented in [e1071::naiveBayes()].
#' @export
LearnerClassifNaiveBayes = R6Class("LearnerClassifNaiveBayes", inherit = LearnerClassif,
  public = list(
    initialize = function() {
      super$initialize(
        id = "classif.naive_bayes",
        packages = "e1071",
        feature_types = c("logical", "integer", "numeric", "factor"),
        predict_types = c("response", "prob"),
        param_set = ParamSet$new(
          params = list(
            ParamDbl$new(id = "laplace", default = 0, lower = 0, tags = "train")
          )
        ),
        properties = c("twoclass", "multiclass")
      )
    },

    train = function(task) {
      y = task$truth()
      x = task$data(cols = task$feature_names)
      self$model = invoke(e1071::naiveBayes, x = x, y = y, .args = self$params("train"))
      self
    },

    predict = function(task) {
      response = prob = NULL
      newdata = task$data(cols = task$feature_names)

      if (self$predict_type == "response")
        response = predict(self$model, newdata = newdata, type = "class")
      if (self$predict_type == "prob")
        prob = predict(self$model, newdata = newdata, type = "raw")
      PredictionClassif$new(task, response = response, prob = prob)
    }
  )
)
