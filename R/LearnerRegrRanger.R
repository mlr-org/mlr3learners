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

      ps = ParamSet$new(list(
        ParamInt$new("num.trees", default = 500L, lower = 1L, tags = c("train", "predict")),
        ParamInt$new("mtry", lower = 1L, tags = "train"),
        ParamFct$new("importance",
          levels = c(
            "none", "impurity",
            "impurity_corrected", "permutation"),
          tags = "train"),
        ParamLgl$new("write.forest", default = TRUE, tags = "train"),
        ParamInt$new("min.node.size", default = 5L, lower = 1L, tags = "train"),
        ParamLgl$new("replace", default = TRUE, tags = "train"),
        ParamDbl$new("sample.fraction", lower = 0L, upper = 1L, tags = "train"),
        ParamFct$new("splitrule",
          levels = c("variance", "extratrees", "maxstat"),
          default = "variance", tags = "train"),
        ParamInt$new("num.random.splits", lower = 1L, default = 1L, tags = "train"),
        ParamDbl$new("alpha", default = 0.5, tags = "train"),
        ParamDbl$new("minprop", default = 0.1, tags = "train"),
        ParamDbl$new("split.select.weights", lower = 0, upper = 1, tags = "train"),
        ParamUty$new("always.split.variables", tags = "train"),
        ParamFct$new("respect.unordered.factors",
          levels = c("ignore", "order", "partition"),
          default = "ignore", tags = "train"),
        ParamLgl$new("keep.inbag", default = FALSE, tags = "train"),
        ParamLgl$new("holdout", default = FALSE, tags = "train"),
        ParamInt$new("num.threads", lower = 1L, default = 1L, tags = c("train", "predict", "threads")),
        ParamLgl$new("save.memory", default = FALSE, tags = "train"),
        ParamLgl$new("verbose", default = TRUE, tags = c("train", "predict")),
        ParamLgl$new("oob.error", default = TRUE, tags = "train"),
        ParamLgl$new("scale.permutation.importance", default = FALSE, tags = "train"),
        ParamInt$new("max.depth", default = NULL, special_vals = list(NULL), tags = "train"),
        ParamDbl$new("min.prop", default = 0.1, tags = "train"),
        ParamUty$new("regularization.factor", default = 1, tags = "train"),
        ParamLgl$new("regularization.usedepth", default = FALSE, tags = "train"),
        ParamInt$new("seed",
          default = NULL, special_vals = list(NULL),
          tags = c("train", "predict")),
        ParamLgl$new("quantreg", default = FALSE, tags = "train"),
        # FIXME: only works if predict_type == "se". How to set dependency?
        ParamFct$new("se.method",
          default = "infjack", levels = c("jack", "infjack"),
          tags = "predict")
      ))

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

      mlr3misc::invoke(ranger::ranger,
        dependent.variable.name = task$target_names,
        data = task$data(),
        case.weights = task$weights$weight,
        .args = pars
      )
    },

    .predict = function(task) {
      pars = self$param_set$get_values(tags = "predict")
      newdata = task$data(cols = task$feature_names)
      preds = mlr3misc::invoke(predict, self$model,
        data = newdata,
        type = self$predict_type, .args = pars)
      list(response = preds$predictions, se = preds$se)
    }
  )
)
