#' @title Support Vector Machine
#'
#' @name mlr_learners_regr.svm
#'
#' @description
#' Support vector machine for regression.
#' Calls [e1071::svm()] from package \CRANpkg{e1071}.
#'
#' @templateVar id regr.svm
#' @template learner
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
        coef0     = p_dbl(default = 0, tags = "train", depends = quote(kernel %in% c("polynomial", "sigmoid"))),
        cost      = p_dbl(0, default = 1, tags = "train", depends = quote(type %in% c("eps-regression", "nu-regression"))),
        cross     = p_int(0L, default = 0L, tags = "train"), # tunable = FALSE),
        degree    = p_int(1L, default = 3L, tags = "train", depends = quote(kernel == "polynomial")),
        epsilon   = p_dbl(0, default = 0.1, tags = "train", depends = quote(type == "eps-regression")),
        fitted    = p_lgl(default = TRUE, tags = "train"), # tunable = FALSE),
        gamma     = p_dbl(0, tags = "train", depends = quote(kernel %in% c("polynomial", "radial", "sigmoid"))),
        kernel    = p_fct(c("linear", "polynomial", "radial", "sigmoid"), default = "radial", tags = "train"),
        nu        = p_dbl(default = 0.5, tags = "train", depends = quote(type == "nu-regression")),
        scale     = p_uty(default = TRUE, tags = "train"),
        shrinking = p_lgl(default = TRUE, tags = "train"),
        tolerance = p_dbl(0, default = 0.001, tags = "train"),
        type      = p_fct(c("eps-regression", "nu-regression"), default = "eps-regression", tags = "train")
      )

      super$initialize(
        id = "regr.svm",
        param_set = ps,
        feature_types = c("logical", "integer", "numeric"),
        packages = "e1071"
      )
    }
  ),

  private = list(
    .train = function(task) {
      pv = self$param_set$get_values(tags = "train")
      data = as_numeric_matrix(task$data(cols = task$feature_names))

      invoke(e1071::svm, x = data, y = task$truth(), .args = pv)
    },

    .predict = function(task) {
      pv = self$param_set$get_values(tags = "predict")
      newdata = as_numeric_matrix(ordered_features(task, self))
      response = invoke(predict, self$model, newdata = newdata, type = "response", .args = pv)
      list(response = response)
    }
  )
)

#' @export
default_values.LearnerRegrSVM = function(x, search_space, task, ...) { # nolint
  special_defaults = list(
    gamma = 1 / length(task$feature_names)
  )
  defaults = insert_named(default_values(x$param_set), special_defaults)
  defaults[["degree"]] = NULL
  defaults[search_space$ids()]
}

#' @include aaa.R
learners[["regr.svm"]] = LearnerRegrSVM
