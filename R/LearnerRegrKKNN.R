#' @title k-Nearest-Neighbor Regression Learner
#'
#' @usage NULL
#' @aliases mlr_learners_regr.kknn
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerRegr].
#'
#' @section Construction:
#' ```
#' LearnerRegrKKNN$new()
#' mlr3::mlr_learners$get("regr.kknn")
#' mlr3::lrn("regr.kknn")
#' ```
#'
#' @description
#' k-Nearest-Neighbor regression.
#' Calls [kknn::kknn()] from package \CRANpkg{kknn}.
#'
#' @references
#' \cite{mlr3learners}{hechenbichler_2004}
#'
#' \cite{mlr3learners}{samworth_2012}
#'
#' \cite{mlr3learners}{cover_1967}
#'
#' @export
#' @template seealso_learner
#' @templateVar learner_name regr.kknn
#' @template example
LearnerRegrKKNN = R6Class("LearnerRegrKKNN", inherit = LearnerRegr,
  public = list(
    initialize = function() {
      ps = ParamSet$new(list(
        ParamInt$new("k", default = 7L, lower = 1L, tags = "train"),
        ParamDbl$new("distance", default = 2, lower = 0, tags = "train"),
        ParamFct$new("kernel", levels = c("rectangular", "triangular", "epanechnikov", "biweight", "triweight", "cos", "inv", "gaussian", "rank", "optimal"), default = "optimal", tags = "train"),
        ParamLgl$new("scale", default = TRUE, tags = "train")
      ))

      super$initialize(
        id = "regr.kknn",
        param_set = ps,
        feature_types = c("logical", "integer", "numeric", "factor", "ordered"),
        packages = c("withr", "kknn"),
        man = "mlr3learners::mlr_learners_regr.kknn"
      )
    },

    train_internal = function(task) {
      list(
        formula = task$formula(),
        data = task$data(),
        pars = self$param_set$get_values(tags = "train")
      )
    },

    predict_internal = function(task) {
      model = self$model
      newdata = task$data(cols = task$feature_names)

      withr::with_package("kknn", { # https://github.com/KlausVigo/kknn/issues/16
        p = invoke(kknn::kknn, formula = model$formula, train = model$data, test = newdata, .args = model$pars)
      })

      PredictionRegr$new(task = task, response = p$fitted.values)
    }
  )
)
