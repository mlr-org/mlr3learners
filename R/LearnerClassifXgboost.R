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
#' \cite{mlr3learners}{chen_2016}
#'
#' @export
#' @template seealso_learner
#' @templateVar learner_name classif.xgboost
#' @template example
LearnerClassifXgboost = R6Class("LearnerClassifXgboost", inherit = LearnerClassif,
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
        ParamUty$new("objective", default = "binary:logistic", tags = c("train", "predict")),
        ParamUty$new("eval_metric", default = "error", tags = "train"),
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
        id = "classif.xgboost",
        predict_types = c("response", "prob"),
        param_set = ps,
        feature_types = c("integer", "numeric"),
        properties = c("weights", "missings", "twoclass", "multiclass", "importance"),
        packages = "xgboost",
        man = "mlr3learners::mlr_learners_classif.xgboost"
      )
    },

    train_internal = function(task) {
      pars = self$param_set$get_values(tags = "train")

      lvls = task$class_names
      nlvls = length(lvls)

      if (is.null(pars$objective)) {
        pars$objective = if (nlvls == 2L) "binary:logistic" else "multi:softprob"
      }

      if (self$predict_type == "prob" && pars$objective == "multi:softmax") {
        stop("objective = 'multi:softmax' does not work with predict_type = 'prob'")
      }

      # if we use softprob or softmax as objective we have to add the number of classes 'num_class'
      if (pars$objective %in% c("multi:softprob", "multi:softmax")) {
        pars$num_class = nlvls
      }

      data = task$data(cols = task$feature_names)
      # recode to 0:1 to that for the binary case the positive class translates to 1 (#32)
      # task$truth() is guaranteed to have the factor levels in the right order
      label = nlvls - as.integer(task$truth())
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
      model = self$model
      response = prob = NULL
      lvls = rev(task$class_names)
      nlvl = length(lvls)

      if (is.null(pars$objective)) {
        pars$objective = ifelse(nlvl == 2L, "binary:logistic", "multi:softprob")
      }

      newdata = data.matrix(task$data(cols = task$feature_names))
      newdata = newdata[, model$feature_names, drop = FALSE]
      pred = invoke(predict, model, newdata = newdata, .args = pars)

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

      if(!is.null(response)) {
        PredictionClassif$new(task = task, response = response)
      } else if(self$predict_type == "response") {
        i = max.col(prob, ties.method = "random")
        response = factor(colnames(prob)[i], levels = lvls)
        PredictionClassif$new(task = task, response = response)
      } else {
        PredictionClassif$new(task = task, prob = prob)
      }
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
