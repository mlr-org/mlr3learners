#' @title Ranger Classification Learner
#'
#' @name mlr_learners_classif.ranger
#'
#' @description
#' Random classification forest.
#' Calls [ranger::ranger()] from package \CRANpkg{ranger}.
#'
#' @template section_dictionary_learner
#' @templateVar id classif.ranger
#'
#' @references
#' \cite{mlr3learners}{wright_2017}
#'
#' \cite{mlr3learners}{breiman_2001}
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerClassifRanger = R6Class("LearnerClassifRanger", inherit = LearnerClassif,
  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ParamSet$new(list(
        ParamInt$new("num.trees", default = 500L, lower = 1L, tags = c("train", "predict")),
        ParamInt$new("mtry", lower = 1L, tags = "train"),
        ParamFct$new("importance", levels = c("none", "impurity", "impurity_corrected", "permutation"), tags = "train"),
        ParamLgl$new("write.forest", default = TRUE, tags = "train"),
        ParamInt$new("min.node.size", default = 1L, lower = 1L, tags = "train"), # for probability == TRUE, def = 10
        ParamLgl$new("replace", default = TRUE, tags = "train"),
        ParamDbl$new("sample.fraction", lower = 0L, upper = 1L, tags = "train"), # for replace == FALSE, def = 0.632
        ParamDbl$new("class.weights", default = NULL, special_vals = list(NULL), tags = "train"),
        ParamFct$new("splitrule", levels = c("gini", "extratrees"), default = "gini", tags = "train"),
        ParamInt$new("num.random.splits", lower = 1L, default = 1L, tags = "train"), # requires = quote(splitrule == "extratrees")
        ParamDbl$new("split.select.weights", lower = 0, upper = 1, tags = "train"),
        ParamUty$new("always.split.variables", tags = "train"),
        ParamFct$new("respect.unordered.factors", levels = c("ignore", "order", "partition"), default = "ignore", tags = "train"), # for splitrule == "extratrees", def = partition
        ParamLgl$new("scale.permutation.importance", default = FALSE, tags = "train"), # requires = quote(importance == "permutation")
        ParamLgl$new("keep.inbag", default = FALSE, tags = "train"),
        ParamLgl$new("holdout", default = FALSE, tags = "train"),
        ParamInt$new("num.threads", lower = 1L, tags = c("train", "predict")),
        ParamLgl$new("save.memory", default = FALSE, tags = "train"),
        ParamLgl$new("verbose", default = TRUE, tags = c("train", "predict")),
        ParamLgl$new("oob.error", default = TRUE, tags = "train")
      ))
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
      self$model$prediction.error
    }
  ),

  private = list(
    .train = function(task) {
      pars = self$param_set$get_values(tags = "train")
      invoke(ranger::ranger,
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
      p = invoke(predict, self$model, data = newdata,
        predict.type = "response", .args = pars)

      if (self$predict_type == "response") {
        PredictionClassif$new(task = task, response = p$predictions)
      } else {
        PredictionClassif$new(task = task, prob = p$predictions)
      }
    }
  )
)
