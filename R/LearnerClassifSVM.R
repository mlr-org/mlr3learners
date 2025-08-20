#' @title Support Vector Machine
#'
#' @name mlr_learners_classif.svm
#'
#' @description
#' Support vector machine for classification.
#' Calls [e1071::svm()] from package \CRANpkg{e1071}.
#'
#' @templateVar id classif.svm
#' @template learner
#'
#' @references
#' `r format_bib("cortes_1995")`
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerClassifSVM = R6Class("LearnerClassifSVM",
  inherit = LearnerClassif,

  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ps(
        cachesize       = p_dbl(default = 40L, tags = "train"),
        class.weights   = p_uty(default = NULL, tags = "train"),
        coef0           = p_dbl(default = 0, tags = "train", depends = quote(kernel %in% c("polynomial", "sigmoid"))),
        cost            = p_dbl(0, default = 1, tags = "train", depends = quote(type == "C-classification")),
        cross           = p_int(0L, default = 0L, tags = "train"),
        decision.values = p_lgl(default = FALSE, tags = "predict"),
        degree          = p_int(1L, default = 3L, tags = "train", depends = quote(kernel == "polynomial")),
        epsilon         = p_dbl(0, default = 0.1, tags = "train"),
        fitted          = p_lgl(default = TRUE, tags = "train"),
        gamma           = p_dbl(0, tags = "train", depends = quote(kernel %in% c("polynomial", "radial", "sigmoid"))),
        kernel          = p_fct(c("linear", "polynomial", "radial", "sigmoid"), default = "radial", tags = "train"),
        nu              = p_dbl(default = 0.5, tags = "train", depends = quote(type == "nu-classification")),
        scale           = p_uty(default = TRUE, tags = "train"),
        shrinking       = p_lgl(default = TRUE, tags = "train"),
        tolerance       = p_dbl(0, default = 0.001, tags = "train"),
        type            = p_fct(c("C-classification", "nu-classification"), default = "C-classification", tags = "train")
      )

      super$initialize(
        id = "classif.svm",
        param_set = ps,
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric"),
        properties = c("twoclass", "multiclass"),
        packages = "e1071"
      )
    }
  ),

  private = list(
    .train = function(task) {
      pv = self$param_set$get_values(tags = "train")
      data = as_numeric_matrix(task$data(cols = task$feature_names))

      invoke(e1071::svm,
        x = data,
        y = task$truth(),
        probability = (self$predict_type == "prob"),
        .args = pv
      )
    },

    .predict = function(task) {
      pv = self$param_set$get_values(tags = "predict")
      newdata = as_numeric_matrix(ordered_features(task, self))
      p = invoke(predict, self$model,
        newdata = newdata,
        probability = (self$predict_type == "prob"), .args = pv)

      list(
        response = as.character(p),
        prob = attr(p, "probabilities") # is NULL if not requested during predict
      )
    }
  )
)

#' @export
default_values.LearnerClassifSVM = function(x, search_space, task, ...) { # nolint
  special_defaults = list(
    gamma = 1 / length(task$feature_names)
  )
  defaults = insert_named(default_values(x$param_set), special_defaults)
  # defaults[["degree"]] = NULL
  defaults = defaults[search_space$ids()]

  # fix dependencies
  if (!is.null(defaults[["degree"]])) defaults[["degree"]] = NA_real_
  if (!is.null(defaults[["coef0"]])) defaults[["coef0"]] = NA_real_

  defaults
}

#' @include aaa.R
learners[["classif.svm"]] = LearnerClassifSVM
