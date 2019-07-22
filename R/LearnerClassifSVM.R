#' @title Support Vector Machine
#'
#' @aliases mlr_learners_classif.svm
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerClassif].
#'
#' @description
#' A learner for a classification support vector machine implemented in [e1071::svm()].
#'
#' @references
#' Corinna Cortes and Vladimir Vapnik (1995).
#' Machine Learning 20: 273.
#' https://doi.org/10.1007/BF00994018
#'
#' @export
#' @templateVar learner_name classif.svm
#' @template example
LearnerClassifSVM = R6Class("LearnerClassifSVM", inherit = LearnerClassif,
  public = list(
    initialize = function(id = "classif.svm") {
      super$initialize(
        id = id,
        param_set = ParamSet$new(
          params = list(
            ParamFct$new(id = "type", default = "C-classification", levels = c("C-classification", "nu-classification"), tags = "train"),
            ParamDbl$new(id = "cost", default = 1, lower = 0, tags = "train"), # requires = quote(type == "C-classification")),
            ParamDbl$new(id = "nu", default = 0.5, tags = "train"), # requires = quote(type == "nu-classification")),
            ParamFct$new(id = "kernel", default = "radial", levels = c("linear", "polynomial", "radial", "sigmoid"), tags = "train"),
            ParamInt$new(id = "degree", default = 3L, lower = 1L, tags = "train"), # requires = quote(kernel == "polynomial")),
            ParamDbl$new(id = "coef0", default = 0, tags = "train"), # requires = quote(kernel == "polynomial" || kernel == "sigmoid")),
            ParamDbl$new(id = "gamma", lower = 0, tags = "train"), # requires = quote(kernel != "linear")),
            ParamDbl$new(id = "cachesize", default = 40L, tags = "train"),
            ParamDbl$new(id = "tolerance", default = 0.001, lower = 0, tags = "train"),
            ParamLgl$new(id = "shrinking", default = TRUE, tags = "train"),
            ParamInt$new(id = "cross", default = 0L, lower = 0L, tags = "train"), # tunable = FALSE),
            ParamLgl$new(id = "fitted", default = TRUE, tags = "train"), # tunable = FALSE),
            ParamUty$new(id = "scale", default = TRUE, tags = "train") # , tunable = TRUE)
          )
        ),
        predict_types = c("response", "prob"),
        feature_types = c("integer", "numeric"),
        properties = c("twoclass", "multiclass"),
        packages = "e1071"
      )
    },

    train_internal = function(task) {
      pars = self$param_set$get_values(tags = "train")

      invoke(e1071::svm,
        x = as.matrix(task$data(cols = task$feature_names)),
        y = task$truth(),
        probability = (self$predict_type == "prob"),
        .args = pars
      )
    },

    predict_internal = function(task) {
      pars = self$param_set$get_values(tags = "predict")
      newdata = as.matrix(task$data(cols = task$feature_names))
      p = invoke(predict, self$model, newdata = newdata, probability = (self$predict_type == "prob"), .args = pars)

      PredictionClassif$new(task = task,
        response = as.character(p),
        prob = attr(p, "probabilities") # is NULL if not requested during predict
      )
    }
  )
)
