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
      ps = ParamSet$new(list(
        ParamLgl$new("x", default = FALSE, tags = "train"),
        ParamLgl$new("y", default = FALSE, tags = "train"),
        ParamLgl$new("model", default = TRUE, tags = "train"),
        ParamLgl$new("qr", default = TRUE, tags = "train"),
        ParamLgl$new("singular.ok", default = TRUE, tags = "train"),
        ParamLgl$new("offset", tags = "train"),
        ParamLgl$new("se.fit", default = FALSE, tags = "predict"),
        ParamDbl$new("scale", default = NULL, special_vals = list(NULL), tags = "predict"),
        ParamDbl$new("df", default = Inf, tags = "predict"),
        ParamFct$new("interval", levels = c("none", "confidence", "prediction"), tags = "predict"),
        ParamDbl$new("level", default = 0.95, tags = "predict"),
        ParamUty$new("pred.var", tags = "predict")
      ))

      super$initialize(
        id = "regr.lm",
        param_set = ps,
        predict_types = c("response", "se"),
        feature_types = c("logical", "integer", "numeric", "factor"),
        properties = "weights",
        packages = "stats",
        man = "mlr3learners::mlr_learners_regr.lm"
      )
    }
  ),

  private = list(
    .train = function(task) {
      pars = self$param_set$get_values(tags = "train")
      if ("weights" %in% task$properties) {
        pars = insert_named(pars, list(weights = task$weights$weight))
      }

      mlr3misc::invoke(stats::lm,
        formula = task$formula(), data = task$data(),
        .args = pars, .opts = opts_default_contrasts)
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
