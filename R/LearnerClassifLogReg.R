#' @title Logistic Regression Classification Learner
#'
#' @name mlr_learners_classif.log_reg
#'
#' @description
#' Classification via logistic regression.
#' Calls [stats::glm()] with `family` set to `"binomial"`.
#'
#' @section Internal Encoding:
#' Starting with \CRANpkg{mlr3} v0.5.0, the order of class labels is reversed prior to
#' model fitting to comply to the [stats::glm()] convention that the negative class is provided
#' as the first factor level.
#'
#' @section Custom mlr3 defaults:
#' - `model`:
#'   - Actual default: `TRUE`.
#'   - Adjusted default: `FALSE`.
#'   - Reason for change: Save some memory.
#'
#' @templateVar id classif.log_reg
#' @template learner
#'
#' @template section_contrasts
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerClassifLogReg = R6Class("LearnerClassifLogReg",
  inherit = LearnerClassif,

  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ps(
        dispersion  = p_uty(default = NULL, tags = "predict"),
        epsilon     = p_dbl(default = 1e-8, tags = c("train", "control")),
        etastart    = p_uty(tags = "train"),
        maxit       = p_dbl(default = 25, tags = c("train", "control")),
        model       = p_lgl(default = TRUE, tags = "train"),
        mustart     = p_uty(tags = "train"),
        offset      = p_uty(tags = "train"),
        singular.ok = p_lgl(default = TRUE, tags = "train"),
        start       = p_uty(default = NULL, tags = "train"),
        trace       = p_lgl(default = FALSE, tags = c("train", "control")),
        x           = p_lgl(default = FALSE, tags = "train"),
        y           = p_lgl(default = TRUE, tags = "train")
      )

      super$initialize(
        id = "classif.log_reg",
        param_set = ps,
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric", "character", "factor", "ordered"),
        properties = c("weights", "twoclass", "loglik"),
        packages = c("mlr3learners", "stats"),
        man = "mlr3learners::mlr_learners_classif.log_reg"
      )
    },

    #' @description
    #' Extract the log-likelihood (e.g., via [stats::logLik()] from the fitted model.
    loglik = function() {
      extract_loglik(self)
    }
  ),

  private = list(
    .train = function(task) {
      pv = self$param_set$get_values(tags = "train")
      if ("weights" %in% task$properties) {
        pv = insert_named(pv, list(weights = task$weights$weight))
      }

      # logreg expects the first label to be the negative class, contrary
      # to the mlr3 convention that the positive class comes first.
      tn = task$target_names
      data = task$data()
      data[[tn]] = swap_levels(data[[tn]])

      invoke(stats::glm,
        formula = task$formula(), data = data,
        family = "binomial", model = FALSE, .args = pv, .opts = opts_default_contrasts)
    },

    .predict = function(task) {
      pv = self$param_set$get_values(tags = "predict")
      lvls = c(task$negative, task$positive)
      newdata = task$data(cols = task$feature_names)

      p = unname(invoke(predict, object = self$model, newdata = newdata, type = "response", .args = pv))

      if (self$predict_type == "response") {
        list(response = ifelse(p < 0.5, lvls[1L], lvls[2L]))
      } else {
        list(prob = pvec2mat(p, lvls))
      }
    }
  )
)
