#' @title Extreme Gradiant Boosting Classification Learner
#'
#' @name mlr_learners_classif.xgboost
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerClassif].
#'
#' @description
#' An [mlr3::LearnerClassif] for eXtreme Gradient Boosting learner implemented in [xgboost::xgb.train()] in package \CRANpkg{xgboost}.
#'
#' @export
LearnerClassifXgboost = R6Class("LearnerClassifXgboost", inherit = LearnerClassif,
  public = list(
    initialize = function(id = "classif.xgboost") {
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
            ParamUty$new(id = "objective", default = "binary:logistic", tags = c("train", "predict")),
            ParamUty$new(id = "eval_metric", default = "error", tags = "train"),
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
            ParamUty$new(id = "callbacks", default = list())
          )
        ),
        param_vals = list(nrounds = 1L, verbose = 0L),
        predict_types = c("response", "prob"),
        feature_types = c("integer", "numeric"),
        properties = c("weights", "missings", "twoclass", "multiclass", "importance"),
        packages = "xgboost"
      )
    },

    train = function(task) {
      cls = task$class_names
      pars = self$params("train")

      if (is.null(pars$objective))
        pars$objective = ifelse(length(cls) == 2L, "binary:logistic", "multi:softprob")

      if (self$predict_type == "prob" && pars$objective == "multi:softmax")
        stop("objective = 'multi:softmax' does not work with predict_type = 'prob'")

      #if we use softprob or softmax as objective we have to add the number of classes 'num_class'
      if (pars$objective %in% c("multi:softprob", "multi:softmax"))
        pars$num_class = length(cls)

      data = task$data(cols = task$feature_names)
      label = match(as.character(as.matrix(task$data(cols = task$target_names))), cls) - 1
      pars$data = xgboost::xgb.DMatrix(data = data.matrix(data), label = label)

      if ("weights" %in% task$properties)
        xgboost::setinfo(pars$data, "weight", task$weights$weight)

      if (is.null(pars$watchlist))
        pars$watchlist = list(train = pars$data)

      self$model = invoke(xgboost::xgb.train, .args = pars)
      self
    },

    predict = function(task) {
      response = prob = NULL
      pars = self$params("predict")
      newdata = task$data(cols = task$feature_names)
      cls = task$class_names
      nc = length(cls)
      obj = pars$objective

      if (is.null(obj))
        pars$objective = ifelse(nc == 2L, "binary:logistic", "multi:softprob")

      pred = invoke(predict,
        self$model,
        newdata = data.matrix(newdata),
        .args = pars
      )


      if (nc == 2L) { #binaryclass
        if (pars$objective == "multi:softprob") {
          prob = matrix(pred, nrow = length(pred) / nc, ncol = nc, byrow = TRUE)
          colnames(prob) = cls
        } else {
          prob = matrix(0, ncol = 2, nrow = nrow(newdata))
          colnames(prob) = cls
          prob[, 1L] = 1 - pred
          prob[, 2L] = pred
        }
        if (self$predict_type == "response") {
          response = colnames(prob)[max.col(prob)]
          response = factor(response, levels = cls)
        }
      } else { #multiclass
        if (pars$objective  == "multi:softmax") {
          response = factor(as.character(pred), levels = cls)
        } else {
          pred = matrix(pred, nrow = length(pred) / nc, ncol = nc, byrow = TRUE)
          colnames(pred) = cls
          if (self$predict_type == "prob") {
            prob = pred
          } else {
            ind = max.col(pred)
            response = factor(cls[ind], levels = cls)
          }
        }
      }

      PredictionClassif$new(task, response, prob)
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
