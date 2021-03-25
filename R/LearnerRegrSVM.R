#' @title Support Vector Machine
#'
#' @name mlr_learners_regr.svm
#'
#' @description
#' Support vector machine for regression.
#' Calls [e1071::svm()] from package \CRANpkg{e1071}.
#'
#' @templateVar id regr.svm
#' @template section_dictionary_learner
#'
#' @references
#' `r format_bib("cortes_1995")`
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
      ps = ps(
        cachesize = p_dbl(default = 40L, tags = "train"),
        coef0     = p_dbl(default = 0, tags = "train"),
        cost      = p_dbl(0, default = 1, tags = "train"),
        cross     = p_int(0L, default = 0L, tags = "train"), # tunable = FALSE),
        degree    = p_int(1L, default = 3L, tags = "train"),
        epsilon   = p_dbl(0, tags = "train"),
        gamma     = p_dbl(0, tags = "train"),
        kernel    = p_fct(c("linear", "polynomial", "radial", "sigmoid"), default = "radial", tags = "train"),
        nu        = p_dbl(default = 0.5, tags = "train"),
        shrinking = p_lgl(default = TRUE, tags = "train"),
        tolerance = p_dbl(0, default = 0.001, tags = "train"),
        type      = p_fct(c("eps-regression", "nu-regression"), default = "eps-regression", tags = "train"),
        fitted = p_lgl(default = TRUE, tags = "train"), # tunable = FALSE),
        scale = p_uty(default = TRUE, tags = "train") # , tunable = TRUE)
      )
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
      data = as_numeric_matrix(task$data(cols = task$feature_names))
      self$state$feature_names = colnames(data)

      invoke(e1071::svm, x = data, y = task$truth(), .args = pars)
    },

    .predict = function(task) {
      pars = self$param_set$get_values(tags = "predict")
      newdata = as_numeric_matrix(task$data(cols = task$feature_names))
      newdata = newdata[, self$state$feature_names, drop = FALSE]
      response = invoke(predict, self$model, newdata = newdata, type = "response", .args = pars)
      list(response = response)
    }
  )
)
