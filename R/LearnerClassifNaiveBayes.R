#' @title Naive Bayes Classification Learner
#'
#' @name mlr_learners_classif.naive_bayes
#'
#' @description
#' Naive Bayes classification.
#' Calls [e1071::naiveBayes()] from package \CRANpkg{e1071}.
#'
#' @template section_dictionary_learner
#' @templateVar id classif.naive_bayes
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerClassifNaiveBayes = R6Class("LearnerClassifNaiveBayes",
  inherit = LearnerClassif,

  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ParamSet$new(list(
        ParamDbl$new("laplace", default = 0, lower = 0, tags = "train"),
        ParamDbl$new("threshold", default = 0.001, tags = "predict"),
        ParamDbl$new("eps", default = 0, tags = "predict")
      ))

      super$initialize(
        id = "classif.naive_bayes",
        param_set = ps,
        predict_types = c("response", "prob"),
        properties = c("twoclass", "multiclass"),
        feature_types = c("logical", "integer", "numeric", "factor"),
        packages = "e1071",
        man = "mlr3learners::mlr_learners_classif.naive_bayes"
      )
    }
  ),

  private = list(
    .train = function(task) {
      y = task$truth()
      x = task$data(cols = task$feature_names)
      mlr3misc::invoke(e1071::naiveBayes,
        x = x, y = y,
        .args = self$param_set$get_values(tags = "train"))
    },

    .predict = function(task) {
      pars = self$param_set$get_values(tags = "predict")
      newdata = task$data(cols = task$feature_names)

      if (self$predict_type == "response") {
        response = mlr3misc::invoke(stats::predict, self$model,
          newdata = newdata,
          type = "class", .args = pars)
        mlr3::PredictionClassif$new(task = task, response = response)
      } else {
        prob = mlr3misc::invoke(stats::predict, self$model, newdata = newdata,
          type = "raw", .args = pars)
        mlr3::PredictionClassif$new(task = task, prob = prob)
      }
    }
  )
)
