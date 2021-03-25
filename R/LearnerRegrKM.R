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
#' @template section_dictionary_learner
#' @templateVar id regr.km
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
        covtype = p_fct(default = "matern5_2", levels = c("gauss", "matern5_2", "matern3_2", "exp", "powexp"), tags = "train"),
        coef.trend = p_uty(default = NULL, tags = "train"),
        coef.cov = p_uty(default = NULL, tags = "train"),
        coef.var = p_uty(default = NULL, tags = "train"),
        nugget = p_dbl(tags = "train"),
        nugget.estim = p_lgl(default = FALSE, tags = "train"),
        nugget.stability = p_dbl(default = 0, lower = 0, tags = "train"),
        noise.var = p_uty(default = NULL, tags = "train"),
        estim.method = p_fct(default = "MLE", levels = c("MLE", "LOO"), tags = "train"),
        penalty = p_uty(default = NULL, tags = "train"),
        optim.method = p_fct(default = "BFGS", levels = c("BFGS", "gen"), tags = "train"),
        parinit = p_uty(default = NULL, tags = "train"),
        multistart = p_int(default = 1, tags = "train"),
        lower = p_uty(default = NULL, tags = "train"),
        upper = p_uty(default = NULL, tags = "train"),
        gr = p_lgl(default = TRUE, tags = "train"),
        iso = p_lgl(default = FALSE, tags = "train"),
        scaling = p_lgl(default = FALSE, tags = "train"),
        knots = p_uty(default = NULL, tags = "train"),
        kernel = p_uty(default = NULL, tags = "train"),
        type = p_fct(default = "SK", levels = c("SK", "UK"), tags = "predict"),
        jitter = p_dbl(default = 0, lower = 0, tags = "predict"),
        control = p_uty(default = NULL, tags = "train"),
        se.compute = p_lgl(default = TRUE, tags = "predict"),
        cov.compute = p_lgl(default = TRUE, tags = "predict"),
        light.return = p_lgl(default = FALSE, tags = "predict"),
        bias.correct = p_lgl(default = FALSE, tags = "predict"),
        checkNames = p_lgl(default = TRUE, tags = "predict")
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

      pars = self$param_set$get_values(tags = "train")
      data = as.matrix(task$data(cols = task$feature_names))
      truth = task$truth()

      if (!is.null(pars$optim.method)) {
        if (pars$optim.method == "gen" && !requireNamespace("rgenoud", quietly = TRUE)) {
          stop("The 'rgenoud' package is required for optimization method 'gen'.")
        }
      }

      ns = pars$nugget.stability
      if (!is.null(ns)) {
        pars$nugget = if (ns == 0) 0 else ns * stats::var(truth)
      }

      mlr3misc::invoke(DiceKriging::km,
        response = task$truth(),
        design = data,
        control = pars$control,
        .args = remove_named(pars, c("control", "nugget.stability"))
      )
    },

    .predict = function(task) {
      pars = self$param_set$get_values(tags = "predict")
      newdata = as.matrix(task$data(cols = task$feature_names))

      jitter = pars$jitter
      if (!is.null(jitter) && jitter > 0) {
        newdata = newdata + stats::rnorm(length(newdata), mean = 0, sd = jitter)
      }

      p = mlr3misc::invoke(DiceKriging::predict.km,
        self$model,
        newdata = newdata,
        type = if (is.null(pars$type)) "SK" else pars$type,
        se.compute = self$predict_type == "se",
        .args = remove_named(pars, "jitter")
      )

      list(response = p$mean, se = p$sd)
    }
  )
)
