#' @title Ranger Classification Learner
#'
#' @name mlr_learners_classif.ranger
#'
#' @description
#' Random classification forest.
#' Calls [ranger::ranger()] from package \CRANpkg{ranger}.
#'
#' @section Custom mlr3 parameters:
#' - `mtry`:
#'   - This hyperparameter can alternatively be set via our hyperparameter `mtry.ratio`
#'     as `mtry = max(ceiling(mtry.ratio * n_features), 1)`.
#'     Note that `mtry` and `mtry.ratio` are mutually exclusive.
#'
#' @section Initial parameter values:
#' - `num.threads`:
#'   - Actual default: `NULL`, triggering auto-detection of the number of CPUs.
#'   - Adjusted value: 1.
#'   - Reason for change: Conflicting with parallelization via \CRANpkg{future}.
#'
#' @templateVar id classif.ranger
#' @template learner
#'
#' @references
#' `r format_bib("wright_2017", "breiman_2001")`
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerClassifRanger = R6Class("LearnerClassifRanger",
  inherit = LearnerClassif,

  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ps(
        # FIXME: only works if predict_type == "se". How to set dependency?
        alpha                        = p_dbl(default = 0.5, tags = "train"),
        always.split.variables       = p_uty(tags = "train"),
        class.weights                = p_uty(default = NULL, tags = "train"),
        holdout                      = p_lgl(default = FALSE, tags = "train"),
        importance                   = p_fct(c("none", "impurity", "impurity_corrected", "permutation"), tags = "train"),
        keep.inbag                   = p_lgl(default = FALSE, tags = "train"),
        max.depth                    = p_int(default = NULL, lower = 0L, special_vals = list(NULL), tags = "train"),
        min.bucket                   = p_int(1L, default = 1L, tags = "train"),
        min.node.size                = p_int(1L, default = NULL, special_vals = list(NULL), tags = "train"),
        minprop                      = p_dbl(default = 0.1, tags = "train"),
        mtry                         = p_int(lower = 1L, special_vals = list(NULL), tags = "train"),
        mtry.ratio                   = p_dbl(lower = 0, upper = 1, tags = "train"),
        num.random.splits            = p_int(1L, default = 1L, tags = "train", depends = quote(splitrule == "extratrees")),
        node.stats                   = p_lgl(default = FALSE, tags = "train"),
        num.threads                  = p_int(1L, default = 1L, tags = c("train", "predict", "threads")),
        num.trees                    = p_int(1L, default = 500L, tags = c("train", "predict", "hotstart")),
        oob.error                    = p_lgl(default = TRUE, tags = "train"),
        regularization.factor        = p_uty(default = 1, tags = "train"),
        regularization.usedepth      = p_lgl(default = FALSE, tags = "train"),
        replace                      = p_lgl(default = TRUE, tags = "train"),
        respect.unordered.factors    = p_fct(c("ignore", "order", "partition"), default = "ignore", tags = "train"),
        sample.fraction              = p_dbl(0L, 1L, tags = "train"),
        save.memory                  = p_lgl(default = FALSE, tags = "train"),
        scale.permutation.importance = p_lgl(default = FALSE, tags = "train", depends = quote(importance == "permutation")),
        se.method                    = p_fct(c("jack", "infjack"), default = "infjack", tags = "predict"),
        seed                         = p_int(default = NULL, special_vals = list(NULL), tags = c("train", "predict")),
        split.select.weights         = p_uty(default = NULL, tags = "train"),
        splitrule                    = p_fct(c("gini", "extratrees", "hellinger"), default = "gini", tags = "train"),
        verbose                      = p_lgl(default = TRUE, tags = c("train", "predict")),
        write.forest                 = p_lgl(default = TRUE, tags = "train"),
        use_weights                  = p_lgl(default = FALSE, tags = "train")
      )

      ps$values = list(num.threads = 1L)

      super$initialize(
        id = "classif.ranger",
        param_set = ps,
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric", "character", "factor", "ordered"),
        properties = c("weights", "twoclass", "multiclass", "importance", "oob_error", "hotstart_backward"),
        packages = c("mlr3learners", "ranger"),
        label = "Random Forest",
        man = "mlr3learners::mlr_learners_classif.ranger"
      )
    },

    #' @description
    #' The importance scores are extracted from the model slot `variable.importance`.
    #' Parameter `importance.mode` must be set to `"impurity"`, `"impurity_corrected"`, or
    #' `"permutation"`
    #'
    #' @return Named `numeric()`.
    importance = function() {
      if (is.null(self$model)) {
        stopf("No model stored")
      }
      if (self$model$importance.mode == "none") {
        stopf("No importance stored")
      }

      sort(self$model$variable.importance, decreasing = TRUE)
    },

    #' @description
    #' The out-of-bag error, extracted from model slot `prediction.error`.
    #'
    #' @return `numeric(1)`.
    oob_error = function() {
      if (is.null(self$model)) {
        stopf("No model stored")
      }
      self$model$prediction.error
    }
  ),

  private = list(
    .train = function(task) {
      pv = self$param_set$get_values(tags = "train")
      pv = convert_ratio(pv, "mtry", "mtry.ratio", length(task$feature_names))
      pv$case.weights = get_weights(task, pv)
      pv = remove_named(pv, "use_weights")

      invoke(ranger::ranger,
        dependent.variable.name = task$target_names,
        data = task$data(),
        probability = self$predict_type == "prob",
        .args = pv
      )
    },

    .predict = function(task) {
      pv = self$param_set$get_values(tags = "predict")
      newdata = ordered_features(task, self)

      prediction = invoke(predict,
        self$model,
        data = newdata,
        predict.type = "response", .args = pv
      )

      if (self$predict_type == "response") {
        list(response = prediction$predictions)
      } else {
        list(prob = prediction$predictions)
      }
    },

    .hotstart = function(task) {
      model = self$model
      model$num.trees = self$param_set$values$num.trees
      model
    }
  )
)

#' @export
default_values.LearnerClassifRanger = function(x, search_space, task, ...) { # nolint
  special_defaults = list(
    mtry = floor(sqrt(length(task$feature_names))),
    mtry.ratio = floor(sqrt(length(task$feature_names))) / length(task$feature_names),
    min.node.size = if (x$predict_type == "response") 5 else 10,
    sample.fraction = 1
  )
  defaults = insert_named(default_values(x$param_set), special_defaults)
  defaults[search_space$ids()]
}

#' @include aaa.R
learners[["classif.ranger"]] = LearnerClassifRanger
