#' @title Ranger Regression Learner
#'
#' @name mlr_learners_regr.ranger
#'
#' @description
#' Random regression forest.
#' Calls [ranger::ranger()] from package \CRANpkg{ranger}.
#'
#' @templateVar id regr.ranger
#' @template section_dictionary_learner
#'
#' @inheritSection mlr_learners_classif.ranger Custom mlr3 defaults
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
        alpha                        = p_dbl(default = 0.5, tags = "train"),
        always.split.variables       = p_uty(tags = "train"),
        holdout                      = p_lgl(default = FALSE, tags = "train"),
        importance                   = p_fct(c("none", "impurity", "impurity_corrected", "permutation"), tags = "train"),
        keep.inbag                   = p_lgl(default = FALSE, tags = "train"),
        max.depth                    = p_int(default = NULL, special_vals = list(NULL), tags = "train"),
        min.node.size                = p_int(1L, default = 5L, tags = "train"),
        min.prop                     = p_dbl(default = 0.1, tags = "train"),
        minprop                      = p_dbl(default = 0.1, tags = "train"),
        mtry                         = p_int(1L, tags = "train"),
        num.random.splits            = p_int(1L, default = 1L, tags = "train"),
        num.threads                  = p_int(1L, default = 1L, tags = c("train", "predict", "threads")),
        num.trees                    = p_int(1L, default = 500L, tags = c("train", "predict")),
        oob.error                    = p_lgl(default = TRUE, tags = "train"),
        quantreg                     = p_lgl(default = FALSE, tags = "train"),
        regularization.factor        = p_uty(default = 1, tags = "train"),
        regularization.usedepth      = p_lgl(default = FALSE, tags = "train"),
        replace                      = p_lgl(default = TRUE, tags = "train"),
        respect.unordered.factors    = p_fct(c("ignore", "order", "partition"), default = "ignore", tags = "train"),
        sample.fraction              = p_dbl(0L, 1L, tags = "train"),
        save.memory                  = p_lgl(default = FALSE, tags = "train"),
        scale.permutation.importance = p_lgl(default = FALSE, tags = "train"),
        se.method                    = p_fct(c("jack", "infjack"), default = "infjack", tags = "predict"), # FIXME: only works if predict_type == "se". How to set dependency?
        seed                         = p_int(default = NULL, special_vals = list(NULL), tags = c("train", "predict")),
        split.select.weights         = p_dbl(0, 1, tags = "train"),
        splitrule                    = p_fct(c("variance", "extratrees", "maxstat"), default = "variance", tags = "train"),
        verbose                      = p_lgl(default = TRUE, tags = c("train", "predict")),
        write.forest                 = p_lgl(default = TRUE, tags = "train")
      )

      ps$values = list(num.threads = 1L)

      # deps
      ps$add_dep("num.random.splits", "splitrule", CondEqual$new("extratrees"))
      ps$add_dep("alpha", "splitrule", CondEqual$new("maxstat"))
      ps$add_dep("minprop", "splitrule", CondEqual$new("maxstat"))
      ps$add_dep("scale.permutation.importance", "importance", CondEqual$new("permutation"))


      super$initialize(
        id = "regr.ranger",
        param_set = ps,
        predict_types = c("response", "se"),
        feature_types = c("logical", "integer", "numeric", "character", "factor", "ordered"),
        properties = c("weights", "importance", "oob_error"),
        packages = "ranger",
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

      if (self$predict_type == "se") {
        pars$keep.inbag = TRUE # nolint
      }

      invoke(ranger::ranger,
        dependent.variable.name = task$target_names,
        data = task$data(),
        case.weights = task$weights$weight,
        .args = pars
      )
    },

    .predict = function(task) {
      pars = self$param_set$get_values(tags = "predict")
      newdata = task$data(cols = task$feature_names)
      preds = invoke(predict, self$model,
        data = newdata,
        type = self$predict_type, .args = pars)
      list(response = preds$predictions, se = preds$se)
    }
  )
)
