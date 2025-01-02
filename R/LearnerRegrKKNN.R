#' @title k-Nearest-Neighbor Regression Learner
#'
#' @name mlr_learners_regr.kknn
#'
#' @description
#' k-Nearest-Neighbor regression.
#' Calls [kknn::kknn()] from package \CRANpkg{kknn}.
#'
#' @section Initial parameter values:
#' - `store_model`:
#'   - See note.
#'
#' @template note_kknn
#'
#' @templateVar id regr.kknn
#' @template learner
#'
#' @references
#' `r format_bib("hechenbichler_2004", "samworth_2012", "cover_1967")`
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerRegrKKNN = R6Class("LearnerRegrKKNN",
  inherit = LearnerRegr,
  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ps(
        k           = p_int(default = 7L, lower = 1L, tags = "train"),
        distance    = p_dbl(0, default = 2, tags = "train"),
        kernel      = p_fct(c("rectangular", "triangular", "epanechnikov", "biweight", "triweight", "cos", "inv", "gaussian", "rank", "optimal"), default = "optimal", tags = "train"),
        scale       = p_lgl(default = TRUE, tags = "train"),
        ykernel     = p_uty(default = NULL, tags = "train"),
        store_model = p_lgl(default = FALSE, tags = "train")
      )

      ps$set_values(k = 7L)

      super$initialize(
        id = "regr.kknn",
        param_set = ps,
        feature_types = c("logical", "integer", "numeric", "factor", "ordered"),
        packages = c("mlr3learners", "kknn"),
        label = "k-Nearest-Neighbor",
        man = "mlr3learners::mlr_learners_regr.kknn"
      )
    }
  ),

  private = list(
    .train = function(task) {
      # https://github.com/mlr-org/mlr3learners/issues/191
      pv = self$param_set$get_values(tags = "train")
      if (pv$k >= task$nrow) {
        stopf("Parameter k = %i must be smaller than the number of observations n = %i",
          pv$k, task$nrow)
      }

      list(
        formula = task$formula(),
        data = task$data(),
        pv = pv,
        kknn = NULL
      )
    },

    .predict = function(task) {
      model = self$model
      newdata = ordered_features(task, self)
      pv = insert_named(model$pv, self$param_set$get_values(tags = "predict"))

      with_package("kknn", { # https://github.com/KlausVigo/kknn/issues/16
        p = invoke(kknn::kknn,
          formula = model$formula, train = model$data,
          test = newdata, .args = remove_named(pv, "store_model"))
      })

      if (isTRUE(pv$store_model)) {
        self$state$model$kknn = p
      }

      list(response = p$fitted.values)
    }
  )
)

#' @include aaa.R
learners[["regr.kknn"]] = LearnerRegrKKNN
