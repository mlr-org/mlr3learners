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
#' \cite{mlr3learners}{wright_2017}
#'
#' \cite{mlr3learners}{breiman_2001}
#'
#' @export
#' @template seealso_learner
#' @templateVar learner_name regr.ranger
#' @template example
LearnerRegrRanger = R6Class("LearnerRegrRanger", inherit = LearnerRegr,
  public = list(
    initialize = function() {
      ps = ParamSet$new(list(
        ParamInt$new("num.trees", default = 500L, lower = 1L, tags = c("train", "predict")),
        ParamInt$new("mtry", lower = 1L, tags = "train"),
        ParamFct$new("importance", levels = c("none", "impurity", "impurity_corrected", "permutation"), tags = "train"),
        ParamLgl$new("write.forest", default = TRUE, tags = "train"),
        ParamInt$new("min.node.size", default = 5L, lower = 1L, tags = "train"), # for probability == TRUE, def = 10
        ParamLgl$new("replace", default = TRUE, tags = "train"),
        ParamDbl$new("sample.fraction", lower = 0L, upper = 1L, tags = "train"), # for replace == FALSE, def = 0.632
        ParamFct$new("splitrule", levels = c("variance", "extratrees", "maxstat"), default = "variance", tags = "train"),
        ParamInt$new("num.random.splits", lower = 1L, default = 1L, tags = "train"),
        ParamDbl$new("alpha", default = 0.5, tags = "train"),
        ParamDbl$new("minprop", default = 0.1, tags = "train"),
        ParamDbl$new("split.select.weights", lower = 0, upper = 1, tags = "train"),
        ParamUty$new("always.split.variables", tags = "train"),
        ParamFct$new("respect.unordered.factors", levels = c("ignore", "order", "partition"), default = "ignore", tags = "train"), # for splitrule == "extratrees", def = partition
        ParamLgl$new("scale.permutation.importance", default = FALSE, tags = "train"),
        ParamLgl$new("keep.inbag", default = FALSE, tags = "train"),
        ParamLgl$new("holdout", default = FALSE, tags = "train"), # FIXME: do we need this?
        ParamInt$new("num.threads", lower = 1L, tags = c("train", "predict")),
        ParamLgl$new("save.memory", default = FALSE, tags = "train"),
        ParamLgl$new("verbose", default = TRUE, tags = c("train", "predict")),
        ParamLgl$new("oob.error", default = TRUE, tags = "train")
      ))
      ps$add_dep("num.random.splits", "splitrule", CondEqual$new("extratrees"))
      ps$add_dep("alpha", "splitrule", CondEqual$new("maxstat"))
      ps$add_dep("minprop", "splitrule", CondEqual$new("maxstat"))
      ps$add_dep("scale.permutation.importance", "importance", CondEqual$new("permutation"))


      super$initialize(
        id = "regr.ranger",
        param_set = ps,
        predict_types = c("response", "se"),
        feature_types = c("logical", "integer", "numeric", "character", "factor", "ordered"),
        properties = c("weights", "importance", "oob_error"),
        packages = "ranger",
        man = "mlr3learners::mlr_learners_regr.ranger"
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
