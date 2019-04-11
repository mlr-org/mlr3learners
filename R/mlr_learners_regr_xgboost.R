#' @title Extreme Gradient Boosting Regressiong Learner
#'
#' @name mlr_learners_regr.xgboost
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerRegr].
#'
#' @description
#' A [mlr3::LearnerRegr] for eXtreme Gradient Boosting implemented in [xgboost::xgb.train()] in package \CRANpkg{xgboost}.
#'
#' @export
LearnerRegrXgboost = R6Class("LearnerRegrXgboost", inherit = LearnerRegr,
  public = list(
    initialize = function(id = "regr.xgboost") {
      super$initialize(
        id = id,
        param_set = ParamSet$new(
          params = list(
            # we pass all of what goes in 'params' directly to ... of xgboost
            # ParamUty$new(id = "params", default = list()),
            ParamFct$new(id = "booster", default = "gbtree", levels = c("gbtree", "gblinear", "dart"), tags = "train"),
            ParamUty$new(id = "watchlist", default = NULL, tags = "train"),
            ParamDbl$new(id = "eta", default = 0.3, lower = 0, upper = 1, tags = "train"),
            ParamDbl$new(id = "gamma", default = 0, lower = 0, tags = "train"),
            ParamInt$new(id = "max_depth", default = 6L, lower = 1L, tags = "train"),
            ParamDbl$new(id = "min_child_weight", default = 1, lower = 0, tags = "train"),
            ParamDbl$new(id = "subsample", default = 1, lower = 0, upper = 1, tags = "train"),
            ParamDbl$new(id = "colsample_bytree", default = 1, lower = 0, upper = 1, tags = "train"),
            ParamDbl$new(id = "colsample_bylevel", default = 1, lower = 0, upper = 1, tags = "train"),
            ParamInt$new(id = "num_parallel_tree", default = 1L, lower = 1L, tags = "train"),
            ParamDbl$new(id = "lambda", default = 1, lower = 0, tags = "train"),
            ParamDbl$new(id = "lambda_bias", default = 0, lower = 0, tags = "train"),
            ParamDbl$new(id = "alpha", default = 0, lower = 0, tags = "train"),
            ParamUty$new(id = "objective", default = "reg:linear", tags = c("train", "predict")),
            ParamUty$new(id = "eval_metric", default = "rmse", tags = "train"),
            ParamDbl$new(id = "base_score", default = 0.5, tags = "train"),
            ParamDbl$new(id = "max_delta_step", lower = 0, default = 0, tags = "train"),
            ParamDbl$new(id = "missing", default = NA, tags = c("train", "predict"),
              special_vals = list(NA, NA_real_, NULL)),
            ParamInt$new(id = "monotone_constraints", default = 0, lower = -1, upper = 1, tags = "train"),
            ParamDbl$new(id = "tweedie_variance_power", lower = 1, upper = 2, default = 1.5, tags = "train"), #, requires = quote(objective == "reg:tweedie")
            ParamInt$new(id = "nthread", lower = 1L, tags = "train"),
            ParamInt$new(id = "nrounds", default = 1L, lower = 1L, tags = "train"),
            # FIXME nrounds seems to have no default in xgboost(), if it has 1, par.vals is redundant
            ParamUty$new(id = "feval", default = NULL, tags = "train"),
            ParamInt$new(id = "verbose", default = 1L, lower = 0L, upper = 2L, tags = "train"),
            ParamInt$new(id = "print_every_n", default = 1L, lower = 1L, tags = "train"), #, requires = quote(verbose == 1L)
            ParamInt$new(id = "early_stopping_rounds", default = NULL, lower = 1L, special_vals = list(NULL), tags = "train"),
            ParamLgl$new(id = "maximize", default = NULL, special_vals = list(NULL), tags = "train"),
            ParamFct$new(id = "sample_type", default = "uniform", levels = c("uniform", "weighted"), tags = "train"), #, requires = quote(booster == "dart")
            ParamFct$new(id = "normalize_type", default = "tree", levels = c("tree", "forest"), tags = "train"), #, requires = quote(booster == "dart")
            ParamDbl$new(id = "rate_drop", default = 0, lower = 0, upper = 1, tags = "train"), #, requires = quote(booster == "dart")
            ParamDbl$new(id = "skip_drop", default = 0, lower = 0, upper = 1, tags = "train"), #, requires = quote(booster == "dart")
            # TODO: uncomment the following after the next CRAN update, and set max_depth's lower = 0L
            #ParamLgl$new(id = "one_drop", default = FALSE, requires = quote(booster == "dart")),
            #ParamFct$new(id = "tree_method", default = "exact", levels = c("exact", "hist"), requires = quote(booster != "gblinear")),
            #ParamFct$new(id = "grow_policy", default = "depthwise", levels = c("depthwise", "lossguide"), requires = quote(tree_method == "hist")),
            #ParamInt$new(id = "max_leaves", default = 0L, lower = 0L, requires = quote(grow_policy == "lossguide")),
            #ParamInt$new(id = "max_bin", default = 256L, lower = 2L, requires = quote(tree_method == "hist")),
            ParamUty$new(id = "callbacks", default = list(), tags = "train")
          )
        ),
        param_vals = list(nrounds = 1L, verbose = 0L),
        feature_types = c("integer", "numeric"),
        properties = c("weights", "missings", "importance"),
        packages = "xgboost"
      )
    },

    train = function(task) {
      pars = self$params("train")

      if (is.null(pars$objective))
        pars$objective = "reg:linear"

      data = task$data(cols = task$feature_names)
      target = task$data(cols = task$target_names)
      pars$data = xgboost::xgb.DMatrix(data = data.matrix(data), label = data.matrix(target))

      if ("weights" %in% task$properties) {
        xgboost::setinfo(pars$data, "weight", task$weights$weight)
      }

      if (is.null(pars$watchlist))
        pars$watchlist = list(train = pars$data)

      self$model = invoke(xgboost::xgb.train,
        .args = pars
      )
      self
    },

    predict = function(task) {
      pars = self$params("predict")
      newdata = task$data(cols = task$feature_names)

      response = invoke(predict,
        self$model,
        newdata = data.matrix(newdata),
        .args = pars
      )

      PredictionRegr$new(task, response)
    },

    importance = function() {
      if (is.null(self$model))
        stopf("No model stored")

      imp = xgboost::xgb.importance(
        feature_names = self$model$features,
        model = self$model
      )
      set_names(imp$Gain, imp$Feature)
    }
  )
)
