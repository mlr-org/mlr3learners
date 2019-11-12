#' @title Kriging Regression Learner
#'
#' @usage NULL
#' @aliases mlr_learners_regr.km
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerRegr].
#'
#' @section Construction:
#' ```
#' LearnerRegrKM$new()
#' mlr3::mlr_learners$get("regr.km")
#' mlr3::lrn("regr.km")
#' ```
#'
#' @description
#' Kriging regression.
#' Calls [DiceKriging::km()] from package \CRANpkg{DiceKriging}.
#'
#' * The predict type hyperparameter "type" defaults to "SK" (simple Kriging).
#' * The additional hyperparameter `nugget.stability` is used to overwrite the hyperparameter `nugget` with `nugget.stability * var(y)` before training to improve the numerical stability.
#'   We recommend a value of `1e-8`.
#' * The additional hyperparameter `jitter` can be set to add `N(0, [jitter])`-distributed noise to the data before prediction to avoid perfect interpolation. We recommend a value of `1e-12`.
#'
#' @references
#' \cite{mlr3learners}{roustant_2012}
#'
#' @export
#' @template seealso_learner
#' @templateVar learner_name regr.km
#' @template example
LearnerRegrKM = R6Class("LearnerRegrKM", inherit = LearnerRegr,
  public = list(
    initialize = function() {
      ps = ParamSet$new(list(
        ParamFct$new("covtype", default = "matern5_2", levels = c("gauss", "matern5_2", "matern3_2", "exp", "powexp"), tags = "train"),
        ParamUty$new("coef.trend", default = NULL, tags = "train"),
        ParamUty$new("coef.cov", default = NULL, tags = "train"),
        ParamUty$new("coef.var", default = NULL, tags = "train"),
        ParamDbl$new("nugget", tags = "train"),
        ParamLgl$new("nugget.estim", default = FALSE, tags = "train"),
        ParamDbl$new("nugget.stability", default = 0, lower = 0, tags = "train"),
        ParamUty$new("noise.var", default = NULL, tags = "train"),
        ParamFct$new("estim.method", default = "MLE", levels = c("MLE", "LOO"), tags = "train"),
        ParamUty$new("penalty", default = NULL, tags = "train"),
        ParamFct$new("optim.method", default = "BFGS", levels = c("BFGS", "gen"), tags = "train"),
        ParamUty$new("parinit", default = NULL, tags = "train"),
        ParamInt$new("multistart", default = 1, tags = "train"),
        ParamUty$new("lower", default = NULL, tags = "train"),
        ParamUty$new("upper", default = NULL, tags = "train"),
        ParamLgl$new("gr", default = TRUE, tags = "train"),
        ParamLgl$new("iso", default = FALSE, tags = "train"),
        ParamLgl$new("scaling", default = FALSE, tags = "train"),
        ParamUty$new("knots", default = NULL, tags = "train"),
        ParamUty$new("kernel", default = NULL, tags = "train"),
        ParamFct$new("type", default = "SK", levels = c("SK", "UK"), tags = "predict"),
        ParamDbl$new("jitter", default = 0, lower = 0, tags = "predict")
      ))
      ps$add_dep("multistart", "optim.method", CondEqual$new("BFGS"))
      ps$add_dep("knots", "scaling", CondEqual$new(TRUE))

      super$initialize(
        id = "regr.km",
        param_set = ps,
        predict_types = c("response", "se"),
        feature_types = c("integer", "numeric"),
        packages = "DiceKriging",
        man = "mlr3learners::mlr_learners_regr.km"
      )
    },

    train_internal = function(task) {

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
        pars$nugget = if (ns == 0) 0 else ns * var(truth)
      }

      invoke(DiceKriging::km,
        response = task$truth(),
        design = data,
        control = list(trace = FALSE),
        .args = remove_named(pars, "nugget.stability")
      )
    },

    predict_internal = function(task) {
      pars = self$param_set$get_values(tags = "predict")
      newdata = as.matrix(task$data(cols = task$feature_names))

      jitter = pars$jitter
      if (!is.null(jitter) && jitter > 0) {
        newdata = newdata + rnorm(length(newdata), mean = 0, sd = jitter)
      }

      p = invoke(DiceKriging::predict.km,
        self$model,
        newdata = newdata,
        type = pars$type %??% "SK",
        se.compute = self$predict_type == "se",
        .args = remove_named(pars, "jitter")
      )

      PredictionRegr$new(task = task, response = p$mean, se = p$sd)
    }
  )
)
