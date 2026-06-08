#' @title GLM with Elastic Net Regularization Regression Learner
#'
#' @name mlr_learners_regr.cv_glmnet
#'
#' @description
#' Generalized linear models with elastic net regularization.
#' Calls [glmnet::cv.glmnet()] from package \CRANpkg{glmnet}.
#'
#' Supported `family` values are `"gaussian"` and `"poisson"`.
#' The default for the hyperparameter `family` is `"gaussian"`.
#'
#' @inheritSection mlr_learners_classif.cv_glmnet Offset
#'
#' @templateVar id regr.cv_glmnet
#' @template learner
#'
#' @references
#' `r format_bib("friedman_2010")`
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerRegrCVGlmnet = R6Class(
  "LearnerRegrCVGlmnet",
  inherit = LearnerRegr,

  public = list(
    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      # fmt: skip
      # nolint start
      ps = ps(
        # glmnet::cv.glmnet() parameters
        lambda           = p_uty(default = NULL, tags = "train"),
        type.measure     = p_fct(c("deviance", "mse", "mae"), default = "deviance", tags = "train"),
        nfolds           = p_int(3L, default = 10L, tags = "train"),
        foldid           = p_uty(default = NULL, tags = "train"),
        alignment        = p_fct(c("lambda", "fraction"), default = "lambda", tags = "train"),
        grouped          = p_lgl(default = TRUE, tags = "train"),
        keep             = p_lgl(default = FALSE, tags = "train"),
        parallel         = p_lgl(default = FALSE, tags = "train"),
        gamma            = p_uty(default = c(0, 0.25, 0.5, 0.75, 1), tags = "train", depends = quote(relax == TRUE)),
        relax            = p_lgl(default = FALSE, tags = "train"),
        trace.it         = p_int(0, 1, default = 0, tags = "train"), # alias: itrace
        # glmnet::glmnet() parameters
        family           = p_fct(c("gaussian", "poisson"), default = "gaussian", tags = "train"),
        alpha            = p_dbl(0, 1, default = 1, tags = "train"),
        nlambda          = p_int(1L, default = 100L, tags = "train"),
        lambda.min.ratio = p_dbl(0, 1, tags = "train"),
        standardize      = p_lgl(default = TRUE, tags = "train"),
        intercept        = p_lgl(default = TRUE, tags = "train"),
        exclude          = p_uty(default = NULL, tags = "train"),
        penalty.factor   = p_uty(tags = "train"),
        lower.limits     = p_uty(default = -Inf, tags = "train"),
        upper.limits     = p_uty(default = Inf, tags = "train"),
        type.gaussian    = p_fct(c("covariance", "naive"), tags = "train", depends = quote(family == "gaussian")),
        # glmnet::relax.glmnet() parameters
        maxp             = p_int(1L, tags = "train"),
        path             = p_lgl(default = FALSE, tags = "train"),
        # glmnet::glmnet.control() parameters
        fdev             = p_dbl(0, 1, default = 1.0e-5, tags = "train"),
        devmax           = p_dbl(0, 1, default = 0.999, tags = "train"),
        eps              = p_dbl(0, 1, default = 1.0e-6, tags = "train"),
        big              = p_dbl(default = 9.9e+35, tags = "train"),
        mnlam            = p_int(default = 5L, tags = "train"),
        pmin             = p_dbl(0, 1, default = 1.0e-9, tags = "train"),
        exmx             = p_dbl(default = 250L, tags = "train"),
        prec             = p_dbl(default = 1e-10, tags = "train"),
        mxit             = p_int(1L, default = 100L, tags = "train"),
        epsnr            = p_dbl(0, 1, default = 1.0e-6, tags = "train"),
        mxitnr           = p_int(1L, default = 25L, tags = "train"),
        thresh           = p_dbl(0L, default = 1e-07, tags = "train"),
        maxit            = p_int(1L, default = 1e+05, tags = "train"),
        dfmax            = p_int(default = NULL, special_vals = list(NULL), tags = "train"),
        pmax             = p_int(default = NULL, special_vals = list(NULL), tags = "train"),
        # glmnet::predict.cv.glmnet() and glmnet::predict.cv.relaxed() parameters
        s                = p_dbl(0L, special_vals = list("lambda.1se", "lambda.min"), default = "lambda.1se", tags = "predict"),
        predict.gamma    = p_dbl(0, 1, default = "gamma.1se", special_vals = list("gamma.1se", "gamma.min"), tags = "predict"), # renamed from 'gamma' to avoid duplication
        # glmnet::predict.glmnet() parameters
        exact            = p_lgl(default = FALSE, tags = "predict"),
        # for using the offset during prediction
        use_pred_offset  = p_lgl(init = TRUE, tags = "predict")
      )
      # nolint end

      ps$set_values(family = "gaussian")

      super$initialize(
        id = "regr.cv_glmnet",
        param_set = ps,
        feature_types = c("logical", "integer", "numeric"),
        properties = c("weights", "selected_features", "offset"),
        packages = c("mlr3learners", "glmnet"),
        label = "GLM with Elastic Net Regularization",
        man = "mlr3learners::mlr_learners_regr.cv_glmnet"
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
      target = as_numeric_matrix(task$data(cols = task$target_names))
      pv = self$param_set$get_values(tags = "train")
      pv$weights = get_weights(task, private)

      pv = glmnet_set_offset(task, "train", pv)

      glmnet_invoke(data, target, pv, cv = TRUE)
    },

    .predict = function(task) {
      newdata = as_numeric_matrix(ordered_features(task, self))
      pv = self$param_set$get_values(tags = "predict")
      pv = rename(pv, "predict.gamma", "gamma")

      pv = glmnet_set_offset(task, "predict", pv)

      response = invoke(predict, self$model, newx = newdata, type = "response", .args = pv)
      result = list(response = drop(response))
      if (self$predict_raw) {
        result$raw = response
      }
      result
    }
  )
)

#' @include aaa.R
learners[["regr.cv_glmnet"]] = LearnerRegrCVGlmnet
