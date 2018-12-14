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
            ParamFct$new(id = "importance", values = c("none", "impurity", "impurity_corrected", "permutation"), tags = "train")
          )
        ),
        properties = c("twoclass", "multiclass", "importance")
      )
    },

    train = function(task) {
      self$model = invoke(ranger::ranger,
        formula = task$formula,
        data = task$data(),
        probability = (self$predict_type == "prob"),
        .args = self$params_train
      )
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
