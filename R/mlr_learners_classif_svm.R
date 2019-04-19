#' @title Support Vector Machine
#'
#' @name mlr_learners_classif.svm
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerClassif].
#'
#' @description
#' A learner for a classification support vector machine implemented in [e1071::svm()].
#'
#' @export
LearnerClassifSvm = R6Class("LearnerClassifSvm", inherit = LearnerClassif,
  public = list(
    initialize = function(id = "classif.svm") {
      super$initialize(
        id = id,
        param_set = ParamSet$new(
          params = list(
            ParamFct$new(id = "type", default = "C-classification", levels = c("C-classification", "nu-classification")),
            ParamDbl$new(id = "cost",  default = 1, lower = 0), #requires = quote(type == "C-classification")),
            ParamDbl$new(id = "nu", default = 0.5), #requires = quote(type == "nu-classification")),
            ParamFct$new(id = "kernel", default = "radial", levels = c("linear", "polynomial", "radial", "sigmoid")),
            ParamInt$new(id = "degree", default = 3L, lower = 1L), #requires = quote(kernel == "polynomial")),
            ParamDbl$new(id = "coef0", default = 0), #requires = quote(kernel == "polynomial" || kernel == "sigmoid")),
            ParamDbl$new(id = "gamma", lower = 0), #requires = quote(kernel != "linear")),
            ParamDbl$new(id = "cachesize", default = 40L),
            ParamDbl$new(id = "tolerance", default = 0.001, lower = 0),
            ParamLgl$new(id = "shrinking", default = TRUE),
            ParamInt$new(id = "cross", default = 0L, lower = 0L), #tunable = FALSE),
            ParamLgl$new(id = "fitted", default = TRUE), #tunable = FALSE),
            ParamUty$new(id = "scale", default = TRUE)#, tunable = TRUE) # <- gehen so vektorparameter ?
          )
        ),
        predict_types = c("response", "prob"),
        feature_types = c("integer", "numeric"),
        properties = c("twoclass", "multiclass", "weights"),
        packages = "e1071"
      )
    },

    train = function(task) {
      pars = self$params("train")
      data = as.matrix(task$data(cols = task$feature_names))
      target = as.factor(as.matrix(task$data(cols = task$target_names)))

      if("weights" %in% task$properties) {
        levs = as.character(task$class_names)
        names(task$weights$weight) = levs

        self$model = invoke(e1071::svm,
          x = data,
          y = target,
          probability = self$predict_type == "prob",
          class.weights = task$weights$weight,
          .args = pars
        )
      } else {
        self$model = invoke(e1071::svm,
          x = data,
          y = target,
          probability = self$predict_type == "prob",
          .args = pars
        )
      }

      self
    },

    predict = function(task) {
      pars = self$params("predict")
      newdata = as.matrix(task$data(cols = task$feature_names))
      response = prob = NULL
      levs = as.character(task$class_names)

      probs = invoke(predict, self$model, newdata = newdata, probability = self$predict_type == "prob", .args = pars)

      if (self$predict_type == "prob") {
        prob = attr(probs, "probabilities")
      } else {
        response = probs
      }

      PredictionClassif$new(task, response, prob)
    }
  )
)

