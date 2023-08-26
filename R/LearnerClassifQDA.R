#' @title Quadratic Discriminant Analysis Classification Learner
#'
#' @name mlr_learners_classif.qda
#'
#' @description
#' Quadratic discriminant analysis.
#' Calls [MASS::qda()] from package \CRANpkg{MASS}.
#'
#' @details
#' Parameters `method` and `prior` exist for training and prediction but
#' accept different values for each. Therefore, arguments for
#' the predict stage have been renamed to `predict.method` and `predict.prior`,
#' respectively.
#'
#' @templateVar id classif.qda
#' @template learner
#'
#' @references
#' `r format_bib("venables_2002")`
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerClassifQDA = R6Class("LearnerClassifQDA",
  inherit = LearnerClassif,

  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ps(
        method         = p_fct(c("moment", "mle", "mve", "t"), default = "moment", tags = "train"),
        nu             = p_int(tags = "train", depends = method == "t"),
        predict.method = p_fct(c("plug-in", "predictive", "debiased"), default = "plug-in", tags = "predict"),
        predict.prior  = p_uty(tags = "predict"),
        prior          = p_uty(tags = "train")
      )

      super$initialize(
        id = "classif.qda",
        param_set = ps,
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric", "factor", "ordered"),
        properties = c("weights", "twoclass", "multiclass"),
        packages = c("mlr3learners", "MASS"),
        label = "Quadratic Discriminant Analysis",
        man = "mlr3learners::mlr_learners_classif.qda"
      )
    }
  ),

  private = list(
    .train = function(task) {
      invoke(MASS::qda, task$formula(),
        data = task$data(),
        .args = self$param_set$get_values(tags = "train"))
    },

    .predict = function(task) {
      pv = self$param_set$get_values(tags = "predict")
      pv = rename(pv, c("predict.method", "predict.prior"), c("method", "prior"))

      newdata = ordered_features(task, self)
      p = invoke(predict, self$model, newdata = newdata, .args = pv)

      if (self$predict_type == "response") {
        list(response = p$class)
      } else {
        list(prob = p$posterior)
      }
    }
  )
)

#' @include aaa.R
learners[["classif.qda"]] = LearnerClassifQDA
