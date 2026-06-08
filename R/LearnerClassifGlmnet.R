#' @title GLM with Elastic Net Regularization Classification Learner
#'
#' @name mlr_learners_classif.glmnet
#'
#' @description
#' Generalized linear models with elastic net regularization.
#' Calls [glmnet::glmnet()] from package \CRANpkg{glmnet}.
#'
#' The default for hyperparameter `family` is set to `"binomial"` or `"multinomial"`,
#' depending on the number of classes.
#'
#' @details
#' Caution: This learner is different to learners calling [glmnet::cv.glmnet()]
#' in that it does not use the internal optimization of parameter `lambda`.
#' Instead, `lambda` needs to be tuned by the user (e.g., via \CRANpkg{mlr3tuning}).
#' When `lambda` is tuned, the `glmnet` will be trained for each tuning iteration.
#' While fitting the whole path of `lambda`s would be more efficient, as is done
#' by default in [glmnet::glmnet()], tuning/selecting the parameter at prediction time
#' (using parameter `s`) is currently not supported in \CRANpkg{mlr3}
#' (at least not in an efficient manner).
#' Tuning the `s` parameter is, therefore, currently discouraged.
#'
#' When the data are i.i.d. and efficiency is key, we recommend using the respective
#' auto-tuning counterparts in [mlr_learners_classif.cv_glmnet()] or
#' [mlr_learners_regr.cv_glmnet()].
#' However, in some situations this is not applicable, usually when data are
#' imbalanced or not i.i.d. (longitudinal, time-series) and tuning requires
#' custom resampling strategies (blocked design, stratification).
#'
#' @inheritSection mlr_learners_classif.log_reg Internal Encoding
#' @inheritSection mlr_learners_classif.cv_glmnet Offset
#'
#' @templateVar id classif.glmnet
#' @template learner
#'
#' @references
#' `r format_bib("friedman_2010")`
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerClassifGlmnet = R6Class(
  "LearnerClassifGlmnet",
  inherit = LearnerClassif,

  public = list(
    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      # fmt: skip
      ps = ps(
        # glmnet::glmnet() parameters
        alpha            = p_dbl(0, 1, default = 1, tags = "train"),
        nlambda          = p_int(1L, default = 100L, tags = "train"),
        lambda.min.ratio = p_dbl(0, 1, tags = "train"),
        lambda           = p_uty(default = NULL, tags = "train"),
        standardize      = p_lgl(default = TRUE, tags = "train"),
        intercept        = p_lgl(default = TRUE, tags = "train"),
        exclude          = p_uty(default = NULL, tags = "train"),
        penalty.factor   = p_uty(tags = "train"),
        lower.limits     = p_uty(default = -Inf, tags = "train"),
        upper.limits     = p_uty(default = Inf, tags = "train"),
        type.logistic    = p_fct(c("Newton", "modified.Newton"), tags = "train"),
        type.multinomial = p_fct(c("ungrouped", "grouped"), tags = "train"),
        relax            = p_lgl(default = FALSE, tags = "train"),
        trace.it         = p_int(0, 1, default = 0, tags = "train"), # alias: itrace
        # glmnet::relax.glmnet() parameters
        maxp             = p_int(1L, tags = "train"),
        path             = p_lgl(default = FALSE, tags = "train"),
        # glmnet::glmnet.control() parameters
        fdev             = p_dbl(0, 1, default = 1.0e-5, tags = "train"),
        devmax           = p_dbl(0, 1, default = 0.999, tags = "train"),
        eps              = p_dbl(0, 1, default = 1.0e-6, tags = "train"),
        big              = p_dbl(default = 9.9e+35, tags = "train"),
        mnlam            = p_int(1L, default = 5L, tags = "train"),
        pmin             = p_dbl(0, 1, default = 1.0e-9, tags = "train"),
        exmx             = p_dbl(default = 250L, tags = "train"),
        prec             = p_dbl(default = 1e-10, tags = "train"),
        mxit             = p_int(1L, default = 100L, tags = "train"),
        epsnr            = p_dbl(0, 1, default = 1.0e-6, tags = "train"),
        mxitnr           = p_int(1L, default = 25L, tags = "train"),
        thresh           = p_dbl(0L, default = 1e-07, tags = "train"),
        maxit            = p_int(1L, default = 1e+05, tags = "train"),
        dfmax            = p_int(0L, default = NULL, special_vals = list(NULL), tags = "train"),
        pmax             = p_int(0L, default = NULL, special_vals = list(NULL), tags = "train"),
        # glmnet::predict.glmnet() parameters
        exact            = p_lgl(default = FALSE, tags = "predict"),
        s                = p_dbl(0L, default = 0.01, tags = "predict"),
        # glmnet::predict.relaxed() parameters
        gamma            = p_dbl(0, 1, default = 1L, tags = "predict"),
        # for using the offset during prediction
        use_pred_offset  = p_lgl(init = TRUE, tags = "predict")
      )

      super$initialize(
        id = "classif.glmnet",
        param_set = ps,
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric"),
        properties = c("weights", "twoclass", "multiclass", "offset"),
        packages = c("mlr3learners", "glmnet"),
        label = "GLM with Elastic Net Regularization",
        man = "mlr3learners::mlr_learners_classif.glmnet"
      )
    },

    #' @description
    #' Returns the set of selected features as reported by [glmnet::predict.glmnet()]
    #' with `type` set to `"nonzero"`.
    #'
    #' @param lambda (`numeric(1)`)\cr
    #' Custom `lambda`, defaults to the active lambda depending on parameter set.
    #'
    #' @return (`character()`) of feature names.
    selected_features = function(lambda = NULL) {
      glmnet_selected_features(self, lambda)
    }
  ),

  private = list(
    .train = function(task) {
      data = as_numeric_matrix(task$data(cols = task$feature_names))
      target = swap_levels(task$truth())
      pv = self$param_set$get_values(tags = "train")
      pv$family = if (length(task$class_names) == 2L) "binomial" else "multinomial"
      pv$weights = get_weights(task, private)
      pv = glmnet_set_offset(task, "train", pv)

      glmnet_invoke(data, target, pv)
    },

    .predict = function(task) {
      newdata = as_numeric_matrix(ordered_features(task, self))
      pv = self$param_set$get_values(tags = "predict")
      pv$s = glmnet_get_lambda(self, pv)

      pv = glmnet_set_offset(task, "predict", pv)

      if (self$predict_type == "response") {
        response = invoke(predict, self$model, newx = newdata, type = "class", .args = pv)
        raw = response
        result = list(response = drop(response))
      } else {
        prob = invoke(predict, self$model, newx = newdata, type = "response", .args = pv)
        raw = prob

        if (length(task$class_names) == 2L) {
          # the docs are really not clear here; before we tried to reorder the class
          # labels alphabetically; this does not seem to be required, we instead rely on
          # the (undocumented) class labels as stored in the model
          prob = cbind(1 - prob, prob)
          colnames(prob) = self$model$classnames
        } else {
          prob = prob[,, 1L]
        }

        result = list(prob = prob)
      }

      if (self$predict_raw) {
        result$raw = raw
      }
      result
    }
  )
)

#' @include aaa.R
learners[["classif.glmnet"]] = LearnerClassifGlmnet
