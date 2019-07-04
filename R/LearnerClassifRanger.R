#' @title Ranger Classification Learner
#'
#' @aliases mlr_learners_classif.ranger
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerClassif].
#'
#' @description
#' Random classification forest.
#' Calls [ranger::ranger()] from package \CRANpkg{ranger}.
#'
#' @export
#' @templateVar learner_name classif.ranger
#' @template example
LearnerClassifRanger = R6Class("LearnerClassifRanger", inherit = LearnerClassif,
  public = list(
    initialize = function(id = "classif.ranger") {
      super$initialize(
        id = id,
        param_set = ParamSet$new(
          params = list(
            ParamInt$new(id = "num.trees", default = 500L, lower = 1L, tags = c("train", "predict")),
            ParamInt$new(id = "mtry", lower = 1L, tags = "train"),
            ParamFct$new(id = "importance", levels = c("none", "impurity", "impurity_corrected", "permutation"), tags = "train"),
            ParamLgl$new(id = "write.forest", default = TRUE, tags = "train"),
            ParamInt$new(id = "min.node.size", default = 1L, lower = 1L, tags = "train"), # for probability == TRUE, def = 10
            ParamLgl$new(id = "replace", default = TRUE, tags = "train"),
            ParamDbl$new(id = "sample.fraction", lower = 0L, upper = 1L, tags = "train"), # for replace == FALSE, def = 0.632
            # ParamDbl$new(id = "class.weights", defaul = NULL, tags = "train"), #
            ParamFct$new(id = "splitrule", levels = c("gini", "extratrees"), default = "gini", tags = "train"),
            ParamInt$new(id = "num.random.splits", lower = 1L, default = 1L, tags = "train"), # requires = quote(splitrule == "extratrees")
            ParamDbl$new(id = "split.select.weights", lower = 0, upper = 1, tags = "train"),
            ParamUty$new(id = "always.split.variables", tags = "train"),
            ParamFct$new(id = "respect.unordered.factors", levels = c("ignore", "order", "partition"), default = "ignore", tags = "train"), # for splitrule == "extratrees", def = partition
            ParamLgl$new(id = "scale.permutation.importance", default = FALSE, tags = "train"), # requires = quote(importance == "permutation")
            ParamLgl$new(id = "keep.inbag", default = FALSE, tags = "train"),
            ParamLgl$new(id = "holdout", default = FALSE, tags = "train"),
            ParamInt$new(id = "num.threads", lower = 1L, tags = c("train", "predict")),
            ParamLgl$new(id = "save.memory", default = FALSE, tags = "train"),
            ParamLgl$new(id = "verbose", default = TRUE, tags = c("train", "predict")),
            ParamLgl$new(id = "oob.error", default = TRUE, tags = "train")
          )
        ),
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric", "character", "factor", "ordered"),
        properties = c("weights", "twoclass", "multiclass", "importance", "oob_error"),
        packages = "ranger"
      )
    },

    train_internal = function(task) {
      pars = self$param_set$get_values(tags ="train")
      invoke(ranger::ranger,
        dependent.variable.name = task$target_names,
        data = task$data(),
        probability = self$predict_type == "prob",
        case.weights = task$weights$weight,
        .args = pars
      )
    },

    predict_internal = function(task) {
      pars = self$param_set$get_values(tags ="predict")
      newdata = task$data(cols = task$feature_names)
      p = invoke(predict, self$model, data = newdata,
        predict.type = "response", .args = pars)

      if (self$predict_type == "response") {
        list(response = p$predictions)
      } else {
        list(prob = p$predictions)
      }
    },

    importance = function() {
      if (is.null(self$model)) {
        stopf("No model stored")
      }
      if (self$model$importance.mode == "none") {
        stopf("No importance stored")
      }

      sort(self$model$variable.importance, decreasing = TRUE)
    },

    oob_error = function() {
      mod$prediction.error
    }
  )
)
