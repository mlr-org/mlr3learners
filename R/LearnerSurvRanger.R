#' @title Ranger Survival Learner
#'
#' @name mlr_learners_surv.ranger
#'
#' @description
#' Random survival forest.
#' Calls [ranger::ranger()] from package \CRANpkg{ranger}.
#'
#' @template section_dictionary_learner
#' @templateVar id surv.ranger
#'
#' @references
#' `r tools::toRd(bibentries[c("wright_2017", "breiman_2001")])`
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerSurvRanger = R6Class("LearnerSurvRanger",
  inherit = mlr3proba::LearnerSurv,
  public = list(
    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      super$initialize(
        id = "surv.ranger",
        param_set = ParamSet$new(
          params = list(
            ParamInt$new(
              id = "num.trees", default = 500L, lower = 1L,
              tags = c("train", "predict")),
            ParamInt$new(id = "mtry", lower = 1L, tags = "train"),
            ParamFct$new(id = "importance", levels = c(
              "none", "impurity", "impurity_corrected",
              "permutation"), tags = "train"),
            ParamLgl$new(id = "write.forest", default = TRUE, tags = "train"),
            ParamInt$new(id = "min.node.size", default = 5L, lower = 1L, tags = "train"),
            ParamLgl$new(id = "replace", default = TRUE, tags = "train"),
            ParamDbl$new(
              id = "sample.fraction", lower = 0L, upper = 1L,
              tags = "train"), # for replace == FALSE, def = 0.632
            # ParamDbl$new(id = "class.weights", defaul = NULL, tags = "train"), #
            ParamFct$new(
              id = "splitrule", levels = c("logrank", "extratrees", "C", "maxstat"),
              default = "logrank", tags = "train"),
            ParamInt$new(id = "num.random.splits", lower = 1L, default = 1L, tags = "train"),
            # requires = quote(splitrule == "extratrees")
            ParamInt$new("max.depth", default = NULL, special_vals = list(NULL), tags = "train"),
            ParamDbl$new("alpha", default = 0.5, tags = "train"),
            ParamDbl$new("minprop", default = 0.1, tags = "train"),
            ParamUty$new("regularization.factor", default = 1, tags = "train"),
            ParamLgl$new("regularization.usedepth", default = FALSE, tags = "train"),
            ParamInt$new("seed", default = NULL, special_vals = list(NULL),
                         tags = c("train", "predict")),
            ParamDbl$new(id = "split.select.weights", lower = 0, upper = 1, tags = "train"),
            ParamUty$new(id = "always.split.variables", tags = "train"),
            ParamFct$new(
              id = "respect.unordered.factors",
              levels = c("ignore", "order", "partition"), default = "ignore",
              tags = "train"), # for splitrule == "extratrees", def = partition
            ParamLgl$new(
              id = "scale.permutation.importance", default = FALSE,
              tags = "train"), # requires = quote(importance == "permutation")
            ParamLgl$new(id = "keep.inbag", default = FALSE, tags = "train"),
            ParamLgl$new(id = "holdout", default = FALSE, tags = "train"), # FIXME: do we need this?
            ParamInt$new(id = "num.threads", lower = 1L, tags = c("train", "predict")),
            ParamLgl$new(id = "save.memory", default = FALSE, tags = "train"),
            ParamLgl$new(id = "verbose", default = TRUE, tags = c("train", "predict")),
            ParamLgl$new(id = "oob.error", default = TRUE, tags = "train")
          )
        ),
        predict_types = c("distr", "crank"),
        feature_types = c("logical", "integer", "numeric", "character", "factor", "ordered"),
        properties = c("weights", "importance", "oob_error"),
        packages = "ranger",
        man = "mlr3learners::mlr_learners_surv.ranger"
      )
    },

    #' @description
    #' The importance scores are extracted from the model slot `variable.importance`.
    #' @return Named `numeric()`.
    importance = function() {
      if (is.null(self$model)) {
        stopf("No model stored")
      }
      if (self$model$importance.mode == "none") {
        stopf("No importance stored")
      }

      sort(self$model$variable.importance, decreasing = TRUE)
    },

    #' @description
    #' The out-of-bag error is extracted from the model slot `prediction.error`.
    #' @return `numeric(1)`.
    oob_error = function() {
      self$model$prediction.error
    }
  ),

  private = list(
    .train = function(task) {
      pv = self$param_set$get_values(tags = "train")
      targets = task$target_names

      mlr3misc::invoke(ranger::ranger,
        formula = NULL,
        dependent.variable.name = targets[1L],
        status.variable.name = targets[2L],
        data = task$data(),
        case.weights = task$weights$weight,
        .args = pv
      )
    },

    .predict = function(task) {

      newdata = task$data(cols = task$feature_names)
      fit = stats::predict(object = self$model, data = newdata)

      # define WeightedDiscrete distr6 object from predicted survival function
      x = rep(list(data = data.frame(x = fit$unique.death.times, cdf = 0)), task$nrow)
      for (i in 1:task$nrow) {
        x[[i]]$cdf = 1 - fit$survival[i, ]
      }

      distr = distr6::VectorDistribution$new(
        distribution = "WeightedDiscrete", params = x,
        decorators = c("CoreStatistics", "ExoticStatistics"))

      crank = as.numeric(sapply(x, function(y) sum(y[, 1] * c(y[, 2][1], diff(y[, 2])))))

      list(distr = distr, crank = crank)
    }
  )
)
