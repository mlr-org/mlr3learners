#' @title GLM with Elastic Net Regularization Classification Learner
#'
#' @name mlr_learners_classif.glmnet
#'
#' @description
#' Generalized linear models with elastic net regularization.
#' Calls [glmnet::glmnet()] from package \CRANpkg{glmnet}.
#'
#' @details
#' Caution: This learner is different to learners calling [glmnet::cv.glmnet()]
#' in that it does not use the internal optimization of parameter `lambda`.
#' Instead, `lambda` needs to be tuned by the user (e.g., via \CRANpkg{mlr3tuning}).
#' When `lambda` is tuned, the `glmnet` will be trained for each tuning iteration.
#' While fitting the whole path of `lambda`s would be more efficient, as is done
#' by default in [glmnet::glmnet()], tuning/selecting the parameter at prediction time
#' (using parameter `s`) is currently not supported in \CRANpkg{mlr3}
#' (at least not in efficient manner).
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
LearnerClassifGlmnet = R6Class("LearnerClassifGlmnet",
  inherit = LearnerClassif,

  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ps(
        alpha                = p_dbl(0, 1, default = 1, tags = "train"),
        big                  = p_dbl(default = 9.9e35, tags = "train"),
        devmax               = p_dbl(0, 1, default = 0.999, tags = "train"),
        dfmax                = p_int(0L, tags = "train"),
        eps                  = p_dbl(0, 1, default = 1.0e-6, tags = "train"),
        epsnr                = p_dbl(0, 1, default = 1.0e-8, tags = "train"),
        exact                = p_lgl(default = FALSE, tags = "predict"),
        exclude              = p_int(1L, tags = "train"),
        exmx                 = p_dbl(default = 250.0, tags = "train"),
        fdev                 = p_dbl(0, 1, default = 1.0e-5, tags = "train"),
        gamma                = p_dbl(default = 1, tags = "predict", depends = quote(relax == TRUE)),
        intercept            = p_lgl(default = TRUE, tags = "train"),
        lambda               = p_uty(tags = "train"),
        lambda.min.ratio     = p_dbl(0, 1, tags = "train"),
        lower.limits         = p_uty(tags = "train"),
        maxit                = p_int(1L, default = 100000L, tags = "train"),
        mnlam                = p_int(1L, default = 5, tags = "train"),
        mxit                 = p_int(1L, default = 100L, tags = "train"),
        mxitnr               = p_int(1L, default = 25L, tags = "train"),
        nlambda              = p_int(1L, default = 100L, tags = "train"),
        use_pred_offset      = p_lgl(default = FALSE, tags = "predict"),
        penalty.factor       = p_uty(tags = "train"),
        pmax                 = p_int(0L, tags = "train"),
        pmin                 = p_dbl(0, 1, default = 1.0e-9, tags = "train"),
        prec                 = p_dbl(default = 1e-10, tags = "train"),
        relax                = p_lgl(default = FALSE, tags = "train"),
        s                    = p_dbl(0, default = 0.01, tags = "predict"),
        standardize          = p_lgl(default = TRUE, tags = "train"),
        standardize.response = p_lgl(default = FALSE, tags = "train"),
        thresh               = p_dbl(0, default = 1e-07, tags = "train"),
        trace.it             = p_int(0, 1, default = 0, tags = "train"),
        type.gaussian        = p_fct(c("covariance", "naive"), tags = "train"),
        type.logistic        = p_fct(c("Newton", "modified.Newton"), tags = "train"),
        type.multinomial     = p_fct(c("ungrouped", "grouped"), tags = "train"),
        upper.limits         = p_uty(tags = "train")
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
      pv$family = ifelse(length(task$class_names) == 2L, "binomial", "multinomial")

      if ("weights" %in% task$properties) {
        pv$weights = task$weights$weight
      }

      pv = glmnet_set_offset(task, "train", pv)

      glmnet_invoke(data, target, pv)
    },

    .predict = function(task) {
      newdata = as_numeric_matrix(ordered_features(task, self))
      pv = self$param_set$get_values(tags = "predict")
      pv = rename(pv, "predict.gamma", "gamma")
      pv$s = glmnet_get_lambda(self, pv)

      pv = glmnet_set_offset(task, "predict", pv)

      if (self$predict_type == "response") {
        response = invoke(predict, self$model,
          newx = newdata, type = "class",
          .args = pv)
        list(response = drop(response))
      } else {
        prob = invoke(predict, self$model,
          newx = newdata, type = "response",
          .args = pv)

        if (length(task$class_names) == 2L) {
          # the docs are really not clear here; before we tried to reorder the class
          # labels alphabetically; this does not seem to be required, we instead rely on
          # the (undocumented) class labels as stored in the model
          prob = cbind(1 - prob, prob)
          colnames(prob) = self$model$classnames
        } else {
          prob = prob[, , 1L]
        }

        list(prob = prob)
      }
    }
  )
)

#' @include aaa.R
learners[["classif.glmnet"]] = LearnerClassifGlmnet
