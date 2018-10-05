LearnerClassifRanger = R6Class("LearnerClassifRanger", inherit = LearnerClassif,
  public = list(
    initialize = function(id = "classif.ranger") {
      super$initialize(
        id = id,
        packages = "ranger",
        feature_types = c("logical", "integer", "numeric", "character", "factor", "ordered"),
        predict_types = c("response", "prob"),
        par_set = ParamSet$new(
          params = list(
            ParamInt$new(id = "num.trees", default = 500L, lower = 1L),
            ParamReal$new(id = "mtry", lower = 1)
          )
        ),
        properties = c("twoclass", "multiclass")
      )
    },

    train = function(task, ...) {
      ranger::ranger(task$formula, task$data(), probability = (self$predict_type == "prob"), ...)
    },

    predict = function(model, task, ...) {
      newdata = task$data(cols = task$feature_names)
      preds = predict(model, data = newdata, predict.type = "response")

      if (self$predict_type == "response") {
        prob = NULL
        response = preds$predictions
      } else {
        prob = preds$predictions
        response = colnames(prob)[apply(prob, 1, which.max)]
      }

      PredictionClassif$new(task, response, prob)
    }
  )
)
