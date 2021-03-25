#' @title Extreme Gradient Boosting Classification Learner
#'
#' @name mlr_learners_classif.xgboost
#'
#' @description
#' eXtreme Gradient Boosting classification.
#' Calls [xgboost::xgb.train()] from package \CRANpkg{xgboost}.
#'
#' @section Custom mlr3 defaults:
#' - `nrounds`:
#'   - Actual default: no default.
#'   - Adjusted default: 1.
#'   - Reason for change: Without a default construction of the learner
#'     would error. Just setting a nonsense default to workaround this.
#'     `nrounds` needs to be tuned by the user.
#' - `nthread`:
#'   - Actual value: Undefined, triggering auto-detection of the number of CPUs.
#'   - Adjusted value: 1.
#'   - Reason for change: Conflicting with parallelization via \CRANpkg{future}.
#' - `verbose`:
#'   - Actual default: 1.
#'   - Adjusted default: 0.
#'   - Reason for change: Reduce verbosity.
#'
#' @template section_dictionary_learner
#' @templateVar id classif.xgboost
#'
#' @references
#' `r format_bib("chen_2016")`
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerClassifXgboost = R6Class("LearnerClassifXgboost",
  inherit = LearnerClassif,

  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {

      ps = ps(
        booster = p_fct(default = "gbtree", levels = c("gbtree", "gblinear", "dart"), tags = c("train", "control")),
        watchlist = p_uty(default = NULL, tags = "train"),
        eta = p_dbl(default = 0.3, lower = 0, upper = 1, tags = c("train", "control")),
        gamma = p_dbl(default = 0, lower = 0, tags = c("train", "control")),
        max_depth = p_int(default = 6L, lower = 0L, tags = c("train", "control")),
        min_child_weight = p_dbl(default = 1, lower = 0, tags = c("train", "control")),
        subsample = p_dbl(default = 1, lower = 0, upper = 1, tags = c("train", "control")),
        colsample_bytree = p_dbl(default = 1, lower = 0, upper = 1, tags = c("train", "control")),
        colsample_bylevel = p_dbl(default = 1, lower = 0, upper = 1, tags = "train"),
        colsample_bynode = p_dbl(default = 1, lower = 0, upper = 1, tags = "train"),
        num_parallel_tree = p_int(default = 1L, lower = 1L, tags = c("train", "control")),
        lambda = p_dbl(default = 1, lower = 0, tags = "train"),
        lambda_bias = p_dbl(default = 0, lower = 0, tags = "train"),
        alpha = p_dbl(default = 0, lower = 0, tags = "train"),
        objective = p_uty(default = "binary:logistic", tags = c("train", "predict", "control")),
        eval_metric = p_uty(default = "error", tags = "train"),
        base_score = p_dbl(default = 0.5, tags = "train"),
        max_delta_step = p_dbl(lower = 0, default = 0, tags = "train"),
        missing = p_dbl(default = NA, tags = c("train", "predict"), special_vals = list(NA, NA_real_, NULL)),
        monotone_constraints = p_int(default = 0L, lower = -1L, upper = 1L, tags = c("train", "control")),
        tweedie_variance_power = p_dbl(lower = 1, upper = 2, default = 1.5, tags = "train"),
        nthread = p_int(lower = 1L, default = 1L, tags = c("train", "control", "threads")),
        nrounds = p_int(default = 1, lower = 1L, tags = c("train")),
        feval = p_uty(default = NULL, tags = "train"),
        verbose = p_int(default = 1L, lower = 0L, upper = 2L, tags = "train"),
        print_every_n = p_int(default = 1L, lower = 1L, tags = "train"),
        early_stopping_rounds = p_int(default = NULL, lower = 1L, special_vals = list(NULL), tags = "train"),
        maximize = p_lgl(default = NULL, special_vals = list(NULL), tags = "train"),
        sample_type = p_fct(default = "uniform", levels = c("uniform", "weighted"), tags = "train"),
        normalize_type = p_fct(default = "tree", levels = c("tree", "forest"), tags = "train"),
        rate_drop = p_dbl(default = 0, lower = 0, upper = 1, tags = "train"),
        skip_drop = p_dbl(default = 0, lower = 0, upper = 1, tags = "train"),
        one_drop = p_lgl(default = FALSE, tags = "train"),
        tree_method = p_fct(default = "auto", levels = c("auto", "exact", "approx", "hist", "gpu_hist"), tags = "train"),
        grow_policy = p_fct(default = "depthwise", levels = c("depthwise", "lossguide"), tags = "train"),
        max_leaves = p_int(default = 0L, lower = 0L, tags = "train"),
        max_bin = p_int(default = 256L, lower = 2L, tags = "train"),
        callbacks = p_uty(default = list(), tags = "train"),
        sketch_eps = p_dbl(default = 0.03, lower = 0, upper = 1, tags = "train"),
        scale_pos_weight = p_dbl(default = 1, tags = "train"),
        updater = p_uty(tags = "train"), # Default depends on the selected booster
        refresh_leaf = p_lgl(default = TRUE, tags = "train"),
        feature_selector = p_fct(default = "cyclic", levels = c("cyclic", "shuffle", "random", "greedy", "thrifty"), tags = "train"),
        top_k = p_int(default = 0, lower = 0, tags = "train"),
        predictor = p_fct(default = "cpu_predictor", levels = c("cpu_predictor", "gpu_predictor"), tags = "train"),
        save_period = p_int(default = NULL, special_vals = list(NULL), lower = 0, tags = "train"),
        save_name = p_uty(default = NULL, tags = "train"),
        xgb_model = p_uty(default = NULL, tags = "train"),
        interaction_constraints = p_uty(tags = "train"),
        outputmargin = p_lgl(default = FALSE, tags = "predict"),
        ntreelimit = p_int(default = NULL, special_vals = list(NULL), lower = 1, tags = "predict"),
        predleaf = p_lgl(default = FALSE, tags = "predict"),
        predcontrib = p_lgl(default = FALSE, tags = "predict"),
        approxcontrib = p_lgl(default = FALSE, tags = "predict"),
        predinteraction = p_lgl(default = FALSE, tags = "predict"),
        reshape = p_lgl(default = FALSE, tags = "predict"),
        training = p_lgl(default = FALSE, tags = "predict")
      )
      # param deps
      ps$add_dep("tweedie_variance_power", "objective", CondEqual$new("reg:tweedie"))
      ps$add_dep("print_every_n", "verbose", CondEqual$new(1L))
      ps$add_dep("sample_type", "booster", CondEqual$new("dart"))
      ps$add_dep("normalize_type", "booster", CondEqual$new("dart"))
      ps$add_dep("rate_drop", "booster", CondEqual$new("dart"))
      ps$add_dep("skip_drop", "booster", CondEqual$new("dart"))
      ps$add_dep("one_drop", "booster", CondEqual$new("dart"))
      ps$add_dep("tree_method", "booster", CondAnyOf$new(c("gbtree", "dart")))
      ps$add_dep("grow_policy", "tree_method", CondEqual$new("hist"))
      ps$add_dep("max_leaves", "grow_policy", CondEqual$new("lossguide"))
      ps$add_dep("max_bin", "tree_method", CondEqual$new("hist"))
      ps$add_dep("sketch_eps", "tree_method", CondEqual$new("approx"))
      ps$add_dep("feature_selector", "booster", CondEqual$new("gblinear"))
      ps$add_dep("top_k", "booster", CondEqual$new("gblinear"))
      ps$add_dep("top_k", "feature_selector", CondAnyOf$new(c("greedy", "thrifty")))

      # custom defaults
      ps$values = list(nrounds = 1L, nthread = 1L, verbose = 0L)

      super$initialize(
        id = "classif.xgboost",
        predict_types = c("response", "prob"),
        param_set = ps,
        feature_types = c("logical", "integer", "numeric"),
        properties = c("weights", "missings", "twoclass", "multiclass", "importance"),
        packages = "xgboost",
        man = "mlr3learners::mlr_learners_classif.xgboost"
      )
    },

    #' @description
    #' The importance scores are calculated with [xgboost::xgb.importance()].
    #'
    #' @return Named `numeric()`.
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
  ),

  private = list(
    .train = function(task) {

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

      mlr3misc::invoke(xgboost::xgb.train, data = data, .args = pars)
    },

    .predict = function(task) {

      pars = self$param_set$get_values(tags = "predict")
      model = self$model
      response = prob = NULL
      lvls = rev(task$class_names)
      nlvls = length(lvls)

      if (is.null(pars$objective)) {
        pars$objective = ifelse(nlvls == 2L, "binary:logistic", "multi:softprob")
      }

      newdata = data.matrix(task$data(cols = task$feature_names))
      newdata = newdata[, model$feature_names, drop = FALSE]
      pred = mlr3misc::invoke(predict, model, newdata = newdata, .args = pars)

      if (nlvls == 2L) { # binaryclass
        if (pars$objective == "multi:softprob") {
          prob = matrix(pred, ncol = nlvls, byrow = TRUE)
          colnames(prob) = lvls
        } else {
          prob = pvec2mat(pred, lvls)
        }
      } else { # multiclass
        if (pars$objective == "multi:softmax") {
          response = lvls[pred + 1L]
        } else {
          prob = matrix(pred, ncol = nlvls, byrow = TRUE)
          colnames(prob) = lvls
        }
      }

      if (!is.null(response)) {
        list(response = response)
      } else if (self$predict_type == "response") {
        i = max.col(prob, ties.method = "random")
        list(response = factor(colnames(prob)[i], levels = lvls))
      } else {
        list(prob = prob)
      }
    }
  )
)
