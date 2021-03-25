#' @title Logistic Regression Classification Learner
#'
#' @name mlr_learners_classif.log_reg
#'
#' @description
#' Classification via logistic regression.
#' Calls [stats::glm()] with `family` set to `"binomial"`.
#'
#' @section Custom mlr3 defaults:
#' - `model`:
#'   - Actual default: `TRUE`.
#'   - Adjusted default: `FALSE`.
#'   - Reason for change: Save some memory.
#'
#' @templateVar id classif.log_reg
#' @template section_dictionary_learner
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
        singular.ok = p_lgl(default = TRUE, tags = "train"),
        x = p_lgl(default = FALSE, tags = "train"),
        y = p_lgl(default = TRUE, tags = "train"),
        model = p_lgl(default = TRUE, tags = "train"),
        etastart = p_uty(tags = "train"),
        mustart = p_uty(tags = "train"),
        start = p_uty(default = NULL, tags = "train"),
        offset = p_uty(tags = "train"),
        epsilon = p_dbl(default = 1e-8, tags = c("train", "control")),
        maxit = p_dbl(default = 25, tags = c("train", "control")),
        trace = p_lgl(default = FALSE, tags = c("train", "control")),
        se.fit = p_lgl(default = FALSE, tags = "predict"),
        dispersion = p_uty(default = NULL, tags = "predict")
      )

      super$initialize(
        id = "classif.log_reg",
        param_set = ps,
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric", "character", "factor", "ordered"),
        properties = c("weights", "twoclass"),
        packages = "stats",
        man = "mlr3learners::mlr_learners_classif.log_reg"
      )
    }
  ),

  private = list(
    .train = function(task) {
      pars = self$param_set$get_values(tags = "train")
      if ("weights" %in% task$properties) {
        pars = insert_named(pars, list(weights = task$weights$weight))
      }

      mlr3misc::invoke(stats::glm,
        formula = task$formula(), data = task$data(),
        family = "binomial", model = FALSE, .args = pars, .opts = opts_default_contrasts)
    },

    .predict = function(task) {
      newdata = task$data(cols = task$feature_names)

      p = unname(predict(self$model, newdata = newdata, type = "response"))
      levs = levels(self$model$data[[task$target_names]])

      if (self$predict_type == "response") {
        list(response = ifelse(p < 0.5, levs[1L], levs[2L]))
      } else {
        list(prob = pvec2mat(p, levs))
      }
    }
  )
)
