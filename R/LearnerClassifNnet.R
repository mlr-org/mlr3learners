#' @title Classification Neural Network Learner
#'
#' @name mlr_learners_classif.nnet
#'
#' @description
#' Single Layer Neural Network.
#' Calls [nnet::nnet.formula()] from package \CRANpkg{nnet}.
#'
#' Note that modern neural networks with multiple layers are connected
#' via package [mlr3torch](https://github.com/mlr-org/mlr3torch).
#'
#' @templateVar id classif.nnet
#' @template learner
#'
#' @section Initial parameter values:
#' - `size`:
#'   - Adjusted default: 3L.
#'   - Reason for change: no default in `nnet()`.
#'
#' @section Custom mlr3 parameters:
#' - `formula`: if not provided, the formula is set to `task$formula()`.
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
        mask      = p_uty(tags = "train"),
        maxit     = p_int(1L, default = 100L, tags = "train"),
        na.action = p_uty(tags = "train"),
        rang      = p_dbl(default = 0.7, tags = "train"),
        reltol    = p_dbl(default = 1.0e-8, tags = "train"),
        size      = p_int(0L, default = 3L, tags = "train"),
        skip      = p_lgl(default = FALSE, tags = "train"),
        subset    = p_uty(tags = "train"),
        trace     = p_lgl(default = TRUE, tags = "train"),
        formula   = p_uty(tags = "train")
      )
      ps$values = list(size = 3L)

      super$initialize(
        id = "classif.nnet",
        packages = c("mlr3learners", "nnet"),
        feature_types = c("logical", "numeric", "factor", "ordered", "integer"),
        predict_types = c("prob", "response"),
        param_set = ps,
        properties = c("twoclass", "multiclass", "weights"),
        label = "Single Layer Neural Network",
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
      if (is.null(pv$formula)) {
        pv$formula = task$formula()
      }
      data = task$data()
      invoke(nnet::nnet.formula, data = data, .args = pv)
    },

    .predict = function(task) {
      pv = self$param_set$get_values(tags = "predict")
      newdata = ordered_features(task, self)

      if (self$predict_type == "response") {
        response = invoke(predict, self$model, newdata = newdata, type = "class", .args = pv)
        return(list(response = response))
      } else {
        prob = invoke(predict, self$model, newdata = newdata, type = "raw", .args = pv)

        lvls = self$model$lev
        if (length(lvls) == 2L) {
          prob = pvec2mat(prob[, 1L], lvls)
        }
        return(list(prob = prob))
      }
    }
  )
)

#' @include aaa.R
learners[["classif.nnet"]] = LearnerClassifNnet
