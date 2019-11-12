#' @title Linear Discriminant Analysis Classification Learner
#'
#' @usage NULL
#' @aliases mlr_learners_classif.lda
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerClassif].
#'
#' @section Construction:
#' ```
#' LearnerClassifLDA$new()
#' mlr3::mlr_learners$get("classif.lda")
#' mlr3::lrn("classif.lda")
#' ```
#'
#' @description
#' Linear discriminant analysis.
#' Calls [MASS::lda()] from package \CRANpkg{MASS}.
#'
#' @references
#' \cite{mlr3learners}{venables_2002}
#'
#' @export
#' @template seealso_learner
#' @templateVar learner_name classif.lda
#' @template example
LearnerClassifLDA = R6Class("LearnerClassifLDA", inherit = LearnerClassif,
  public = list(
    initialize = function() {
      ps = ParamSet$new(list(
        ParamUty$new("prior", tags = "train"),
        ParamDbl$new("tol", tags = "train"),
        ParamFct$new("method", default = "moment", levels = c("moment", "mle", "mve", "t"), tags = "train"),
        ParamInt$new("nu", tags = "train"),
        ParamFct$new("predict.method", default = "plug-in", levels = c("plug-in", "predictive", "debiased"), tags = "predict")
      ))
      ps$add_dep("nu", "method", CondEqual$new("t"))

      super$initialize(
        id = "classif.lda",
        param_set = ps,
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric", "factor", "ordered"),
        properties = c("weights", "twoclass", "multiclass"),
        packages = "MASS",
        man = "mlr3learners::mlr_learners_classif.lda"
      )
    },

    train_internal = function(task) {
      f = task$formula()
      invoke(MASS::lda, f, data = task$data(), .args = self$param_set$get_values(tags = "train"))
    },

    predict_internal = function(task) {
      pars = self$param_set$get_values(tags = "predict")
      if (!is.null(pars$predict.method)) {
        pars$method = pars$predict.method
        pars$predict.method = NULL
      }
      newdata = task$data(cols = task$feature_names)
      p = invoke(predict, self$model, newdata = newdata, .args = self$param_set$get_values(tags = "predict"))

      if (self$predict_type == "response") {
        PredictionClassif$new(task = task, response = p$class)
      } else {
        PredictionClassif$new(task = task, response = p$class, prob = p$posterior)
      }
    }
  )
)
