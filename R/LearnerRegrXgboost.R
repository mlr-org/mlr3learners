#' @title Extreme Gradient Boosting Regression Learner
#'
#' @usage NULL
#' @aliases mlr_learners_regr.xgboost
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerRegr].
#'
#' @section Construction:
#' ```
#' LearnerRegrXgboost$new()
#' mlr3::mlr_learners$get("regr.xgboost")
#' mlr3::lrn("regr.xgboost")
#' ```
#'
#' @description
#' eXtreme Gradient Boosting regression.
#' Calls [xgboost::xgb.train()] from package \CRANpkg{xgboost}.
#'
#' @references
#' \cite{mlr3learners}{chen_2016}
#'
#' @export
#' @template seealso_learner
#' @templateVar learner_name regr.xgboost
#' @template example
LearnerRegrXgboost = R6Class("LearnerRegrXgboost", inherit = LearnerRegr,
  public = list(
    initialize = function() {
      ps = ParamSet$new(list(
        ParamFct$new("booster", default = "gbtree", levels = c("gbtree", "gblinear", "dart"), tags = "train"),
        ParamUty$new("watchlist", default = NULL, tags = "train"),
        ParamDbl$new("eta", default = 0.3, lower = 0, upper = 1, tags = "train"),
        ParamDbl$new("gamma", default = 0, lower = 0, tags = "train"),
        ParamInt$new("max_depth", default = 6L, lower = 1L, tags = "train"),
        ParamDbl$new("min_child_weight", default = 1, lower = 0, tags = "train"),
        ParamDbl$new("subsample", default = 1, lower = 0, upper = 1, tags = "train"),
        ParamDbl$new("colsample_bytree", default = 1, lower = 0, upper = 1, tags = "train"),
        ParamDbl$new("colsample_bylevel", default = 1, lower = 0, upper = 1, tags = "train"),
        ParamInt$new("num_parallel_tree", default = 1L, lower = 1L, tags = "train"),
        ParamDbl$new("lambda", default = 1, lower = 0, tags = "train"),
        ParamDbl$new("lambda_bias", default = 0, lower = 0, tags = "train"),
        ParamDbl$new("alpha", default = 0, lower = 0, tags = "train"),
        ParamUty$new("objective", default = "reg:linear", tags = c("train", "predict")),
        ParamUty$new("eval_metric", default = "rmse", tags = "train"),
        ParamDbl$new("base_score", default = 0.5, tags = "train"),
        ParamDbl$new("max_delta_step", lower = 0, default = 0, tags = "train"),
        ParamDbl$new("missing", default = NA, tags = c("train", "predict"), special_vals = list(NA, NA_real_, NULL)),
        ParamInt$new("monotone_constraints", default = 0L, lower = -1L, upper = 1L, tags = "train"),
        ParamDbl$new("tweedie_variance_power", lower = 1, upper = 2, default = 1.5, tags = "train"), # , requires = quote(objective == "reg:tweedie")
        ParamInt$new("nthread", lower = 1L, tags = "train"),
        ParamInt$new("nrounds", lower = 1L, tags = "train"),
        ParamUty$new("feval", default = NULL, tags = "train"),
        ParamInt$new("verbose", default = 1L, lower = 0L, upper = 2L, tags = "train"),
        ParamInt$new("print_every_n", default = 1L, lower = 1L, tags = "train"), # , requires = quote(verbose == 1L)
        ParamInt$new("early_stopping_rounds", default = NULL, lower = 1L, special_vals = list(NULL), tags = "train"),
        ParamLgl$new("maximize", default = NULL, special_vals = list(NULL), tags = "train"),
        ParamFct$new("sample_type", default = "uniform", levels = c("uniform", "weighted"), tags = "train"), # , requires = quote(booster == "dart")
        ParamFct$new("normalize_type", default = "tree", levels = c("tree", "forest"), tags = "train"), # , requires = quote(booster == "dart")
        ParamDbl$new("rate_drop", default = 0, lower = 0, upper = 1, tags = "train"), # , requires = quote(booster == "dart")
        ParamDbl$new("skip_drop", default = 0, lower = 0, upper = 1, tags = "train"), # , requires = quote(booster == "dart")
        # TODO: uncomment the following after the next CRAN update, and set max_depth's lower = 0L
        # ParamLgl$new("one_drop", default = FALSE, requires = quote(booster == "dart")),
        # ParamFct$new("tree_method", default = "exact", levels = c("exact", "hist"), requires = quote(booster != "gblinear")),
        # ParamFct$new("grow_policy", default = "depthwise", levels = c("depthwise", "lossguide"), requires = quote(tree_method == "hist")),
        # ParamInt$new("max_leaves", default = 0L, lower = 0L, requires = quote(grow_policy == "lossguide")),
        # ParamInt$new("max_bin", default = 256L, lower = 2L, requires = quote(tree_method == "hist")),
        ParamUty$new("callbacks", default = list(), tags = "train")
      ))
      ps$values = list(nrounds = 1L, verbose = 0L)

      super$initialize(
        id = "regr.xgboost",
        param_set = ps,
        feature_types = c("integer", "numeric"),
        properties = c("weights", "missings", "importance"),
        packages = "xgboost",
        man = "mlr3learners::mlr_learners_regr.xgboost"
      )
    },

    train_internal = function(task) {

      pars = self$param_set$get_values(tags = "train")

      if (is.null(pars$objective)) {
        pars$objective = "reg:linear"
      }

      data = task$data(cols = task$feature_names)
      target = task$data(cols = task$target_names)
      data = xgboost::xgb.DMatrix(data = data.matrix(data), label = data.matrix(target))

      if ("weights" %in% task$properties) {
        xgboost::setinfo(data, "weight", task$weights$weight)
      }

      if (is.null(pars$watchlist)) {
        pars$watchlist = list(train = data)
      }

      invoke(xgboost::xgb.train, data = data, .args = pars)
    },

    predict_internal = function(task) {
      pars = self$param_set$get_values(tags = "predict")
      model = self$model
      newdata = data.matrix(task$data(cols = task$feature_names))
      newdata = newdata[, model$feature_names, drop = FALSE]
      response = invoke(predict, model, newdata = newdata, .args = pars)

      PredictionRegr$new(task = task, response = response)
    },

    importance = function() {
      if (is.null(self$model)) {
        stopf("No model stored")
      }

      imp = xgboost::xgb.importance(
        feature_names = self$model$features,
        model = self$model
      )
      set_names(imp$Gain, imp$Feature)
    }
  )
)
