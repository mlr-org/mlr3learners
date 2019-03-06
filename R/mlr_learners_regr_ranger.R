#' @title Regression Ranger Learner
#'
#' @name mlr_learners_classif.ranger
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerClassif].
#'
#' @description
#' A learner for a regression random forest implemented in [ranger::ranger()].
#'
#' @export
LearnerRegrRanger = R6Class("LearnerRegrRanger", inherit = LearnerRegr,
  public = list(
    initialize = function(id = "regr.ranger") {
      super$initialize(
        id = id,
        param_set = ParamSet$new(
          params = list(
            ParamInt$new(id = "num.trees", default = 500L, lower = 1L, tags = c("train", "predict")),
            ParamInt$new(id = "mtry", lower = 1L, tags = "train"),
            ParamFct$new(id = "importance", levels = c("none", "impurity", "impurity_corrected", "permutation"), tags = "train"),
            ParamLgl$new(id = "write.forest", default = TRUE, tags = "train"),
            ParamInt$new(id = "min.node.size", default = 5L, lower = 1L, tags = "train"), # for probability == TRUE, def = 10
            ParamLgl$new(id = "replace", default = TRUE, tags = "train"),
            ParamDbl$new(id = "sample.fraction", lower = 0L, upper = 1L, tags = "train"), # for replace == FALSE, def = 0.632
            # ParamDbl$new(id = "class.weights", defaul = NULL, tags = "train"), #
            ParamFct$new(id = "splitrule", levels = c("variance", "extratrees", "maxstat"), default = "variance", tags = "train"),
            ParamInt$new(id = "num.random.splits", lower = 1L, default = 1L, tags = "train"), # requires = quote(splitrule == "extratrees")
            ParamDbl$new(id = "split.select.weights", lower = 0, upper = 1, tags = "train"),
            ParamUty$new(id = "always.split.variables", tags = "train"),
            ParamFct$new(id = "respect.unordered.factors", levels = c("ignore", "order", "partition"), default = "ignore", tags = "train"), # for splitrule == "extratrees", def = partition
            ParamLgl$new(id = "scale.permutation.importance", default = FALSE, tags = "train"), #requires = quote(importance == "permutation")
            ParamLgl$new(id = "keep.inbag", default = FALSE, tags = "train"),
            ParamLgl$new(id = "holdout", default = FALSE, tags = "train"), #FIXME: do we need this?
            ParamInt$new(id = "num.threads", lower = 1L, tags = c("train", "predict")),
            ParamLgl$new(id = "save.memory", default = FALSE, tags = "train"),
            ParamLgl$new(id = "verbose", default = TRUE, tags = c("train", "predict")),
            ParamInt$new(id = "seed", tags = c("train", "predict"))
          )
        ),
        predict_types = c("response", "se"),
        feature_types = c("logical", "integer", "numeric", "character", "factor", "ordered"),
        properties = c("weights", "importance"),
        packages = "ranger"
      )
    },

    train = function(task) {
      pars = self$params("train")
      self$model = invoke(ranger::ranger,
        dependent.variable.name = task$target_names,
        data = task$data(),
        case.weights = task$weights$weight,
        .args = pars
      )
      self
    },

    predict = function(task) {
      pars = self$params("predict")
      newdata = task$data(cols = task$feature_names)

      if (self$predict_type == "response") {
        preds = invoke(predict, self$model, data = newdata,
          type = "response", .args = pars)
        response = preds$predictions
        se = NULL
      } else {
        preds = invoke(predict, self$model, data = newdata,
          type = "se", .args = pars)
        response = preds$predictions
        se = preds$se
      }
      PredictionRegr$new(task, response, se)
    },

    importance = function() {
      if (is.null(self$model))
        stopf("No model stored")
      if (self$model$importance.mode == "none")
        stopf("No importance stored")

      sort(self$model$variable.importance, decreasing = TRUE)
    }
  )
)
