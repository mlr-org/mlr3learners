#' @title Extreme Gradient Boosting Classification Learner
#'
#' @name mlr_learners_classif.xgboost
#'
#' @description
#' eXtreme Gradient Boosting classification.
#' Calls [xgboost::xgb.train()] from package \CRANpkg{xgboost}.
#'
#' If not specified otherwise, the evaluation metric is set to the default `"logloss"`
#' for binary classification problems and set to `"mlogloss"` for multiclass problems.
#' This was necessary to silence a deprecation warning.
#'
#' Note that using the `watchlist` parameter directly will lead to problems when wrapping this [`Learner`] in a
#' `mlr3pipelines` `GraphLearner` as the preprocessing steps will not be applied to the data in the watchlist.
#'
#' @template note_xgboost
#' @section Initial parameter values:
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
#' @section Early stopping:
#' Early stopping can be used to find the optimal number of boosting rounds.
#' The `early_stopping_set` parameter controls which set is used to monitor the performance.
#' Set `early_stopping_set = "test"` to monitor the performance of the model on the test set while training.
#' The test set for early stopping can be set with the `"test"` row role in the [mlr3::Task].
#' Additionally, the range must be set in which the performance must increase with `early_stopping_rounds` and the maximum number of boosting rounds with `nrounds`.
#' While resampling, the test set is automatically applied from the [mlr3::Resampling].
#' Not that using the test set for early stopping can potentially bias the performance scores.
#' See the section on early stopping in the examples.
#'
#' @templateVar id classif.xgboost
#' @template learner
#'
#' @references
#' `r format_bib("chen_2016")`
#'
#' @export
#' @template seealso_learner
#' @template example_dontrun
#' @examples
#'
#' \dontrun{
#' # Train learner with early stopping on spam data set
#' task = tsk("spam")
#'
#' # Split task into training and test set
#' split = partition(task, ratio = 0.8)
#' task$set_row_roles(split$test, "test")
#'
#' # Set early stopping parameter
#' learner = lrn("classif.xgboost",
#'   nrounds = 100,
#'   early_stopping_rounds = 10,
#'   early_stopping_set = "test"
#' )
#'
#' # Train learner with early stopping
#' learner$train(task)
#' }
LearnerClassifXgboost = R6Class("LearnerClassifXgboost",
  inherit = LearnerClassif,

  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ps(
        alpha                       = p_dbl(0, default = 0, tags = "train"),
        approxcontrib               = p_lgl(default = FALSE, tags = "predict"),
        base_score                  = p_dbl(default = 0.5, tags = "train"),
        booster                     = p_fct(c("gbtree", "gblinear", "dart"), default = "gbtree", tags = c("train", "control")),
        callbacks                   = p_uty(default = list(), tags = "train"),
        colsample_bylevel           = p_dbl(0, 1, default = 1, tags = "train"),
        colsample_bynode            = p_dbl(0, 1, default = 1, tags = "train"),
        colsample_bytree            = p_dbl(0, 1, default = 1, tags = c("train", "control")),
        device                      = p_uty(default = "cpu", tags = "train"),
        disable_default_eval_metric = p_lgl(default = FALSE, tags = "train"),
        early_stopping_rounds       = p_int(1L, default = NULL, special_vals = list(NULL), tags = "train"),
        early_stopping_set          = p_fct(c("none", "train", "test"), default = "none", tags = "train"),
        eta                         = p_dbl(0, 1, default = 0.3, tags = c("train", "control")),
        eval_metric                 = p_uty(tags = "train"),
        feature_selector            = p_fct(c("cyclic", "shuffle", "random", "greedy", "thrifty"), default = "cyclic", tags = "train", depends = quote(booster == "gblinear")),
        feval                       = p_uty(default = NULL, tags = "train"),
        gamma                       = p_dbl(0, default = 0, tags = c("train", "control")),
        grow_policy                 = p_fct(c("depthwise", "lossguide"), default = "depthwise", tags = "train", depends = quote(tree_method == "hist")),
        interaction_constraints     = p_uty(tags = "train"),
        iterationrange              = p_uty(tags = "predict"),
        lambda                      = p_dbl(0, default = 1, tags = "train"),
        lambda_bias                 = p_dbl(0, default = 0, tags = "train", depends = quote(booster == "gblinear")),
        max_bin                     = p_int(2L, default = 256L, tags = "train", depends = quote(tree_method == "hist")),
        max_delta_step              = p_dbl(0, default = 0, tags = "train"),
        max_depth                   = p_int(0L, default = 6L, tags = c("train", "control")),
        max_leaves                  = p_int(0L, default = 0L, tags = "train", depends = quote(grow_policy == "lossguide")),
        maximize                    = p_lgl(default = NULL, special_vals = list(NULL), tags = "train"),
        min_child_weight            = p_dbl(0, default = 1, tags = c("train", "control")),
        missing                     = p_dbl(default = NA, tags = c("train", "predict"), special_vals = list(NA, NA_real_, NULL)),
        monotone_constraints        = p_uty(default = 0, tags = c("train", "control"), custom_check = crate(function(x) { checkmate::check_integerish(x, lower = -1, upper = 1, any.missing = FALSE) })), # nolint
        normalize_type              = p_fct(c("tree", "forest"), default = "tree", tags = "train", depends = quote(booster == "dart")),
        nrounds                     = p_int(1L, tags = c("train", "hotstart")),
        nthread                     = p_int(1L, default = 1L, tags = c("train", "control", "threads")),
        ntreelimit                  = p_int(1L, default = NULL, special_vals = list(NULL), tags = "predict"),
        num_parallel_tree           = p_int(1L, default = 1L, tags = c("train", "control")),
        objective                   = p_uty(default = "binary:logistic", tags = c("train", "predict", "control")),
        one_drop                    = p_lgl(default = FALSE, tags = "train", depends = quote(booster == "dart")),
        outputmargin                = p_lgl(default = FALSE, tags = "predict"),
        predcontrib                 = p_lgl(default = FALSE, tags = "predict"),
        predinteraction             = p_lgl(default = FALSE, tags = "predict"),
        predleaf                    = p_lgl(default = FALSE, tags = "predict"),
        print_every_n               = p_int(1L, default = 1L, tags = "train", depends = quote(verbose == 1L)),
        process_type                = p_fct(c("default", "update"), default = "default", tags = "train"),
        rate_drop                   = p_dbl(0, 1, default = 0, tags = "train", depends = quote(booster == "dart")),
        refresh_leaf                = p_lgl(default = TRUE, tags = "train"),
        reshape                     = p_lgl(default = FALSE, tags = "predict"),
        seed_per_iteration          = p_lgl(default = FALSE, tags = "train"),
        sampling_method             = p_fct(c("uniform", "gradient_based"), default = "uniform", tags = "train", depends = quote(booster == "gbtree")),
        sample_type                 = p_fct(c("uniform", "weighted"), default = "uniform", tags = "train", depends = quote(booster == "dart")),
        save_name                   = p_uty(default = NULL, tags = "train"),
        save_period                 = p_int(0, default = NULL, special_vals = list(NULL), tags = "train"),
        scale_pos_weight            = p_dbl(default = 1, tags = "train"),
        skip_drop                   = p_dbl(0, 1, default = 0, tags = "train", depends = quote(booster == "dart")),
        strict_shape                = p_lgl(default = FALSE, tags = "predict"),
        subsample                   = p_dbl(0, 1, default = 1, tags = c("train", "control")),
        top_k                       = p_int(0, default = 0, tags = "train", depends = quote(feature_selector %in% c("greedy", "thrifty") && booster == "gblinear")),
        training                    = p_lgl(default = FALSE, tags = "predict"),
        tree_method                 = p_fct(c("auto", "exact", "approx", "hist", "gpu_hist"), default = "auto", tags = "train", depends = quote(booster %in% c("gbtree", "dart"))),
        tweedie_variance_power      = p_dbl(1, 2, default = 1.5, tags = "train", depends = quote(objective == "reg:tweedie")),
        updater                     = p_uty(tags = "train"), # Default depends on the selected booster
        verbose                     = p_int(0L, 2L, default = 1L, tags = "train"),
        watchlist                   = p_uty(default = NULL, tags = "train"),
        xgb_model                   = p_uty(default = NULL, tags = "train")

      )

      # custom defaults
      ps$values = list(nrounds = 1L, nthread = 1L, verbose = 0L, early_stopping_set = "none")

      super$initialize(
        id = "classif.xgboost",
        predict_types = c("response", "prob"),
        param_set = ps,
        feature_types = c("logical", "integer", "numeric"),
        properties = c("weights", "missings", "twoclass", "multiclass", "importance", "hotstart_forward"),
        packages = c("mlr3learners", "xgboost"),
        label = "Extreme Gradient Boosting",
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
        model = self$model
      )
      set_names(imp$Gain, imp$Feature)
    }
  ),

  private = list(
    .train = function(task) {

      pv = self$param_set$get_values(tags = "train")

      lvls = task$class_names
      nlvls = length(lvls)

      if (is.null(pv$objective)) {
        pv$objective = if (nlvls == 2L) "binary:logistic" else "multi:softprob"
      }

      if (self$predict_type == "prob" && pv$objective == "multi:softmax") {
        stopf("objective = 'multi:softmax' does not work with predict_type = 'prob'")
      }

      switch(pv$objective,
        "multi:softprob" =,
        "multi:softmax" = {
          # add the number of classes 'num_class'
          pv$num_class = nlvls

          # we have to set this to avoid a deprecation warning
          pv$eval_metric = pv$eval_metric %??% "mlogloss"
        },

        "binary:logistic" = {
          pv$eval_metric = pv$eval_metric %??% "logloss"
        }
      )


      data = task$data(cols = task$feature_names)
      # recode to 0:1 to that for the binary case the positive class translates to 1 (#32)
      # note that task$truth() is guaranteed to have the factor levels in the right order
      label = nlvls - as.integer(task$truth())
      data = xgboost::xgb.DMatrix(data = as_numeric_matrix(data), label = label)

      if ("weights" %in% task$properties) {
        xgboost::setinfo(data, "weight", task$weights$weight)
      }

      if (pv$early_stopping_set != "none") {
        pv$watchlist = c(pv$watchlist, list(train = data))
      }

      # the last element in the watchlist is used as the early stopping set

      if (pv$early_stopping_set == "test" && !is.null(task$row_roles$test)) {
        test_data = task$data(rows = task$row_roles$test, cols = task$feature_names)
        test_label = nlvls - as.integer(task$truth(rows = task$row_roles$test))
        test_data = xgboost::xgb.DMatrix(data = as_numeric_matrix(test_data), label = test_label)
        pv$watchlist = c(pv$watchlist, list(test = test_data))
      }
      pv$early_stopping_set = NULL

      invoke(xgboost::xgb.train, data = data, .args = pv)
    },

    .predict = function(task) {

      pv = self$param_set$get_values(tags = "predict")
      model = self$model
      response = prob = NULL
      lvls = rev(task$class_names)
      nlvls = length(lvls)

      if (is.null(pv$objective)) {
        pv$objective = ifelse(nlvls == 2L, "binary:logistic", "multi:softprob")
      }

      newdata = as_numeric_matrix(ordered_features(task, self))
      pred = invoke(predict, model, newdata = newdata, .args = pv)

      if (nlvls == 2L) { # binaryclass
        if (pv$objective == "multi:softprob") {
          prob = matrix(pred, ncol = nlvls, byrow = TRUE)
          colnames(prob) = lvls
        } else {
          prob = pvec2mat(pred, lvls)
        }
      } else { # multiclass
        if (pv$objective == "multi:softmax") {
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
    },

    .hotstart = function(task) {
      model = self$model
      pars = self$param_set$get_values(tags = "train")
      pars_train = self$state$param_vals
      if (!is.null(pars_train$early_stopping_rounds)) {
        stopf("The parameter `early_stopping_rounds` is set. Early stopping and hotstarting are incompatible.")
      }
      pars$early_stopping_set = NULL

      # Calculate additional boosting iterations
      # niter in model and nrounds in ps should be equal after train and continue
      pars$nrounds = pars$nrounds - pars_train$nrounds

      # Construct data
      nlvls = length(task$class_names)
      data = task$data(cols = task$feature_names)
      label = nlvls - as.integer(task$truth())
      data = xgboost::xgb.DMatrix(data = as_numeric_matrix(data), label = label)

      invoke(xgboost::xgb.train, data = data, xgb_model = model, .args = pars)
    }
  )
)

#' @export
default_values.LearnerClassifXgboost = function(x, search_space, task, ...) { # nolint
  special_defaults = list(
    nrounds = 1L
  )
  defaults = insert_named(default_values(x$param_set), special_defaults)
  defaults[search_space$ids()]
}

#' @include aaa.R
learners[["classif.xgboost"]] = LearnerClassifXgboost
