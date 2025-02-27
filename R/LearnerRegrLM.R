#' @title Linear Model Regression Learner
#'
#' @name mlr_learners_regr.lm
#'
#' @description
#' Ordinary linear regression.
#' Calls [stats::lm()].
#'
#' @section Offset:
#'
#' In the latest mlr3 release (`v22.0.2`), we support an offset column in regression tasks.
#'
#' If a `Task` has a column with the role `offset`, it will automatically be used during training.
#' The offset is incorporated through the formula interface to ensure compatibility with [stats::lm()].
#' We add it to the model formula as `offset(<column_name>)` and also included it in the training data.
#'
#' During prediction, the offset column from the test set will be used only if `use_pred_offset = TRUE`.
#' By default, a zero offset is applied, effectively disabling the offset adjustment during prediction.
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
        pred.var      = p_uty(tags = "predict"),
        qr            = p_lgl(default = TRUE, tags = "train"),
        scale         = p_dbl(default = NULL, special_vals = list(NULL), tags = "predict"),
        singular.ok   = p_lgl(default = TRUE, tags = "train"),
        x             = p_lgl(default = FALSE, tags = "train"),
        y             = p_lgl(default = FALSE, tags = "train"),
        rankdeficient = p_fct(c("warnif", "simple", "non-estim", "NA", "NAwarn"), tags = "predict"),
        tol           = p_dbl(default = 1e-07, tags = "predict"),
        verbose       = p_lgl(default = FALSE, tags = "predict"),
        use_pred_offset = p_lgl(default = FALSE, tags = "predict")
      )

      super$initialize(
        id = "regr.lm",
        param_set = ps,
        predict_types = c("response", "se"),
        feature_types = c("logical", "integer", "numeric", "factor", "character"),
        properties = c("weights", "offset"),
        packages = c("mlr3learners", "stats"),
        label = "Linear Model",
        man = "mlr3learners::mlr_learners_regr.lm"
      )
    }
  ),

  private = list(
    .train = function(task) {
      pv = self$param_set$get_values(tags = "train")

      if ("weights" %in% task$properties) {
        pv = insert_named(pv, list(weights = task$weights$weight))
      }

      form = task$formula()
      data = task$data()

      if ("offset" %in% task$properties) {
        # we use the formula interface as `offset` = ... doesn't work during prediction
        offset_colname = task$col_roles$offset
        # re-write formula
        formula_terms = c(task$feature_names, paste0("offset(", offset_colname, ")"))
        # needs both `env = ...` and `quote = "left"` args to work
        form = mlr3misc::formulate(lhs = task$target_names, rhs = formula_terms,
                                   env = environment(), quote = "left")
        # add offset column to the data
        data = data[, (offset_colname) := task$offset$offset][]
      }

      invoke(stats::lm,
        formula = form, data = data,
        .args = pv, .opts = opts_default_contrasts)
    },

    .predict = function(task) {
      pv = self$param_set$get_values(tags = "predict")
      newdata = ordered_features(task, self)
      se_fit = self$predict_type == "se"

      if ("offset" %in% task$properties) {
        # add offset to the test data
        offset_colname = task$col_roles$offset
        newdata[, (offset_colname) := if (isTRUE(pv$use_pred_offset)) task$offset$offset else 0]
      }

      prediction = invoke(predict, object = self$model, newdata = newdata, se.fit = se_fit, .args = pv)

      # need to remove NAs for this crazy replication that using offset in lm does
      if ("offset" %in% task$properties) {
        prediction = prediction[!is.na(prediction)]
      }

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
