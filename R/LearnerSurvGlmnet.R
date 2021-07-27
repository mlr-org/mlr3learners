#' @title GLM with Elastic Net Regularization Survival Learner
#'
#' @name mlr_learners_surv.glmnet
#'
#' @description
#' Generalized linear models with elastic net regularization.
#' Calls [glmnet::glmnet()] from package \CRANpkg{glmnet}.
#'
#' The default for hyperparameter `family` is set to `"cox"`.
#'
#' @inherit mlr_learners_classif.glmnet details
#'
#' @templateVar id surv.glmnet
#' @template section_dictionary_learner
#'
#' @references
#' `r format_bib("friedman_2010")`
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerSurvGlmnet = R6Class("LearnerSurvGlmnet",
  inherit = mlr3proba::LearnerSurv,

  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ps(
        alpha            = p_dbl(0, 1, default = 1, tags = "train"),
        big              = p_dbl(default = 9.9e35, tags = "train"),
        devmax           = p_dbl(0, 1, default = 0.999, tags = "train"),
        dfmax            = p_int(0L, tags = "train"),
        eps              = p_dbl(0, 1, default = 1.0e-6, tags = "train"),
        epsnr            = p_dbl(0, 1, default = 1.0e-8, tags = "train"),
        exact            = p_lgl(default = FALSE, tags = "predict"),
        exclude          = p_uty(tags = "train"),
        exmx             = p_dbl(default = 250.0, tags = "train"),
        fdev             = p_dbl(0, 1, default = 1.0e-5, tags = "train"),
        intercept        = p_lgl(default = TRUE, tags = "train"),
        lambda           = p_uty(tags = "train"),
        lambda.min.ratio = p_dbl(0, 1, tags = "train"),
        lower.limits     = p_uty(default = -Inf, tags = "train"),
        maxit            = p_int(1L, default = 100000L, tags = "train"),
        mnlam            = p_int(1L, default = 5L, tags = "train"),
        mxit             = p_int(1L, default = 100L, tags = "train"),
        mxitnr           = p_int(1L, default = 25L, tags = "train"),
        newoffset        = p_uty(tags = "predict"),
        nlambda          = p_int(1L, default = 100L, tags = "train"),
        offset           = p_uty(default = NULL, tags = "train"),
        penalty.factor   = p_uty(tags = "train"),
        pmax             = p_int(0L, tags = "train"),
        pmin             = p_dbl(0, 1, default = 1.0e-9, tags = "train"),
        prec             = p_dbl(default = 1e-10, tags = "train"),
        relax            = p_lgl(default = FALSE, tags = "train"),
        s                = p_dbl(0, default = 0.01, tags = "predict"),
        standardize      = p_lgl(default = TRUE, tags = "train"),
        thresh           = p_dbl(0, default = 1e-07, tags = "train"),
        trace.it         = p_int(0, 1, default = 0, tags = "train"),
        type.logistic    = p_fct(c("Newton", "modified.Newton"), default = "Newton", tags = "train"),
        type.multinomial = p_fct(c("ungrouped", "grouped"), default = "ungrouped", tags = "train"),
        upper.limits     = p_uty(default = Inf, tags = "train")
      )

      super$initialize(
        id = "surv.glmnet",
        param_set = ps,
        feature_types = c("logical", "integer", "numeric"),
        predict_types = c("crank", "lp"),
        properties = "weights",
        packages = "glmnet",
        man = "mlr3learners::mlr_learners_surv.glmnet"
      )
    }
  ),

  private = list(
    .train = function(task) {

      pars = self$param_set$get_values(tags = "train")
      data = as.matrix(task$data(cols = task$feature_names))
      target = task$truth()

      if ("weights" %in% task$properties) {
        pars$weights = task$weights$weight
      }

      saved_ctrl = glmnet::glmnet.control()
      on.exit(mlr3misc::invoke(glmnet::glmnet.control, .args = saved_ctrl))
      glmnet::glmnet.control(factory = TRUE)
      is_ctrl_pars = (names(pars) %in% names(saved_ctrl))

      if (any(is_ctrl_pars)) {
        mlr3misc::invoke(glmnet::glmnet.control, .args = pars[is_ctrl_pars])
        pars = pars[!is_ctrl_pars]
      }

      mlr3misc::invoke(glmnet::glmnet, x = data, y = target, family = "cox", .args = pars)
    },

    .predict = function(task) {
      pars = self$param_set$get_values(tags = "predict")
      newdata = as.matrix(ordered_features(task, glmnet_feature_names(self$model)))

      # if model was fit with more then one lambda,
      # set to default such that only one prediction is returned
      if (is.null(pars$s) & length(self$model$lambda) > 1L) {
        warning("Multiple lambdas have been fit. For prediction, lambda will be set to 0.01 (see parameter 's').")
        pars$s = self$param_set$default$s
      }

      lp = invoke(predict, self$model, newx = newdata, type = "link", .args = pars)

      list(crank = lp, lp = lp)
    }
  )
)
