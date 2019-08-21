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
#' William N. Venables and Brian D. Ripley (2002).
#' Modern Applied Statistics with S.
#' Fourth Edition. Springer, New York. ISBN 0-387-95457-0.
#' \doi{10.1007/978-0-387-21706-2}.
#'
#' @export
#' @templateVar learner_name classif.lda
#' @template example
LearnerClassifLDA = R6Class("LearnerClassifLDA", inherit = LearnerClassif,
  public = list(
    initialize = function() {
      super$initialize(
        id = "classif.lda",
        param_set = ParamSet$new(
          params = list(
            ParamFct$new(id = "method", default = "moment", levels = c("moment", "mle", "mve", "t"), tags = "train"),
            ParamFct$new(id = "predict.method", default = "plug-in", levels = c("plug-in", "predictive", "debiased"), tags = "predict")
          )
        ),
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric", "factor", "ordered"),
        properties = c("weights", "twoclass", "multiclass"),
        packages = "MASS"
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
