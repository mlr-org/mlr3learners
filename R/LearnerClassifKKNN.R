#' @title k-Nearest-Neighbor Classification Learner
#'
#' @name mlr_learners_classif.kknn
#'
#' @description
#' k-Nearest-Neighbor classification.
#' Calls [kknn::kknn()] from package \CRANpkg{kknn}.
#'
#' @template note_kknn
#'
#' @templateVar id classif.kknn
#' @template section_dictionary_learner
#'
#' @references
#' `r tools::toRd(bibentries[c("hechenbichler_2004", "samworth_2012", "cover_1967")])`
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerClassifKKNN = R6Class("LearnerClassifKKNN",
  inherit = LearnerClassif,
  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ParamSet$new(list(
        ParamInt$new("k", default = 7L, lower = 1L, tags = "train"),
        ParamDbl$new("distance", default = 2, lower = 0, tags = "train"),
        ParamFct$new("kernel",
          levels = c(
            "rectangular", "triangular", "epanechnikov",
            "biweight", "triweight", "cos", "inv", "gaussian", "rank", "optimal"),
          default = "optimal", tags = "train"),
        ParamLgl$new("scale", default = TRUE, tags = "train"),
        ParamUty$new("ykernel", default = NULL, tags = "train")
      ))

      super$initialize(
        id = "classif.kknn",
        param_set = ps,
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric", "factor", "ordered"),
        properties = c("twoclass", "multiclass"),
        packages = "kknn",
        man = "mlr3learners::mlr_learners_classif.kknn"
      )
    }
  ),

  private = list(
    .train = function(task) {
      list(
        formula = task$formula(),
        data = task$data(),
        pars = self$param_set$get_values(tags = "train"),
        kknn = NULL
      )
    },

    .predict = function(task) {
      model = self$state$model
      newdata = task$data(cols = task$feature_names)

      with_package("kknn", { # https://github.com/KlausVigo/kknn/issues/16
        p = invoke(kknn::kknn,
          formula = model$formula, train = model$data,
          test = newdata, .args = model$pars)
      })

      self$state$model$kknn = p

      if (self$predict_type == "response") {
        list(response = p$fitted.values)
      } else {
        list(prob = p$prob)
      }
    }
  )
)
