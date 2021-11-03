#' @title Linear Discriminant Analysis Classification Learner
#'
#' @name mlr_learners_classif.lda
#'
#' @description
#' Linear discriminant analysis.
#' Calls [MASS::lda()] from package \CRANpkg{MASS}.
#'
#' @details
#' Parameters `method` and `prior` exist for training and prediction but
#' accept different values for each. Therefore, arguments for
#' the predict stage have been renamed to `predict.method` and `predict.prior`,
#' respectively.
#'
#' @templateVar id classif.lda
#' @template learner
#'
#' @references
#' `r format_bib("venables_2002")`
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerClassifLDA = R6Class("LearnerClassifLDA",
  inherit = LearnerClassif,

  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ps(
        dimen          = p_uty(tags = "predict"),
        method         = p_fct(c("moment", "mle", "mve", "t"), default = "moment", tags = "train"),
        nu             = p_int(tags = "train"),
        predict.method = p_fct(c("plug-in", "predictive", "debiased"), default = "plug-in", tags = "predict"),
        predict.prior  = p_uty(tags = "predict"),
        prior          = p_uty(tags = "train"),
        tol            = p_dbl(tags = "train")
      )
      ps$add_dep("nu", "method", CondEqual$new("t"))

      super$initialize(
        id = "classif.lda",
        param_set = ps,
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric", "factor", "ordered"),
        properties = c("weights", "twoclass", "multiclass"),
        packages = c("mlr3learners", "MASS"),
        man = "mlr3learners::mlr_learners_classif.lda"
      )
    }
  ),

  private = list(
    .train = function(task) {
      pv = self$param_set$get_values(tags = "train")
      formula = task$formula()
      invoke(MASS::lda, formula, data = task$data(), .args = pv)
    },

    .predict = function(task) {
      pv = self$param_set$get_values(tags = "predict")
      pv = rename(pv, c("predict.method", "predict.prior"), c("method", "prior"))
      newdata = task$data(cols = task$feature_names)

      p = invoke(predict, self$model, newdata = newdata, .args = pv)

      if (self$predict_type == "response") {
        list(response = p[["class"]])
      } else {
        list(response = p[["class"]], prob = p[["posterior"]])
      }
    }
  )
)
