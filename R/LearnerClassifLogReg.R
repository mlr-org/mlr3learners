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
#' @section Initial parameter values:
#' - `model`:
#'   - Actual default: `TRUE`.
#'   - Adjusted default: `FALSE`.
#'   - Reason for change: Save some memory.
#'
#' @section Offset:
#' If a `Task` has a column with the role `offset`, it will automatically be used during training.
#' The offset is incorporated through the formula interface to ensure compatibility with [stats::glm()].
#' We add it to the model formula as `offset(<column_name>)` and also include it in the training data.
#' During prediction, the default behavior is to use the offset column from the test set (enabled by `use_pred_offset = TRUE`).
#' Otherwise, if the user sets `use_pred_offset = FALSE`, a zero offset is applied, effectively disabling the offset adjustment during prediction.
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
        dispersion      = p_uty(default = NULL, tags = "predict"),
        epsilon         = p_dbl(default = 1e-8, tags = c("train", "control")),
        etastart        = p_uty(tags = "train"),
        maxit           = p_dbl(default = 25, tags = c("train", "control")),
        model           = p_lgl(default = TRUE, tags = "train"),
        mustart         = p_uty(tags = "train"),
        singular.ok     = p_lgl(default = TRUE, tags = "train"),
        start           = p_uty(default = NULL, tags = "train"),
        trace           = p_lgl(default = FALSE, tags = c("train", "control")),
        x               = p_lgl(default = FALSE, tags = "train"),
        y               = p_lgl(default = TRUE, tags = "train"),
        use_pred_offset = p_lgl(default = TRUE, tags = "predict")
      )

      ps$set_values(use_pred_offset = TRUE)

      super$initialize(
        id = "classif.log_reg",
        param_set = ps,
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric", "character", "factor", "ordered"),
        properties = c("weights", "twoclass", "offset"),
        packages = c("mlr3learners", "stats"),
        label = "Logistic Regression",
        man = "mlr3learners::mlr_learners_classif.log_reg"
      )
    }
  ),

  private = list(
    .train = function(task) {
      pv = self$param_set$get_values(tags = "train")
      pv$weights = get_weights(task, private)

      form = task$formula()
      data = task$data()

      if ("offset" %in% task$properties) {
        # we use the formula interface as `offset` = ... doesn't work during prediction
        offset_colname = task$col_roles$offset
        # re-write formula
        formula_terms = c(task$feature_names, paste0("offset(", offset_colname, ")"))
        # needs both `env = ...` and `quote = "left"` args to work
        form = mlr3misc::formulate(lhs = task$target_names, rhs = formula_terms, env = environment(), quote = "left")
        # add offset column to the data
        data = data[, (offset_colname) := task$offset$offset][]
      }

      # logreg expects the first label to be the negative class, contrary
      # to the mlr3 convention that the positive class comes first.
      tn = task$target_names
      data[[tn]] = swap_levels(data[[tn]])

      invoke(stats::glm,
        formula = form, data = data,
        family = "binomial", model = FALSE, .args = pv, .opts = opts_default_contrasts)
    },

    .predict = function(task) {
      pv = self$param_set$get_values(tags = "predict")
      lvls = c(task$negative, task$positive)
      newdata = ordered_features(task, self)

      if ("offset" %in% task$properties) {
        # add offset to the test data
        offset_colname = task$col_roles$offset
        newdata[, (offset_colname) := if (isTRUE(pv$use_pred_offset)) task$offset$offset else 0]
      }

      p = unname(invoke(predict, object = self$model, newdata = newdata, type = "response", .args = pv))

      if (self$predict_type == "response") {
        list(response = ifelse(p < 0.5, lvls[1L], lvls[2L]))
      } else {
        list(prob = pvec2mat(p, lvls))
      }
    }
  )
)

#' @include aaa.R
learners[["classif.log_reg"]] = LearnerClassifLogReg
