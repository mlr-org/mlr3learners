#' @title Linear Model Regression Learner
#'
#' @name mlr_learners_regr.lm
#'
#' @description
#' Ordinary linear regression.
#' Calls [stats::lm()].
#'
#' @templateVar id regr.lm
#' @template section_dictionary_learner
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
        df          = p_dbl(default = Inf, tags = "predict"),
        interval    = p_fct(c("none", "confidence", "prediction"), tags = "predict"),
        level       = p_dbl(default = 0.95, tags = "predict"),
        model       = p_lgl(default = TRUE, tags = "train"),
        offset      = p_lgl(tags = "train"),
        pred.var    = p_uty(tags = "predict"),
        qr          = p_lgl(default = TRUE, tags = "train"),
        scale       = p_dbl(default = NULL, special_vals = list(NULL), tags = "predict"),
        se.fit      = p_lgl(default = FALSE, tags = "predict"),
        singular.ok = p_lgl(default = TRUE, tags = "train"),
        x           = p_lgl(default = FALSE, tags = "train"),
        y           = p_lgl(default = FALSE, tags = "train")
      )

      super$initialize(
        id = "regr.lm",
        param_set = ps,
        predict_types = c("response", "se"),
        feature_types = c("logical", "integer", "numeric", "factor", "character"),
        properties = c("weights", "loglik"),
        packages = "stats",
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
        pv = insert_named(pv, list(weights = task$weights$weight))
      }

      invoke(stats::lm,
        formula = task$formula(), data = task$data(),
        .args = pv, .opts = opts_default_contrasts)
    },

    .predict = function(task) {
      newdata = task$data(cols = task$feature_names)

      if (self$predict_type == "response") {
        response = predict(self$model, newdata = newdata, se.fit = FALSE)
        list(response = response)
      } else {
        pred = predict(self$model, newdata = newdata, se.fit = TRUE)
        list(response = pred$fit, se = pred$se.fit)
      }
    }
  )
)
