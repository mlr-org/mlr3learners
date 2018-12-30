#' @title Classification Ranger Learner
#' @name mlr_learners_classif_ranger
#' @format [R6::R6Class()] inheriting from [LearnerClassif].
#' @description
#' A learner for a classification random forest implemented in [ranger::ranger()].
#' @export
LearnerClassifRanger = R6Class("LearnerClassifRanger", inherit = LearnerClassif,
  public = list(
    initialize = function(id = "classif.ranger") {
      super$initialize(
        id = id,
        packages = "ranger",
        feature_types = c("logical", "integer", "numeric", "character", "factor", "ordered"),
        predict_types = c("response", "prob"),
        param_set = ParamSet$new(
          params = list(
            ParamInt$new(id = "num.trees", default = 500L, lower = 1L, tags = c("train", "predict")),
            ParamInt$new(id = "mtry", lower = 1L, tags = "train"),
            ParamFct$new(id = "importance", values = c("none", "impurity", "impurity_corrected", "permutation"), tags = "train"),
            ParamLgl$new(id = "write.forest", default = TRUE, tags = "train"),
            ParamInt$new(id = "min.node.size", default = 1L, lower = 1L, tags = "train"), # for probability == TRUE, def = 10
            ParamLgl$new(id = "replace", default = TRUE, tags = "train"),
            ParamDbl$new(id = "sample.fraction", lower = 0L, upper = 1L, tags = "train"), # for replace == FALSE, def = 0.632
            # ParamDbl$new(id = "case.weights", defaul = NULL, tags = "train"), # How to handle weights?
            # ParamDbl$new(id = "class.weights", defaul = NULL, tags = "train"), #
            ParamFct$new(id = "splitrule", values = c("gini", "extratrees"), default = "gini", tags = "train"),
            ParamInt$new(id = "num.random.splits", lower = 1L, default = 1L, tags = "train"), # requires = quote(splitrule == "extratrees")
            ParamDbl$new(id = "split.select.weights", lower = 0, upper = 1, tags = "train"),
            ParamUty$new(id = "always.split.variables", tags = "train"),
            ParamFct$new(id = "respect.unordered.factors", values = c("ignore", "order", "partition"), default = "ignore", tags = "train"), # for splitrule == "extratrees", def = partition
            ParamLgl$new(id = "scale.permutation.importance", default = FALSE, tags = "train"), #requires = quote(importance == "permutation")
            ParamLgl$new(id = "keep.inbag", default = FALSE, tags = "train"),
            ParamLgl$new(id = "holdout", default = FALSE, tags = "train"),
            ParamInt$new(id = "num.threads", lower = 1L, tags = c("train", "predict")),
            ParamLgl$new(id = "save.memory", default = FALSE, tags = "train"),
            ParamLgl$new(id = "verbose", default = TRUE, tags = c("train", "predict")),
            ParamInt$new(id = "seed", tags = c("train", "predict"))
          )
        ),
        properties = c("weights", "twoclass", "multiclass", "importance")
      )
    },

    train = function(task) {
      pars = self$params_train
      self$model = invoke(ranger::ranger,
        dependent.variable.name = task$target_names,
        data = task$data(),
        probability = self$predict_type == "prob",
        case.weights = NULL, # FIXME: task$weights,
        .args = pars
      )
      self
    },

    predict = function(task) {
      pars = self$params_predict
      newdata = task$data()
      preds = invoke(predict, self$model, data = newdata,
        predict.type = "response", .args = pars)

      if (self$predict_type == "response") {
        response = preds$predictions
        prob = NULL
      } else {
        response = NULL
        prob = preds$predictions
      }

      PredictionClassif$new(task, response, prob)
    },

    importance = function() {
      if (is.null(self$model))
        stopf("No model stored")
      if (self$model$importance.mode == "none")
        stopf("No importance stored")

      setorderv(enframe(self$model$variable.importance), "value", order = -1L)[]
    }
  )
)
