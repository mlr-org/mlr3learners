#' @title Quadratic Discriminant Analysis Classification Learner
#'
#' @name mlr_learners_classif.qda
#'
#' @description
#' Quadratic discriminant analysis.
#' Calls [MASS::qda()] from package \CRANpkg{MASS}.
#'
#' @templateVar id classif.qda
#' @template section_dictionary_learner
#'
#' @references
#' \cite{mlr3learners}{venables_2002}
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerClassifQDA = R6Class("LearnerClassifQDA", inherit = LearnerClassif,
  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ParamSet$new(list(
        ParamUty$new("prior", tags = "train"),
        ParamFct$new("method", default = "moment", levels = c("moment", "mle", "mve", "t"), tags = "train"),
        ParamInt$new("nu", tags = "train"),
        ParamFct$new("predict.method", default = "plug-in", levels = c("plug-in", "predictive", "debiased", "looCV"), tags = "predict")
      ))
      ps$add_dep("nu", "method", CondEqual$new("t"))

      super$initialize(
        id = "classif.qda",
        param_set = ps,
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric", "factor", "ordered"),
        properties = c("weights", "twoclass", "multiclass"),
        packages = "MASS",
        man = "mlr3learners::mlr_learners_classif.qda"
      )
    }
  ),

  private = list(
    .train = function(task) {
      invoke(MASS::qda, task$formula(), data = task$data(), .args = self$param_set$get_values(tags = "train"))
    },

    .predict = function(task) {
      pars = self$param_set$get_values(tags = "predict")
      if (!is.null(pars$predict.method)) {
        pars$method = pars$predict.method
        pars$predict.method = NULL
      }

      newdata = task$data(cols = task$feature_names)
      p = invoke(predict, self$model, newdata = newdata, .args = pars)

      if (self$predict_type == "response") {
        PredictionClassif$new(task = task, response = p$class)
      } else {
        PredictionClassif$new(task = task, prob = p$posterior)
      }
    }
  )
)
