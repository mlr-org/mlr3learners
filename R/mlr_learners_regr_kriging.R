#' @title Kriging Regression Learner
#'
#' @name mlr_learners_regr.kriging
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerRegr].
#'
#' @description
#' Kriging regression model.
#' Calls [DiceKriging::km()] from package \CRANpkg{DiceKriging}.
#'
#' @export
LearnerRegrKriging = R6Class("LearnerRegrKriging", inherit = LearnerRegr,
  public = list(
    initialize = function(id = "regr.kriging") {
      super$initialize(
        id = id,
        param_set = ParamSet$new(
          params = list(
            ParamFct$new(id = "covtype", default = "matern5_2",
              levels = c("gauss", "matern5_2", "matern3_2", "exp", "powexp"), tags = "train"),
            ParamDbl$new(id = "coef.trend", tags = "train"),
            ParamDbl$new(id = "coef.cov", tags = "train"),
            ParamDbl$new(id = "coef.var", tags = "train"),
            ParamDbl$new(id = "nugget", tags = "train"),
            ParamLgl$new(id = "nugget.estim", default = FALSE, tags = "train"),
            ParamDbl$new(id = "noise.var", tags = "train"),
            ParamFct$new(id = "estim.method", default = "MLE", levels = c("MLE", "LOO"), tags = "train"),
            ParamFct$new(id = "optim.method", default = "BFGS", levels = c("BFGS", "gen"), tags = "train"),
            ParamDbl$new(id = "lower", tags = "train"),
            ParamDbl$new(id = "upper", tags = "train"),
            ParamDbl$new(id = "parinit", tags = "train"),
            ParamInt$new(id = "multistart", default = 1L, lower = 1L, tags = "train"),
            ParamUty$new(id = "control", tags = "train"),
            ParamLgl$new(id = "gr", default = TRUE, tags = "train"),
            ParamLgl$new(id = "iso", default = FALSE, tags = "train"),
            ParamLgl$new(id = "scaling", default = FALSE, tags = "train"),
            ParamUty$new(id = "knots", tags = "train"),
            ParamUty$new(id = "kernel", tags = "train"),
            ParamLgl$new(id = "jitter", default = FALSE, tags = "predict"),
            ParamDbl$new(id = "nugget.stability", tags = "train")#  requires = quote(!nugget.estim && is.null(nugget)))
          )
        ),
        predict_types = c("response", "se"),
        # feature_types = c("logical", "integer", "numeric", "character", "factor", "ordered"),
        feature_types = c("integer", "numeric"),
        # properties = "weights",
        # note = 'In predict, we currently always use `type = "SK"`. The extra parameter `jitter` (default is `FALSE`) enables adding a very small jitter (order 1e-12) to the x-values before prediction, as `predict.km` reproduces the exact y-values of the training data points, when you pass them in, even if the nugget effect is turned on. \n We further introduced `nugget.stability` which sets the `nugget` to `nugget.stability * var(y)` before each training to improve numerical stability. We recommend a setting of 10^-8',
        packages = "DiceKriging"
      )
    },

    train = function(task) {
      pars = self$params("train")

      if (!is.null(pars$optim.method) && pars$optim.method == "gen") {
        requirePackages(packs = "rgenoud", why = "fitting 'regr_kriging' with 'rgenoud' optimization")
      }
      if (!is.null(pars$nugget.stability)) {
        if (pars$nugget.stability == 0) {
          pars$nugget = 0
        } else {
          pars$nugget = pars$nugget.stability * var(task$truth())
        }
        pars$nugget.stability = NULL
      }

      self$model = invoke(DiceKriging::km,
        design = task$data(cols = task$feature_names),
        response = task$truth(),
        .args = pars
      )
      self
    },

    predict = function(task) {
      pars = self$params("predict")
      newdata = task$data(cols = task$feature_names)
      response = se = NULL

      if (!is.null(pars$jitter) && pars$jitter) {
        jit = matrix(rnorm(nrow(newdata) * ncol(newdata), mean = 0, sd = 1e-12), nrow = nrow(newdata))
        newdata = newdata + jit
      }

      s = self$predict_type != "response"
      p = DiceKriging::predict.km(self$model, newdata = newdata, type = "SK", se.compute = s)
      response = p$mean
      if (s) {
        se =  p$sd
      }


      PredictionRegr$new(task, response, se)
    }
  )
)
