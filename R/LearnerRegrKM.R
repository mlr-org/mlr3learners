#' @title Kriging Regression Learner
#'
#' @name mlr_learners_regr.km
#'
#' @description
#' Kriging regression.
#' Calls [DiceKriging::km()] from package \CRANpkg{DiceKriging}.
#'
#' * The predict type hyperparameter "type" defaults to "sk" (simple kriging).
#' * The additional hyperparameter `nugget.stability` is used to overwrite the
#'   hyperparameter `nugget` with `nugget.stability * var(y)` before training to
#'   improve the numerical stability. We recommend a value of `1e-8`.
#' * The additional hyperparameter `jitter` can be set to add
#'   `N(0, [jitter])`-distributed noise to the data before prediction to avoid
#'   perfect interpolation. We recommend a value of `1e-12`.
#'
#' @templateVar id regr.km
#' @template learner
#'
#' @references
#' `r format_bib("roustant_2012")`
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerRegrKM = R6Class("LearnerRegrKM",
  inherit = LearnerRegr,

  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ps(
        bias.correct     = p_lgl(default = FALSE, tags = "predict"),
        checkNames       = p_lgl(default = TRUE, tags = "predict"),
        coef.cov         = p_uty(default = NULL, tags = "train"),
        coef.trend       = p_uty(default = NULL, tags = "train"),
        coef.var         = p_uty(default = NULL, tags = "train"),
        control          = p_uty(default = NULL, tags = "train"),
        cov.compute      = p_lgl(default = TRUE, tags = "predict"),
        covtype          = p_fct(c("gauss", "matern5_2", "matern3_2", "exp", "powexp"), default = "matern5_2", tags = "train"),
        estim.method     = p_fct(c("MLE", "LOO"), default = "MLE", tags = "train"),
        gr               = p_lgl(default = TRUE, tags = "train"),
        iso              = p_lgl(default = FALSE, tags = "train"),
        jitter           = p_dbl(0, default = 0, tags = "predict"),
        kernel           = p_uty(default = NULL, tags = "train"),
        knots            = p_uty(default = NULL, tags = "train"),
        light.return     = p_lgl(default = FALSE, tags = "predict"),
        lower            = p_uty(default = NULL, tags = "train"),
        multistart       = p_int(default = 1, tags = "train"),
        noise.var        = p_uty(default = NULL, tags = "train"),
        nugget           = p_dbl(tags = "train"),
        nugget.estim     = p_lgl(default = FALSE, tags = "train"),
        nugget.stability = p_dbl(0, default = 0, tags = "train"),
        optim.method     = p_fct(c("BFGS", "gen"), default = "BFGS", tags = "train"),
        parinit          = p_uty(default = NULL, tags = "train"),
        penalty          = p_uty(default = NULL, tags = "train"),
        scaling          = p_lgl(default = FALSE, tags = "train"),
        se.compute       = p_lgl(default = TRUE, tags = "predict"),
        type             = p_fct(c("SK", "UK"), default = "SK", tags = "predict"),
        upper            = p_uty(default = NULL, tags = "train")
      )
      ps$add_dep("multistart", "optim.method", CondEqual$new("BFGS"))
      ps$add_dep("knots", "scaling", CondEqual$new(TRUE))

      super$initialize(
        id = "regr.km",
        param_set = ps,
        predict_types = c("response", "se"),
        feature_types = c("logical", "integer", "numeric"),
        packages = "DiceKriging",
        man = "mlr3learners::mlr_learners_regr.km"
      )
    }
  ),

  private = list(
    .train = function(task) {

      pv = self$param_set$get_values(tags = "train")
      data = as.matrix(task$data(cols = task$feature_names))
      truth = task$truth()

      if (!is.null(pv$optim.method)) {
        if (pv$optim.method == "gen" && !requireNamespace("rgenoud", quietly = TRUE)) {
          stop("The 'rgenoud' package is required for optimization method 'gen'.")
        }
      }

      ns = pv$nugget.stability
      if (!is.null(ns)) {
        pv$nugget = if (ns == 0) 0 else ns * stats::var(truth)
      }

      invoke(DiceKriging::km,
        response = task$truth(),
        design = data,
        control = pv$control,
        .args = remove_named(pv, c("control", "nugget.stability"))
      )
    },

    .predict = function(task) {
      pv = self$param_set$get_values(tags = "predict")
      newdata = as.matrix(task$data(cols = task$feature_names))

      jitter = pv$jitter
      if (!is.null(jitter) && jitter > 0) {
        newdata = newdata + stats::rnorm(length(newdata), mean = 0, sd = jitter)
      }

      p = invoke(DiceKriging::predict.km,
        self$model,
        newdata = newdata,
        type = if (is.null(pv$type)) "SK" else pv$type,
        se.compute = self$predict_type == "se",
        .args = remove_named(pv, "jitter")
      )

      list(response = p$mean, se = p$sd)
    }
  )
)
