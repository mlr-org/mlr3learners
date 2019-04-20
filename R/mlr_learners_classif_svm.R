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
            ParamFct$new(id = "type", default = "C-classification", levels = c("C-classification", "nu-classification"), tag = "train"),
            ParamDbl$new(id = "cost",  default = 1, lower = 0, tag = "train"), #requires = quote(type == "C-classification")),
            ParamDbl$new(id = "nu", default = 0.5, tag = "train"), #requires = quote(type == "nu-classification")),
            ParamFct$new(id = "kernel", default = "radial", levels = c("linear", "polynomial", "radial", "sigmoid"), tag = "train"),
            ParamInt$new(id = "degree", default = 3L, lower = 1L, tag = "train"), #requires = quote(kernel == "polynomial")),
            ParamDbl$new(id = "coef0", default = 0, tag = "train"), #requires = quote(kernel == "polynomial" || kernel == "sigmoid")),
            ParamDbl$new(id = "gamma", lower = 0, tag = "train"), #requires = quote(kernel != "linear")),
            ParamDbl$new(id = "cachesize", default = 40L, tag = "train"),
            ParamDbl$new(id = "tolerance", default = 0.001, lower = 0, tag = "train"),
            ParamLgl$new(id = "shrinking", default = TRUE, tag = "train"),
            ParamInt$new(id = "cross", default = 0L, lower = 0L, tag = "train"), #tunable = FALSE),
            ParamLgl$new(id = "fitted", default = TRUE, tag = "train"), #tunable = FALSE),
            ParamUty$new(id = "scale", default = TRUE, tag = "train")#, tunable = TRUE)
          )
        ),
        predict_types = c("response", "prob"),
        feature_types = c("integer", "numeric"),
        properties = c("twoclass", "multiclass"),
        packages = "e1071"
      )
    },

    train = function(task) {
      pars = self$params("train")

      self$model = invoke(e1071::svm,
        x = as.matrix(task$data(cols = task$feature_names)),
        y = task$truth(),
        probability = (self$predict_type == "prob"),
        .args = pars
      )

      self
    },

    predict = function(task) {
      pars = self$params("predict")
      newdata = as.matrix(task$data(cols = task$feature_names))

      response = invoke(predict, self$model, newdata = newdata, probability = (self$predict_type == "prob") , .args = pars)
      prob = attr(response, "probabilities") # is NULL if not requested in line before

      PredictionClassif$new(task, response, prob)
    }
  )
)
