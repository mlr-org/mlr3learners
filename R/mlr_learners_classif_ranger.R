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
            ParamDbl$new(id = "mtry", lower = 1, tags = "train")
          )
        ),
        properties = c("twoclass", "multiclass")
      )
    },

    train = function(task) {
      invoke(ranger::ranger,
        formula = task$formula,
        data = task$data(),
        probability = (self$predict_type == "prob"),
        .args = self$params_train
      )
    },

    predict = function(model, task) {
      newdata = task$data()
      preds = predict(model, data = newdata, predict.type = "response")

      if (self$predict_type == "response") {
        response = preds$predictions
        prob = NULL
      } else {
        response = NULL
        prob = preds$predictions
      }

      PredictionClassif$new(task, response, prob)
    }
  )
)
