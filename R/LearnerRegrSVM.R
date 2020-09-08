#' @title Support Vector Machine
#'
#' @name mlr_learners_regr.svm
#'
#' @description
#' A learner for a regression support vector machine implemented in [e1071::svm()].
#'
#' @templateVar id regr.svm
#' @template section_dictionary_learner
#'
#' @references
#' \cite{mlr3learners}{cortes_1995}
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerRegrSVM = R6Class("LearnerRegrSVM",
  inherit = LearnerRegr,
  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ParamSet$new(list(
        ParamFct$new("type",
          default = "eps-regression",
          levels = c("eps-regression", "nu-regression"), tags = "train"),
        ParamFct$new("kernel", default = "radial", levels = c(
          "linear", "polynomial",
          "radial", "sigmoid"), tags = "train"),
        ParamInt$new("degree", default = 3L, lower = 1L, tags = "train"),
        ParamDbl$new("coef0", default = 0, tags = "train"),
        ParamDbl$new("cost", default = 1, lower = 0, tags = "train"),
        ParamDbl$new("nu", default = 0.5, tags = "train"),
        ParamDbl$new("gamma", lower = 0, tags = "train"),
        ParamDbl$new("cachesize", default = 40L, tags = "train"),
        ParamDbl$new("tolerance", default = 0.001, lower = 0, tags = "train"),
        ParamDbl$new("epsilon", lower = 0, tags = "train"),
        ParamLgl$new("shrinking", default = TRUE, tags = "train"),
        ParamInt$new("cross", default = 0L, lower = 0L, tags = "train"), # tunable = FALSE),
        ParamLgl$new("fitted", default = TRUE, tags = "train"), # tunable = FALSE),
        ParamUty$new("scale", default = TRUE, tags = "train") # , tunable = TRUE)
      ))
      ps$add_dep("cost", "type", CondEqual$new("eps-regression"))
      ps$add_dep("nu", "type", CondEqual$new("nu-regression"))
      ps$add_dep("degree", "kernel", CondEqual$new("polynomial"))
      ps$add_dep("coef0", "kernel", CondAnyOf$new(c("polynomial", "sigmoid")))
      ps$add_dep("gamma", "kernel", CondAnyOf$new(c("polynomial", "radial", "sigmoid")))
      ps$add_dep("epsilon", "type", CondEqual$new("eps-regression"))

      super$initialize(
        id = "regr.svm",
        param_set = ps,
        feature_types = c("logical", "integer", "numeric"),
        packages = "e1071",
        man = "mlr3learners::mlr_learners_regr.svm"
      )
    }
  ),

  private = list(
    .train = function(task) {
      pars = self$param_set$get_values(tags = "train")
      data = as.matrix(task$data(cols = task$feature_names))
      self$state$feature_names = colnames(data)

      invoke(e1071::svm, x = data, y = task$truth(), .args = pars)
    },

    .predict = function(task) {
      pars = self$param_set$get_values(tags = "predict")
      newdata = as.matrix(task$data(cols = task$feature_names))
      newdata = newdata[, self$state$feature_names, drop = FALSE]
      response = invoke(stats::predict, self$model, newdata = newdata, type = "response", .args = pars)
      list(response = response)
    }
  )
)
