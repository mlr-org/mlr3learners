#' @title GLM with Elastic Net Regularization Classification Learner
#'
#' @name mlr_learners_classif.cv_glmnet
#'
#' @description
#' Generalized linear models with elastic net regularization.
#' Calls [glmnet::cv.glmnet()] from package \CRANpkg{glmnet}.
#'
#' The default for hyperparameter `family` is set to `"binomial"` or `"multinomial"`,
#' depending on the number of classes.
#'
#' @inheritSection mlr_learners_classif.log_reg Internal Encoding
#'
#' @section Offset:
#' If a `Task` contains a column with the `offset` role, it is automatically incorporated during training via the `offset` argument in [glmnet::glmnet()].
#' During prediction, the offset column from the test set is used only if `use_pred_offset = TRUE` (default), passed via the `newoffset` argument in [glmnet::predict.glmnet()].
#' Otherwise, if the user sets `use_pred_offset = FALSE`, a zero offset is applied, effectively disabling the offset adjustment during prediction.
#'
#' @templateVar id classif.cv_glmnet
#' @template learner
#'
#' @references
#' `r format_bib("friedman_2010")`
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerClassifCVGlmnet = R6Class("LearnerClassifCVGlmnet",
  inherit = LearnerClassif,

  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ps(
        alignment            = p_fct(c("lambda", "fraction"), default = "lambda", tags = "train"),
        alpha                = p_dbl(0, 1, default = 1, tags = "train"),
        big                  = p_dbl(tags = "train", default = 9.9e35),
        devmax               = p_dbl(0, 1, default = 0.999, tags = "train"),
        dfmax                = p_int(0L, tags = "train"),
        epsnr                = p_dbl(0, 1, default = 1.0e-8, tags = "train"),
        eps                  = p_dbl(0, 1, default = 1.0e-6, tags = "train"),
        exclude              = p_int(1L, tags = "train"),
        exmx                 = p_dbl(default = 250.0, tags = "train"),
        fdev                 = p_dbl(0, 1, default = 1.0e-5, tags = "train"),
        foldid               = p_uty(default = NULL, tags = "train"),
        gamma                = p_uty(tags = "train", depends = quote(relax == TRUE)),
        grouped              = p_lgl(default = TRUE, tags = "train"),
        intercept            = p_lgl(default = TRUE, tags = "train"),
        keep                 = p_lgl(default = FALSE, tags = "train"),
        lambda.min.ratio     = p_dbl(0, 1, tags = "train"),
        lambda               = p_uty(tags = "train"),
        lower.limits         = p_uty(tags = "train"),
        maxit                = p_int(1L, default = 100000L, tags = "train"),
        mnlam                = p_int(1L, default = 5, tags = "train"),
        mxitnr               = p_int(1L, default = 25L, tags = "train"),
        mxit                 = p_int(1L, default = 100L, tags = "train"),
        nfolds               = p_int(3L, default = 10L, tags = "train"),
        nlambda              = p_int(1L, default = 100L, tags = "train"),
        use_pred_offset      = p_lgl(default = TRUE, tags = "predict"),
        parallel             = p_lgl(default = FALSE, tags = "train"),
        penalty.factor       = p_uty(tags = "train"),
        pmax                 = p_int(0L, tags = "train"),
        pmin                 = p_dbl(0, 1, default = 1.0e-9, tags = "train"),
        prec                 = p_dbl(default = 1e-10, tags = "train"),
        predict.gamma        = p_dbl(default = "gamma.1se", special_vals = list("gamma.1se", "gamma.min"), tags = "predict"),
        relax                = p_lgl(default = FALSE, tags = "train"),
        s                    = p_dbl(0, special_vals = list("lambda.1se", "lambda.min"), default = "lambda.1se", tags = "predict"),
        standardize          = p_lgl(default = TRUE, tags = "train"),
        standardize.response = p_lgl(default = FALSE, tags = "train"),
        thresh               = p_dbl(0, default = 1e-07, tags = "train"),
        trace.it             = p_int(0, 1, default = 0, tags = "train"),
        type.gaussian        = p_fct(c("covariance", "naive"), tags = "train"),
        type.logistic        = p_fct(c("Newton", "modified.Newton"), tags = "train"),
        type.measure         = p_fct(c("deviance", "class", "auc", "mse", "mae"), default = "deviance", tags = "train"),
        type.multinomial     = p_fct(c("ungrouped", "grouped"), tags = "train"),
        upper.limits         = p_uty(tags = "train")
      )

      ps$set_values(use_pred_offset = TRUE)

      super$initialize(
        id = "classif.cv_glmnet",
        param_set = ps,
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric"),
        properties = c("weights", "twoclass", "multiclass", "selected_features", "offset"),
        packages = c("mlr3learners", "glmnet"),
        label = "GLM with Elastic Net Regularization",
        man = "mlr3learners::mlr_learners_classif.cv_glmnet"
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
      pv$weights = get_weights(task, private)

      pv = glmnet_set_offset(task, "train", pv)

      glmnet_invoke(data, target, pv, cv = TRUE)
    },

    .predict = function(task) {
      newdata = as_numeric_matrix(ordered_features(task, self))
      pv = self$param_set$get_values(tags = "predict")
      pv = rename(pv, "predict.gamma", "gamma")

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
          colnames(prob) = self$model$glmnet.fit$classnames
        } else {
          prob = prob[, , 1L]
        }

        list(prob = prob)
      }
    }
  )
)

#' @include aaa.R
learners[["classif.cv_glmnet"]] = LearnerClassifCVGlmnet
