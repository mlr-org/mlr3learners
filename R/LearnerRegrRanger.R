#' @title Ranger Regression Learner
#'
#' @usage NULL
#' @aliases mlr_learners_regr.ranger
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerClassif].
#'
#' @section Construction:
#' ```
#' LearnerRegrRanger$new()
#' mlr3::mlr_learners$get("regr.ranger")
#' mlr3::lrn("regr.ranger")
#' ```
#'
#' @description
#' Random regression forest.
#' Calls [ranger::ranger()] from package \CRANpkg{ranger}.
#'
#' @references
#' Marvin N. Wright and Andreas Ziegler (2017).
#' ranger: A Fast Implementation of Random Forests for High Dimensional Data in C++ and R.
#' Journal of Statistical Software, 77(1), 1-17.
#' \doi{10.18637/jss.v077.i01}.
#'
#' Breiman, L. (2001).
#' Random Forests.
#' Machine Learning 45(1).
#' \doi{10.1023/A:1010933404324}.
#'
#' @export
#' @template seealso_learner
#' @templateVar learner_name regr.ranger
#' @template example
LearnerRegrRanger = R6Class("LearnerRegrRanger", inherit = LearnerRegr,
  public = list(
    initialize = function() {
      super$initialize(
        id = "regr.ranger",
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
            ParamLgl$new(id = "scale.permutation.importance", default = FALSE, tags = "train"), # requires = quote(importance == "permutation")
            ParamLgl$new(id = "keep.inbag", default = FALSE, tags = "train"),
            ParamLgl$new(id = "holdout", default = FALSE, tags = "train"), # FIXME: do we need this?
            ParamInt$new(id = "num.threads", lower = 1L, tags = c("train", "predict")),
            ParamLgl$new(id = "save.memory", default = FALSE, tags = "train"),
            ParamLgl$new(id = "verbose", default = TRUE, tags = c("train", "predict")),
            ParamLgl$new(id = "oob.error", default = TRUE, tags = "train")
          )
        ),
        predict_types = c("response", "se"),
        feature_types = c("logical", "integer", "numeric", "character", "factor", "ordered"),
        properties = c("weights", "importance", "oob_error"),
        packages = "ranger"
      )
    },

    train_internal = function(task) {
      pars = self$param_set$get_values(tags = "train")

      if (self$predict_type == "se") {
        pars$keep.inbag = TRUE
      }

      invoke(ranger::ranger,
        dependent.variable.name = task$target_names,
        data = task$data(),
        case.weights = task$weights$weight,
        .args = pars
      )
    },

    predict_internal = function(task) {
      pars = self$param_set$get_values(tags = "predict")
      newdata = task$data(cols = task$feature_names)
      preds = invoke(predict, self$model, data = newdata, type = self$predict_type, .args = pars)
      PredictionRegr$new(task = task, response = preds$predictions, se = preds$se)
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
      self$model$prediction.error
    }
  )
)
