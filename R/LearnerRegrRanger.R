#' @title Ranger Regression Learner
#'
#' @name mlr_learners_regr.ranger
#'
#' @description
#' Random regression forest.
#' Calls `ranger()` from package \CRANpkg{ranger}.
#'
#' @details
#' Additionally to the uncertainty estimation methods provided by the ranger package, the learner provides a simple and law of total variance uncertainty estimation.
#' Both methods compute the empirical mean and variance of the training data points that fall into the predicted leaf nodes.
#' The simple method calculates the variance of the mean of the leaf nodes.
#' The law of total variance method calculates the mean of the variance of the leaf nodes plus the variance of the means of the leaf nodes.
#'
#' @inheritSection mlr_learners_classif.ranger Custom mlr3 parameters
#' @inheritSection mlr_learners_classif.ranger Initial parameter values
#'
#' @templateVar id regr.ranger
#' @template learner
#'
#' @references
#' `r format_bib("wright_2017", "breiman_2001")`
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerRegrRanger = R6Class("LearnerRegrRanger",
  inherit = LearnerRegr,

  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ps(
        always.split.variables       = p_uty(tags = "train"),
        holdout                      = p_lgl(default = FALSE, tags = "train"),
        importance                   = p_fct(c("none", "impurity", "impurity_corrected", "permutation"), tags = "train"),
        keep.inbag                   = p_lgl(default = FALSE, tags = "train"),
        max.depth                    = p_int(default = NULL, lower = 1L, special_vals = list(NULL), tags = "train"),
        min.bucket                   = p_int(1L, default = 1L, tags = "train"),
        min.node.size                = p_int(1L, default = 5L, special_vals = list(NULL), tags = "train"),
        mtry                         = p_int(lower = 1L, special_vals = list(NULL), tags = "train"),
        mtry.ratio                   = p_dbl(lower = 0, upper = 1, tags = "train"),
        na.action                    = p_fct(c("na.learn", "na.omit", "na.fail"), default = "na.learn", tags = "train"),
        node.stats                   = p_lgl(default = FALSE, tags = "train"),
        num.random.splits            = p_int(1L, default = 1L, tags = "train", depends = quote(splitrule == "extratrees")),
        num.threads                  = p_int(1L, default = 1L, tags = c("train", "predict", "threads")),
        num.trees                    = p_int(1L, default = 500L, tags = c("train", "predict", "hotstart")),
        oob.error                    = p_lgl(default = TRUE, tags = "train"),
        poisson.tau                  = p_dbl(default = 1, tags = "train", depends = quote(splitrule == "poisson")),
        regularization.factor        = p_uty(default = 1, tags = "train"),
        regularization.usedepth      = p_lgl(default = FALSE, tags = "train"),
        replace                      = p_lgl(default = TRUE, tags = "train"),
        respect.unordered.factors    = p_fct(c("ignore", "order", "partition"), tags = "train"),
        sample.fraction              = p_dbl(0L, 1L, tags = "train"),
        save.memory                  = p_lgl(default = FALSE, tags = "train"),
        scale.permutation.importance = p_lgl(default = FALSE, tags = "train", depends = quote(importance == "permutation")),
        se.method                    = p_fct(c("jack", "infjack", "simple", "law_of_total_variance"), default = "infjack", tags = "predict"),
        seed                         = p_int(default = NULL, special_vals = list(NULL), tags = c("train", "predict")),
        split.select.weights         = p_uty(default = NULL, tags = "train"),
        splitrule                    = p_fct(c("variance", "extratrees", "maxstat", "beta", "poisson"), default = "variance", tags = "train"),
        verbose                      = p_lgl(default = TRUE, tags = c("train", "predict")),
        write.forest                 = p_lgl(default = TRUE, tags = "train")
      )

      ps$set_values(num.threads = 1L)

      super$initialize(
        id = "regr.ranger",
        param_set = ps,
        predict_types = c("response", "se", "quantiles"),
        feature_types = c("logical", "integer", "numeric", "character", "factor", "ordered"),
        properties = c("weights", "importance", "oob_error", "hotstart_backward", "missings", "selected_features"),
        packages = c("mlr3learners", "ranger"),
        label = "Random Forest",
        man = "mlr3learners::mlr_learners_regr.ranger"
      )
    },

    #' @description
    #' The importance scores are extracted from the model slot `variable.importance`.
    #' Parameter `importance.mode` must be set to `"impurity"`, `"impurity_corrected"`, or
    #' `"permutation"`
    #'
    #' @return Named `numeric()`.
    importance = function() {
      if (is.null(self$model$model)) {
        stopf("No model stored")
      }
      if (self$model$model$importance.mode == "none") {
        stopf("No importance stored")
      }

      sort(self$model$model$variable.importance, decreasing = TRUE)
    },

    #' @description
    #' The out-of-bag error, extracted from model slot `prediction.error`.
    #'
    #' @return `numeric(1)`.
    oob_error = function() {
      if (is.null(self$model$model)) {
        stopf("No model stored")
      }
      self$model$model$prediction.error
    },

    #' @description
    #' The set of features used for node splitting in the forest.
    #'
    #' @return `character()`.
    selected_features = function() {
      ranger_selected_features(self)
    }
  ),

  private = list(
    .train = function(task) {
      pv = self$param_set$get_values(tags = "train")
      pv = convert_ratio(pv, "mtry", "mtry.ratio", length(task$feature_names))
      pv$se.method = NULL
      pv$case.weights = get_weights(task, private)

      if (self$predict_type == "se") {
        pv$keep.inbag = TRUE # nolint
      }

      if (self$predict_type == "quantiles") {
        pv$quantreg = TRUE # nolint
      }

      model = invoke(ranger::ranger,
        dependent.variable.name = task$target_names,
        data = task$data(),
        .args = pv
      )

      if (isTRUE(self$param_set$values$se.method %in% c("simple", "law_of_total_variance"))) {
        data = ordered_features(task, self)
        prediction_nodes = mlr3misc::invoke(predict, model, data = data, type = "terminalNodes", .args = pv[setdiff(names(pv), "se.method")], predict.all = TRUE)
        storage.mode(prediction_nodes$predictions) = "integer"
        mu_sigma = .Call("c_ranger_mu_sigma", model, prediction_nodes$predictions, task$truth())
        list(model = model, mu_sigma = mu_sigma)
      } else {
        list(model = model)
      }
    },

    .predict = function(task) {
      pv = self$param_set$get_values(tags = "predict")
      newdata = ordered_features(task, self)

      if (isTRUE(pv$se.method %in% c("simple", "law_of_total_variance"))) {
        prediction_nodes = mlr3misc::invoke(predict, self$model$model, data = newdata, type = "terminalNodes", .args = pv[setdiff(names(pv), "se.method")], predict.all = TRUE)
        storage.mode(prediction_nodes$predictions) = "integer"
        method = if (pv$se.method == "simple") 0 else 1
        .Call("c_ranger_var", prediction_nodes$predictions, self$model$mu_sigma, method)
      } else {
        prediction = mlr3misc::invoke(predict, self$model$model, data = newdata, type = self$predict_type, quantiles = private$.quantiles, .args = pv)

        if (self$predict_type == "quantiles") {
          quantiles = prediction$predictions
          setattr(quantiles, "probs", private$.quantiles)
          setattr(quantiles, "response", private$.quantile_response)
          return(list(quantiles = quantiles))
        }

        list(response = prediction$predictions, se = prediction$se)
      }
    },

    .hotstart = function(task) {
      model = self$model$model
      model$num.trees = self$param_set$values$num.trees
      list(model = model)
    }
  )
)

#' @export
default_values.LearnerRegrRanger = function(x, search_space, task, ...) { # nolint
  special_defaults = list(
    mtry = floor(sqrt(length(task$feature_names))),
    mtry.ratio = floor(sqrt(length(task$feature_names))) / length(task$feature_names),
    sample.fraction = 1
  )
  defaults = insert_named(default_values(x$param_set), special_defaults)
  defaults[search_space$ids()]
}

#' @include aaa.R
learners[["regr.ranger"]] = LearnerRegrRanger
