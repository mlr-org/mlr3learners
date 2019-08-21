#' @title Extreme Gradiant Boosting Classification Learner
#'
#' @usage NULL
#' @aliases mlr_learners_classif.xgboost
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerClassif].
#'
#' @section Construction:
#' ```
#' LearnerClassifXgboost$new()
#' mlr3::mlr_learners$get("classif.xgboost")
#' mlr3::lrn("classif.xgboost")
#' ```
#'
#' @description
#' eXtreme Gradient Boosting classification.
#' Calls [xgboost::xgb.train()] from package \CRANpkg{xgboost}.
#'
#' @references
#' Tianqi Chen and Carlos Guestrin (2016).
#' XGBoost: A Scalable Tree Boosting System.
#' 22nd SIGKDD Conference on Knowledge Discovery and Data Mining.
#' \doi{10.1145/2939672.2939785}.
#'
#' @export
#' @templateVar learner_name classif.xgboost
#' @template example
LearnerClassifXgboost = R6Class("LearnerClassifXgboost", inherit = LearnerClassif,
  public = list(
    initialize = function() {
      super$initialize(
        id = "classif.xgboost",
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
            ParamUty$new(id = "objective", default = "binary:logistic", tags = c("train", "predict")),
            ParamUty$new(id = "eval_metric", default = "error", tags = "train"),
            ParamDbl$new(id = "base_score", default = 0.5, tags = "train"),
            ParamDbl$new(id = "max_delta_step", lower = 0, default = 0, tags = "train"),
            ParamDbl$new(id = "missing", default = NA, tags = c("train", "predict"),
              special_vals = list(NA, NA_real_, NULL)),
            ParamInt$new(id = "monotone_constraints", default = 0L, lower = -1L, upper = 1L, tags = "train"),
            ParamDbl$new(id = "tweedie_variance_power", lower = 1, upper = 2, default = 1.5, tags = "train"), # , requires = quote(objective == "reg:tweedie")
            ParamInt$new(id = "nthread", lower = 1L, tags = "train"),
            ParamInt$new(id = "nrounds", default = 1L, lower = 1L, tags = "train"),
            # FIXME nrounds seems to have no default in xgboost(), if it has 1, par.vals is redundant
            ParamUty$new(id = "feval", default = NULL, tags = "train"),
            ParamInt$new(id = "verbose", default = 1L, lower = 0L, upper = 2L, tags = "train"),
            ParamInt$new(id = "print_every_n", default = 1L, lower = 1L, tags = "train"), # , requires = quote(verbose == 1L)
            ParamInt$new(id = "early_stopping_rounds", default = NULL, lower = 1L, special_vals = list(NULL), tags = "train"),
            ParamLgl$new(id = "maximize", default = NULL, special_vals = list(NULL), tags = "train"),
            ParamFct$new(id = "sample_type", default = "uniform", levels = c("uniform", "weighted"), tags = "train"), # , requires = quote(booster == "dart")
            ParamFct$new(id = "normalize_type", default = "tree", levels = c("tree", "forest"), tags = "train"), # , requires = quote(booster == "dart")
            ParamDbl$new(id = "rate_drop", default = 0, lower = 0, upper = 1, tags = "train"), # , requires = quote(booster == "dart")
            ParamDbl$new(id = "skip_drop", default = 0, lower = 0, upper = 1, tags = "train"), # , requires = quote(booster == "dart")
            # TODO: uncomment the following after the next CRAN update, and set max_depth's lower = 0L
            # ParamLgl$new(id = "one_drop", default = FALSE, requires = quote(booster == "dart")),
            # ParamFct$new(id = "tree_method", default = "exact", levels = c("exact", "hist"), requires = quote(booster != "gblinear")),
            # ParamFct$new(id = "grow_policy", default = "depthwise", levels = c("depthwise", "lossguide"), requires = quote(tree_method == "hist")),
            # ParamInt$new(id = "max_leaves", default = 0L, lower = 0L, requires = quote(grow_policy == "lossguide")),
            # ParamInt$new(id = "max_bin", default = 256L, lower = 2L, requires = quote(tree_method == "hist")),
            ParamUty$new(id = "callbacks", default = list(), tags = "train")
          )
        ),
        param_vals = list(nrounds = 1L, verbose = 0L),
        predict_types = c("response", "prob"),
        feature_types = c("integer", "numeric"),
        properties = c("weights", "missings", "twoclass", "multiclass", "importance"),
        packages = "xgboost"
      )
    },

    train_internal = function(task) {

      pars = self$param_set$get_values(tags = "train")
      lvls = task$class_names

      if (is.null(pars$objective)) {
        pars$objective = ifelse(length(lvls) == 2L, "binary:logistic", "multi:softprob")
      }

      if (self$predict_type == "prob" && pars$objective == "multi:softmax") {
        stop("objective = 'multi:softmax' does not work with predict_type = 'prob'")
      }

      # if we use softprob or softmax as objective we have to add the number of classes 'num_class'
      if (pars$objective %in% c("multi:softprob", "multi:softmax")) {
        pars$num_class = length(lvls)
      }

      data = task$data(cols = task$feature_names)
      label = match(as.character(as.matrix(task$data(cols = task$target_names))), lvls) - 1
      data = xgboost::xgb.DMatrix(data = data.matrix(data), label = label)

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
      response = prob = NULL
      lvls = task$class_names
      nlvl = length(lvls)

      if (is.null(pars$objective)) {
        pars$objective = ifelse(nlvl == 2L, "binary:logistic", "multi:softprob")
      }

      newdata = data.matrix(task$data(cols = task$feature_names))
      pred = invoke(predict, self$model, newdata = newdata, .args = pars)

      if (nlvl == 2L) { # binaryclass
        if (pars$objective == "multi:softprob") {
          prob = matrix(pred, ncol = nlvl, byrow = TRUE)
          colnames(prob) = lvls
        } else {
          prob = prob_vector_to_matrix(pred, lvls)
        }
      } else { # multiclass
        if (pars$objective == "multi:softmax") {
          response = lvls[pred + 1L]
        } else {
          prob = matrix(pred, ncol = nlvl, byrow = TRUE)
          colnames(prob) = lvls
        }
      }

      PredictionClassif$new(task = task, response = response, prob = prob)
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
