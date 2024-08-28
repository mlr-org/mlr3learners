#' @title Linear Model Regression Learner
#'
#' @name mlr_learners_regr.lm
#'
#' @description
#' Ordinary linear regression.
#' Calls [stats::lm()].
#'
#' @templateVar id regr.lm
#' @template learner
#'
#' @template section_contrasts
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerRegrLM = R6Class("LearnerRegrLM",
  inherit = LearnerRegr,

  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ps(
        df            = p_dbl(default = Inf, tags = "predict"),
        interval      = p_fct(c("none", "confidence", "prediction"), tags = "predict"),
        level         = p_dbl(default = 0.95, tags = "predict"),
        model         = p_lgl(default = TRUE, tags = "train"),
        offset        = p_lgl(tags = "train"),
        pred.var      = p_uty(tags = "predict"),
        qr            = p_lgl(default = TRUE, tags = "train"),
        scale         = p_dbl(default = NULL, special_vals = list(NULL), tags = "predict"),
        singular.ok   = p_lgl(default = TRUE, tags = "train"),
        x             = p_lgl(default = FALSE, tags = "train"),
        y             = p_lgl(default = FALSE, tags = "train"),
        rankdeficient = p_fct(c("warnif", "simple", "non-estim", "NA", "NAwarn"), tags = "predict"),
        tol           = p_dbl(default = 1e-07, tags = "predict"),
        verbose       = p_lgl(default = FALSE, tags = "predict")
      )

      super$initialize(
        id = "regr.lm",
        param_set = ps,
        predict_types = c("response", "se"),
        feature_types = c("logical", "integer", "numeric", "factor", "character"),
        properties = c("weights", "loglik"),
        packages = c("mlr3learners", "stats"),
        label = "Linear Model",
        man = "mlr3learners::mlr_learners_regr.lm"
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
        pv = insert_named(pv, list(weights = task$weights_learner))
      }

      invoke(stats::lm,
        formula = task$formula(), data = task$data(),
        .args = pv, .opts = opts_default_contrasts)
    },

    .predict = function(task) {
      pv = self$param_set$get_values(tags = "predict")
      newdata = ordered_features(task, self)
      se_fit = self$predict_type == "se"
      prediction = invoke(predict, object = self$model, newdata = newdata, se.fit = se_fit, .args = pv)

      if (se_fit) {
        list(response = unname(prediction$fit), se = unname(prediction$se.fit))
      } else {
        list(response = unname(prediction))
      }
    }
  )
)

#' @include aaa.R
learners[["regr.lm"]] = LearnerRegrLM
