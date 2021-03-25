#' @title Ranger Classification Learner
#'
#' @name mlr_learners_classif.ranger
#'
#' @description
#' Random classification forest.
#' Calls [ranger::ranger()] from package \CRANpkg{ranger}.
#'
#' @section Custom mlr3 defaults:
#' - `num.threads`:
#'   - Actual default: `NULL`, triggering auto-detection of the number of CPUs.
#'   - Adjusted value: 1.
#'   - Reason for change: Conflicting with parallelization via \CRANpkg{future}.
#'
#' @template section_dictionary_learner
#' @templateVar id classif.ranger
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
        num.trees = p_int(default = 500L, lower = 1L, tags = c("train", "predict")),
        mtry = p_int(lower = 1L, tags = "train"),
        importance = p_fct(levels = c( "none", "impurity", "impurity_corrected", "permutation"), tags = "train"),
        write.forest = p_lgl(default = TRUE, tags = "train"),
        min.node.size = p_int(default = 1L, lower = 1L, tags = "train"),
        replace = p_lgl(default = TRUE, tags = "train"),
        sample.fraction = p_dbl(lower = 0L, upper = 1L, tags = "train"),
        class.weights = p_dbl(default = NULL, special_vals = list(NULL), tags = "train"),
        splitrule = p_fct(default = "gini", levels = c("gini", "extratrees"), tags = "train"),
        num.random.splits = p_int(lower = 1L, default = 1L, tags = "train"),
        split.select.weights = p_dbl(lower = 0, upper = 1, tags = "train"),
        always.split.variables = p_uty(tags = "train"),
        respect.unordered.factors = p_fct(default = "ignore", levels = c("ignore", "order", "partition"), tags = "train"),
        scale.permutation.importance = p_lgl(default = FALSE, tags = "train"),
        keep.inbag = p_lgl(default = FALSE, tags = "train"),
        holdout = p_lgl(default = FALSE, tags = "train"),
        num.threads = p_int(lower = 1L, default = 1L, tags = c("train", "predict", "threads")),
        save.memory = p_lgl(default = FALSE, tags = "train"),
        verbose = p_lgl(default = TRUE, tags = c("train", "predict")),
        oob.error = p_lgl(default = TRUE, tags = "train"),
        max.depth = p_int(default = NULL, special_vals = list(NULL), tags = "train"),
        alpha = p_dbl(default = 0.5, tags = "train"),
        min.prop = p_dbl(default = 0.1, tags = "train"),
        regularization.factor = p_uty(default = 1, tags = "train"),
        regularization.usedepth = p_lgl(default = FALSE, tags = "train"),
        seed = p_int(default = NULL, special_vals = list(NULL), tags = "train"),
        minprop = p_dbl(default = 0.1, tags = "train"),
        # FIXME: only works if predict_type == "se". How to set dependency?
        se.method = p_fct(default = "infjack", levels = c("jack", "infjack"), tags = "predict")
      )

      ps$values = list(num.threads = 1L)

      ps$add_dep("num.random.splits", "splitrule", CondEqual$new("extratrees"))
      ps$add_dep("scale.permutation.importance", "importance", CondEqual$new("permutation"))

      super$initialize(
        id = "classif.ranger",
        param_set = ps,
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric", "character", "factor", "ordered"),
        properties = c("weights", "twoclass", "multiclass", "importance", "oob_error"),
        packages = "ranger",
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
      pars = self$param_set$get_values(tags = "train")
      mlr3misc::invoke(ranger::ranger,
        dependent.variable.name = task$target_names,
        data = task$data(),
        probability = self$predict_type == "prob",
        case.weights = task$weights$weight,
        .args = pars
      )
    },

    .predict = function(task) {
      pars = self$param_set$get_values(tags = "predict")
      newdata = task$data(cols = task$feature_names)
      p = mlr3misc::invoke(predict, self$model,
        data = newdata,
        predict.type = "response", .args = pars)

      if (self$predict_type == "response") {
        list(response = p$predictions)
      } else {
        list(prob = p$predictions)
      }
    }
  )
)
