#' @title GLM with Elastic Net Regularization Regression Learner
#'
#' @name mlr_learners_regr.glmnet
#'
#' @description
#' Generalized linear models with elastic net regularization.
#' Calls [glmnet::glmnet()] from package \CRANpkg{glmnet}.
#'
#' The default for hyperparameter `family` is set to `"gaussian"`.
#'
#' @inherit mlr_learners_classif.glmnet details
#' @inheritSection mlr_learners_classif.cv_glmnet Offset
#'
#' @templateVar id regr.glmnet
#' @template learner
#'
#' @references
#' `r format_bib("friedman_2010")`
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerRegrGlmnet = R6Class("LearnerRegrGlmnet",
  inherit = LearnerRegr,

  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ps(
        alignment             = p_fct(c("lambda", "fraction"), default = "lambda", tags = "train"),
        alpha                 = p_dbl(0, 1, default = 1, tags = "train"),
        big                   = p_dbl(default = 9.9e35, tags = "train"),
        devmax                = p_dbl(0, 1, default = 0.999, tags = "train"),
        dfmax                 = p_int(0L, tags = "train"),
        eps                   = p_dbl(0, 1, default = 1.0e-6, tags = "train"),
        epsnr                 = p_dbl(0, 1, default = 1.0e-8, tags = "train"),
        exact                 = p_lgl(default = FALSE, tags = "predict"),
        exclude               = p_int(1L, tags = "train"),
        exmx                  = p_dbl(default = 250.0, tags = "train"),
        family                = p_fct(c("gaussian", "poisson"), default = "gaussian", tags = "train"),
        fdev                  = p_dbl(0, 1, default = 1.0e-5, tags = "train"),
        gamma                 = p_dbl(default = 1, tags = "train", depends = quote(relax == TRUE)),
        grouped               = p_lgl(default = TRUE, tags = "train"),
        intercept             = p_lgl(default = TRUE, tags = "train"),
        keep                  = p_lgl(default = FALSE, tags = "train"),
        lambda                = p_uty(tags = "train"),
        lambda.min.ratio      = p_dbl(0, 1, tags = "train"),
        lower.limits          = p_uty(tags = "train"),
        maxit                 = p_int(1L, default = 100000L, tags = "train"),
        mnlam                 = p_int(1L, default = 5L, tags = "train"),
        mxit                  = p_int(1L, default = 100L, tags = "train"),
        mxitnr                = p_int(1L, default = 25L, tags = "train"),
        use_pred_offset       = p_lgl(default = TRUE, tags = "predict"),
        nlambda               = p_int(1L, default = 100L, tags = "train"),
        parallel              = p_lgl(default = FALSE, tags = "train"),
        penalty.factor        = p_uty(tags = "train"),
        pmax                  = p_int(0L, tags = "train"),
        pmin                  = p_dbl(0, 1, default = 1.0e-9, tags = "train"),
        prec                  = p_dbl(default = 1e-10, tags = "train"),
        relax                 = p_lgl(default = FALSE, tags = "train"),
        s                     = p_dbl(0, default = 0.01, tags = "predict"),
        standardize           = p_lgl(default = TRUE, tags = "train"),
        standardize.response  = p_lgl(default = FALSE, tags = "train"),
        thresh                = p_dbl(0, default = 1e-07, tags = "train"),
        trace.it              = p_int(0, 1, default = 0, tags = "train"),
        type.gaussian         = p_fct(c("covariance", "naive"), tags = "train", depends = quote(family == "gaussian")),
        type.logistic         = p_fct(c("Newton", "modified.Newton"), tags = "train"),
        type.multinomial      = p_fct(c("ungrouped", "grouped"), tags = "train"),
        upper.limits          = p_uty(tags = "train")
      )

      ps$set_values(family = "gaussian", use_pred_offset = TRUE)

      super$initialize(
        id = "regr.glmnet",
        param_set = ps,
        feature_types = c("logical", "integer", "numeric"),
        properties = c("weights", "offset"),
        packages = c("mlr3learners", "glmnet"),
        label = "GLM with Elastic Net Regularization",
        man = "mlr3learners::mlr_learners_regr.glmnet"
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

      response = invoke(predict, self$model,
        newx = newdata,
        type = "response", .args = pv)
      list(response = drop(response))
    }
  )
)

#' @include aaa.R
learners[["regr.glmnet"]] = LearnerRegrGlmnet
