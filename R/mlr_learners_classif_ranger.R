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
            ParamInt$new(id = "num.trees", default = 500L, lower = 1L, tags = "train"),
            ParamDbl$new(id = "mtry", lower = 1, tags = "train"),
            ParamInt$new(id = "min.node.size", lower = 1L),
            ParamLgl$new(id = "replace", default = TRUE),
            ParamDbl$new(id = "sample.fraction", lower = 0L, upper = 1L),
            ParamDbl$new(id = "split.select.weights", lower = 0, upper = 1),
            ParamUty$new(id = "always.split.variables"),
            ParamFct$new(id = "respect.unordered.factors", values = c("ignore", "order", "partition"), default = "ignore"),
            ParamFct$new(id = "importance", values = c("none", "impurity", "impurity_corrected", "permutation"), tags = "train")
            ParamLgl$new(id = "write.forest", default = TRUE),
            ParamLgl$new(id = "scale.permutation.importance", default = FALSE, requires = quote(importance == "permutation")),
            ParamInt$new(id = "num.threads", lower = 1L, when = "both"),
            ParamLgl$new(id = "save.memory", default = FALSE),
            ParamLgl$new(id = "verbose", default = TRUE, when = "both"),
            ParamInt$new(id = "seed", when = "both"),
            ParamFct$new(id = "splitrule", values = c("gini", "extratrees"), default = "gini"),
            ParamInt$new(id = "num.random.splits", lower = 1L, default = 1L, requires = quote(splitrule == "extratrees")),
            ParamLgl$new(id = "keep.inbag", default = FALSE)
          )
        ),
        properties = c("twoclass", "multiclass", "importance")
      )
    },

    train = function(task) {
      pars = self$params_train
      self$model = mlr3misc::invoke(ranger::ranger, formula = task$formula,
        data = task$data(), .args = pars)
      self
    },

    predict = function(task) {
      newdata = task$data()
      preds = predict(self$model, data = newdata, predict.type = "response")

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
