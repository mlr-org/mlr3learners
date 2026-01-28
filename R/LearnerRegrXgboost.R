#' @title Extreme Gradient Boosting Regression Learner
#'
#' @name mlr_learners_regr.xgboost
#'
#' @description
#' eXtreme Gradient Boosting regression.
#' Calls [xgboost::xgb.train()] from package \CRANpkg{xgboost}.
#'
#' To compute on GPUs, you first need to compile \CRANpkg{xgboost} yourself and link
#' against CUDA. See \url{https://xgboost.readthedocs.io/en/stable/build.html#building-with-gpu-support}.
#'
#' Note that using the `evals` parameter directly will lead to problems when wrapping this [mlr3::Learner] in a `mlr3pipelines` `GraphLearner`
#' as the preprocessing steps will not be applied to the data in `evals`.
#' See the section *Early Stopping and Validation* on how to do this.
#'
#' @template note_xgboost
#' @inheritSection mlr_learners_classif.xgboost Early Stopping and Validation
#' @inheritSection mlr_learners_classif.xgboost Initial parameter values
#'
#' @section Offset:
#' If a `Task` has a column with the role `offset`, it will automatically be used during training.
#' The offset is incorporated through the [xgboost::xgb.DMatrix] interface, using the `base_margin` field.
#' During prediction, the offset column from the test set is used only if `use_pred_offset = TRUE` (default) and the `Task` has a column with the role `offset`.
#' The test set offsets are passed via the `base_margin` argument in [xgboost::predict.xgb.Booster()].
#' Otherwise, if the user sets `use_pred_offset = FALSE` (or the `Task` doesn't have a column with the `offset` role), the (possibly estimated) global intercept from the train set is applied.
#' See \url{https://xgboost.readthedocs.io/en/stable/tutorials/intercept.html}.
#'
#' @templateVar id regr.xgboost
#' @template learner
#'
#' @references
#' `r format_bib("chen_2016")`
#'
#' @export
#' @template seealso_learner
#' @template example_xgboost
LearnerRegrXgboost = R6Class("LearnerRegrXgboost",
  inherit = LearnerRegr,
  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {

      p_nrounds = p_int(1L,
        tags = c("train", "hotstart", "internal_tuning"),
        aggr = crate(function(x) as.integer(ceiling(mean(unlist(x)))), .parent = topenv()),
        in_tune_fn = crate(function(domain, param_vals) {
          if (is.null(param_vals$early_stopping_rounds)) {
            stop("Parameter 'early_stopping_rounds' must be set to use internal tuning.")
          }
          if (is.null(param_vals$eval_metric) && is.null(param_vals$custom_metric)) {
            stop("Parameter 'eval_metric' or 'custom_metric' must be set explicitly when using internal tuning.")
          }
          assert_integerish(domain$upper, len = 1L, any.missing = FALSE) }, .parent = topenv()),
        disable_in_tune = list(early_stopping_rounds = NULL),
        init = 1000L
      )
      ps = ps(
        alpha                       = p_dbl(0, default = 0, tags = "train"),
        approxcontrib               = p_lgl(default = FALSE, tags = "predict"),
        base_score                  = p_dbl(tags = "train"),
        booster                     = p_fct(c("gbtree", "gblinear", "dart"), default = "gbtree", tags = "train"),
        callbacks                   = p_uty(default = list(), tags = "train"),
        colsample_bylevel           = p_dbl(0, 1, default = 1, tags = "train", depends = quote(booster == "gbtree")),
        colsample_bynode            = p_dbl(0, 1, default = 1, tags = "train", depends = quote(booster == "gbtree")),
        colsample_bytree            = p_dbl(0, 1, default = 1, tags = "train", depends = quote(booster == "gbtree")),
        device                      = p_uty(default = "cpu", tags = "train"),
        disable_default_eval_metric = p_lgl(default = FALSE, tags = "train"),
        early_stopping_rounds       = p_int(1L, default = NULL, special_vals = list(NULL), tags = "train"),
        eta                         = p_dbl(0, 1, default = 0.3, tags = "train"),
        evals                       = p_uty(default = NULL, tags = "train"),
        eval_metric                 = p_uty(tags = "train"),
        custom_metric               = p_uty(tags = "train", custom_check = crate({function(x) check_true(any(is.function(x), test_multi_class(x, c("MeasureRegrSimple"))))})),
        extmem_single_page          = p_lgl(default = FALSE, tags = "train", depends = quote(tree_method %in% c("hist", "approx"))),
        feature_selector            = p_fct(c("cyclic", "shuffle", "random", "greedy", "thrifty"), default = "cyclic", tags = "train", depends = quote(booster == "gblinear")),
        gamma                       = p_dbl(0, default = 0, tags = "train"),
        grow_policy                 = p_fct(c("depthwise", "lossguide"), default = "depthwise", tags = "train", depends = quote(booster == "gbtree" && tree_method %in% c("hist", "approx"))),
        huber_slope                 = p_dbl(default = 1, tags = "train"),
        interaction_constraints     = p_uty(tags = "train", depends = quote(booster == "gbtree")),
        iterationrange              = p_uty(tags = "predict"),
        lambda                      = p_dbl(0, default = 1, tags = "train"),
        max_bin                     = p_int(2L, default = 256L, tags = "train", depends = quote(tree_method %in% c("hist", "approx"))),
        max_cached_hist_node        = p_int(default = 65536L, tags = "train", depends = quote(tree_method %in% c("hist", "approx"))),
        max_cat_to_onehot           = p_int(tags = "train", depends = quote(tree_method %in% c("hist", "approx"))),
        max_cat_threshold           = p_dbl(tags = "train", depends = quote(tree_method %in% c("hist", "approx"))),
        max_delta_step              = p_dbl(0, default = 0, tags = "train", depends = quote(booster == "gbtree")),
        max_depth                   = p_int(0L, default = 6L, tags = "train", depends = quote(booster == "gbtree")),
        max_leaves                  = p_int(0L, default = 0L, tags = "train", depends = quote(booster == "gbtree")),
        maximize                    = p_lgl(default = NULL, special_vals = list(NULL), tags = "train"),
        min_child_weight            = p_dbl(0, default = 1, tags = "train", depends = quote(booster == "gbtree")),
        missing                     = p_dbl(default = NA, tags = "predict", special_vals = list(NA, NA_real_, NULL)),
        monotone_constraints        = p_uty(default = 0, tags = "train", custom_check = crate(function(x) { checkmate::check_integerish(x, lower = -1, upper = 1, any.missing = FALSE) }), depends = quote(booster == "gbtree")), # nolint
        nrounds                     = p_nrounds,
        normalize_type              = p_fct(c("tree", "forest"), default = "tree", tags = "train", depends = quote(booster == "dart")),
        nthread                     = p_int(1L, init = 1L, tags = c("train", "threads")),
        num_parallel_tree           = p_int(1L, default = 1L, tags = "train", depends = quote(booster == "gbtree")),
        objective                   = p_uty(default = "reg:squarederror", tags = c("train", "predict")),
        one_drop                    = p_lgl(default = FALSE, tags = "train", depends = quote(booster == "dart")),
        print_every_n               = p_int(1L, default = 1L, tags = "train", depends = quote(verbose == 1L)),
        rate_drop                   = p_dbl(0, 1, default = 0, tags = "train", depends = quote(booster == "dart")),
        refresh_leaf                = p_lgl(default = TRUE, tags = "train", depends = quote(booster == "gbtree")),
        seed                        = p_int(tags = "train"),
        seed_per_iteration          = p_lgl(default = FALSE, tags = "train"),
        sampling_method             = p_fct(c("uniform", "gradient_based"), default = "uniform", tags = "train", depends = quote(booster == "gbtree")),
        sample_type                 = p_fct(c("uniform", "weighted"), default = "uniform", tags = "train", depends = quote(booster == "dart")),
        save_name                   = p_uty(default = NULL, tags = "train"),
        save_period                 = p_int(0, default = NULL, special_vals = list(NULL), tags = "train"),
        scale_pos_weight            = p_dbl(default = 1, tags = "train", depends = quote(booster == "gbtree")),
        skip_drop                   = p_dbl(0, 1, default = 0, tags = "train", depends = quote(booster == "dart")),
        subsample                   = p_dbl(0, 1, default = 1, tags = "train", depends = quote(booster == "gbtree")),
        top_k                       = p_int(0, default = 0, tags = "train", depends = quote(feature_selector %in% c("greedy", "thrifty") && booster == "gblinear")),
        training                    = p_lgl(default = FALSE, tags = "predict"),
        tree_method                 = p_fct(c("auto", "exact", "approx", "hist", "gpu_hist"), default = "auto", tags = "train", depends = quote(booster %in% c("gbtree", "dart"))),
        tweedie_variance_power      = p_dbl(1, 2, default = 1.5, tags = "train", depends = quote(objective == "reg:tweedie")),
        updater                     = p_uty(tags = "train"), # Default depends on the selected booster
        use_rmm                     = p_lgl(tags = "train"),
        validate_features           = p_lgl(default = TRUE, tags = "predict"),
        verbose                     = p_int(0L, 2L, init = 0L, tags = "train"),
        verbosity                   = p_int(0L, 2L, init = 0L, tags = "train"),
        xgb_model                   = p_uty(default = NULL, tags = "train"),
        use_pred_offset             = p_lgl(init = TRUE, tags = "predict")
      )

      super$initialize(
        id = "regr.xgboost",
        param_set = ps,
        feature_types = c("logical", "integer", "numeric"),
        properties = c("weights", "missings", "importance", "hotstart_forward", "internal_tuning", "validation", "offset"),
        packages = "xgboost"
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

  active = list(
    #' @field internal_valid_scores (named `list()` or `NULL`)
    #' The validation scores extracted from `model$evaluation_log`.
    #' If early stopping is activated, this contains the validation scores of the model for the optimal `nrounds`,
    #' otherwise the `nrounds` for the final model.
    internal_valid_scores = function() {
      self$state$internal_valid_scores
    },
    #' @field internal_tuned_values (named `list()` or `NULL`)
    #' If early stopping is activated, this returns a list with `nrounds`,
    #' which is extracted from `$best_iteration` of the model and otherwise `NULL`.
    internal_tuned_values = function() {
      self$state$internal_tuned_values
    },
    #' @field validate (`numeric(1)` or `character(1)` or `NULL`)
    #' How to construct the internal validation data. This parameter can be either `NULL`,
    #' a ratio, `"test"`, or `"predefined"`.
    validate = function(rhs) {
      if (!missing(rhs)) {
        private$.validate = assert_validate(rhs)
      }
      private$.validate
    },

    #' @field model (any)\cr
    #' The fitted model. Only available after `$train()` has been called.
    model = function(rhs) {
      if (!missing(rhs)) {
        if (inherits(rhs, "xgb.Booster")) {
          rhs = list(
            structure("wrapper", model = rhs)
          )
        }
        self$state$model = rhs
      }
      # workaround https://github.com/Rdatatable/data.table/issues/7456
      attributes(self$state$model[[1]])$model
    }
  ),

  private = list(
    .validate = NULL,
    .train = function(task) {

      pv = self$param_set$get_values(tags = "train")

      if (is.null(pv$objective)) {
        pv$objective = "reg:squarederror"
      }

      data = task$data(cols = task$feature_names)
      target = task$data(cols = task$target_names)

      xgb_data = xgboost::xgb.DMatrix(data = as_numeric_matrix(data), label = data.matrix(target))

      weights = get_weights(task, private)
      if (!is.null(weights)) {
        xgboost::setinfo(xgb_data, "weight", weights)
      }

      if ("offset" %in% task$properties) {
        xgboost::setinfo(xgb_data, "base_margin", task$offset$offset)
      }

      # the last element in the watchlist is used as the early stopping set
      internal_valid_task = task$internal_valid_task
      if (!is.null(pv$early_stopping_rounds) && is.null(internal_valid_task)) {
        stopf("Learner (%s): Configure field 'validate' to enable early stopping.", self$id)
      }
      if (!is.null(internal_valid_task)) {
        valid_data = internal_valid_task$data(cols = task$feature_names)
        valid_target = internal_valid_task$data(cols = task$target_names)

        xgb_valid_data = xgboost::xgb.DMatrix(data = as_numeric_matrix(valid_data), label = data.matrix(valid_target))

        weights = get_weights(internal_valid_task, private)
        if (!is.null(weights)) {
          xgboost::setinfo(xgb_valid_data, "weight", weights)
        }

        if ("offset" %in% internal_valid_task$properties) {
          xgboost::setinfo(xgb_valid_data, "base_margin", internal_valid_task$offset$offset)
        }

        pv$evals = c(pv$evals, list(test = xgb_valid_data))
      }

      # set internal validation measure
      if (inherits(pv$custom_metric, "Measure")) {
        measure = pv$custom_metric

        if (pv$objective %nin% c("reg:absoluteerror", "reg:squarederror")) {
          stop("Only 'reg:squarederror' and 'reg:absoluteerror' objectives are supported.")
        }

        pv$custom_metric = mlr3misc::crate({function(pred, dtrain) {
          truth = xgboost::getinfo(dtrain, "label")
          scores = measure$fun(truth, pred)
          list(metric = measure$id, value = scores)
        }}, measure)

        pv$maximize = !measure$minimize
      }

      model = xgboost::xgb.train(
        params = pv[names(pv) %in% formalArgs(xgboost::xgb.params)],
        data = xgb_data,
        nrounds = pv$nrounds,
        evals = pv$evals,
        custom_metric = pv$custom_metric,
        verbose = pv$verbose,
        print_every_n = pv$print_every_n,
        early_stopping_rounds = pv$early_stopping_rounds,
        maximize = pv$maximize,
        save_period = pv$save_period,
        save_name = pv$save_name,
        callbacks = pv$callbacks %??% list()
      )

      # workaround https://github.com/Rdatatable/data.table/issues/7456
      list(
        structure("wrapper", model = model)
      )
    },
    #' Returns the `$best_iteration` when early stopping is activated.
    .predict = function(task) {
      pv = self$param_set$get_values(tags = "predict")
      model = self$model
      newdata = as_numeric_matrix(ordered_features(task, self))
      if (isTRUE(pv$use_pred_offset) && "offset" %in% task$properties) {
        pv$base_margin = task$offset$offset
      }

      response = invoke(predict, model, newdata = newdata, .args = pv)

      list(response = response)
    },

    .hotstart = function(task) {
      model = self$model
      pv = self$param_set$get_values(tags = "train")
      pv_train = self$state$param_vals
      if (!is.null(pv_train$early_stopping_rounds)) {
        stopf("The parameter `early_stopping_rounds` is set. Early stopping and hotstarting are incompatible.")
      }

      # Calculate additional boosting iterations
      # niter in model and nrounds in ps should be equal after train and continue
      nrounds = pv$nrounds - pv_train$nrounds

      # Construct data
      data = task$data(cols = task$feature_names)
      target = task$data(cols = task$target_names)
      xgb_data = xgboost::xgb.DMatrix(data = as_numeric_matrix(data), label = data.matrix(target))

      if (nrounds > 0) {
        model = xgboost::xgb.train(
          params = pv[names(pv) %in% formalArgs(xgboost::xgb.params)],
          data = xgb_data,
          nrounds = nrounds,
          evals = pv$evals,
          custom_metric = pv$custom_metric,
          verbose = pv$verbose,
          print_every_n = pv$print_every_n,
          early_stopping_rounds = pv$early_stopping_rounds,
          maximize = pv$maximize,
          save_period = pv$save_period,
          save_name = pv$save_name,
          xgb_model = model,
          callbacks = pv$callbacks %??% list()
        )
      }

      list(
        structure("wrapper", model = model)
      )
    },

    .extract_internal_tuned_values = function() {
      if (is.null(self$state$param_vals$early_stopping_rounds)) {
        return(NULL)
      }
      list(nrounds = attributes(self$model)$early_stop$best_iteration)
    },

    .extract_internal_valid_scores = function() {
      if (is.null(attributes(self$model)$evaluation_log)) {
        return(named_list())
      }
      iter = attributes(self$model)$early_stop$best_iteration
      if (is.null(iter)) {
        iter = xgboost::xgb.get.num.boosted.rounds(self$model)
      }
      log = attributes(self$model)$evaluation_log
      as.list(log[
        iter,
        set_names(get(".SD"), gsub("^test_", "", colnames(get(".SD")))),
        .SDcols = patterns("^test_")
      ])
    }
  )
)

#' @export
default_values.LearnerRegrXgboost = function(x, search_space, task, ...) { # nolint
  special_defaults = list(
    nrounds = 1000L
  )
  defaults = insert_named(default_values(x$param_set), special_defaults)
  defaults[search_space$ids()]
}


#' @include aaa.R
learners[["regr.xgboost"]] = LearnerRegrXgboost
