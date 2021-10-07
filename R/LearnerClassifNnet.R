#' @title Classification Neural Network Learner
#'
#' @name mlr_learners_classif.nnet
#'
#' @description
#' Single Layer Neural Network.
#' Calls [nnet::nnet.formula()] from package \CRANpkg{nnet}.
#'
#' Note that modern neural networks with multiple layers are connected
#' via package [mlr3keras](https://github.com/mlr-org/mlr3keras).
#'
#' @templateVar id classif.nnet
#' @template section_dictionary_learner
#'
#' @section Custom mlr3 defaults:
#' - `size`:
#'   - Adjusted default: 3L.
#'   - Reason for change: no default in `nnet()`.
#'
#' @references
#' `r format_bib("ripley_1996")`
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerClassifNnet = R6Class("LearnerClassifNnet",
  inherit = LearnerClassif,
  public = list(
    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {

      ps = ps(
        Hess      = p_lgl(default = FALSE, tags = "train"),
        MaxNWts   = p_int(1L, default = 1000L, tags = "train"),
        Wts       = p_uty(tags = "train"),
        abstol    = p_dbl(default = 1.0e-4, tags = "train"),
        censored  = p_lgl(default = FALSE, tags = "train"),
        contrasts = p_uty(default = NULL, tags = "train"),
        decay     = p_dbl(default = 0, tags = "train"),
        entropy   = p_lgl(default = FALSE, tags = "train"),
        linout    = p_lgl(default = FALSE, tags = "train"),
        mask      = p_uty(tags = "train"),
        maxit     = p_int(1L, default = 100L, tags = "train"),
        na.action = p_uty(tags = "train"),
        rang      = p_dbl(default = 0.7, tags = "train"),
        reltol    = p_dbl(default = 1.0e-8, tags = "train"),
        size      = p_int(0L, default = 3L, tags = "train"),
        skip      = p_lgl(default = FALSE, tags = "train"),
        softmax   = p_lgl(default = FALSE, tags = "train"),
        subset    = p_uty(tags = "train"),
        trace     = p_lgl(default = TRUE, tags = "train")
      )
      ps$values = list(size = 3L)
      ps$add_dep("linout", "entropy", CondEqual$new(FALSE))
      ps$add_dep("linout", "softmax", CondEqual$new(FALSE))
      ps$add_dep("linout", "censored", CondEqual$new(FALSE))
      ps$add_dep("entropy", "linout", CondEqual$new(FALSE))
      ps$add_dep("entropy", "softmax", CondEqual$new(FALSE))
      ps$add_dep("entropy", "censored", CondEqual$new(FALSE))
      ps$add_dep("softmax", "linout", CondEqual$new(FALSE))
      ps$add_dep("softmax", "entropy", CondEqual$new(FALSE))
      ps$add_dep("softmax", "censored", CondEqual$new(FALSE))
      ps$add_dep("censored", "linout", CondEqual$new(FALSE))
      ps$add_dep("censored", "entropy", CondEqual$new(FALSE))
      ps$add_dep("censored", "softmax", CondEqual$new(FALSE))

      super$initialize(
        id = "classif.nnet",
        packages = "nnet",
        feature_types = c("numeric", "factor", "ordered"),
        predict_types = c("prob", "response"),
        param_set = ps,
        properties = c("twoclass", "multiclass", "weights"),
        man = "mlr3learners::mlr_learners_classif.nnet"
      )
    }
  ),

  private = list(
    .train = function(task) {
      pv = self$param_set$get_values(tags = "train")
      if ("weights" %in% task$properties) {
        pv = insert_named(pv, list(weights = task$weights$weight))
      }
      f = task$formula()
      data = task$data()
      invoke(nnet::nnet.formula, formula = f, data = data, .args = pv)
    },

    .predict = function(task) {
      newdata = task$data(cols = task$feature_names)

      if (self$predict_type == "response") {
        response = invoke(predict, self$model, newdata = newdata, type = "class")
        return(list(response = response))
      } else {
        lvls = self$model$lev
        prob = invoke(predict, self$model, newdata = newdata, type = "raw")

        if (length(lvls) == 2L) {
          prob = pvec2mat(prob[, 1L], lvls)
        }
        return(list(prob = prob))
      }
    }
  )
)
