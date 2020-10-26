#' @title Linear Discriminant Analysis Classification Learner
#'
#' @name mlr_learners_classif.lda
#'
#' @description
#' Linear discriminant analysis.
#' Calls [MASS::lda()] from package \CRANpkg{MASS}.
#'
#' @details
#' Parameters `method` and `prior` exist for training and prediction but
#' accept different values for each. Therefore, arguments for
#' the predict stage have been renamed to `predict.method` and `predict.prior`,
#' respectively.
#'
#' @templateVar id classif.lda
#' @template section_dictionary_learner
#'
#' @references
#' `r tools::toRd(bibentries["venables_2002"])`
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerClassifLDA = R6Class("LearnerClassifLDA",
  inherit = LearnerClassif,

  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ParamSet$new(list(
        ParamUty$new("prior", tags = "train"),
        ParamDbl$new("tol", tags = "train"),
        ParamFct$new("method", default = "moment", levels = c(
          "moment", "mle", "mve", "t"), tags = "train"),
        ParamInt$new("nu", tags = "train"),
        ParamFct$new("predict.method",
          default = "plug-in",
          levels = c("plug-in", "predictive", "debiased"), tags = "predict"),
        ParamUty$new("predict.prior", tags = "predict"),
        ParamUty$new("dimen", tags = "predict")
      ))
      ps$add_dep("nu", "method", CondEqual$new("t"))

      super$initialize(
        id = "classif.lda",
        param_set = ps,
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric", "factor", "ordered"),
        properties = c("weights", "twoclass", "multiclass"),
        packages = "MASS",
        man = "mlr3learners::mlr_learners_classif.lda"
      )
    }
  ),

  private = list(
    .train = function(task) {
      formula = task$formula()
      mlr3misc::invoke(MASS::lda, formula,
        data = task$data(),
        .args = self$param_set$get_values(tags = "train"))
    },

    .predict = function(task) {
      pars = self$param_set$get_values(tags = "predict")
      if (!is.null(pars$predict.method)) {
        pars$method = pars$predict.method
        pars$predict.method = NULL
      }
      if (!is.null(pars$predict.prior)) {
        pars$prior = pars$predict.prior
        pars$predict.prior = NULL
      }
      newdata = task$data(cols = task$feature_names)
      p = mlr3misc::invoke(stats::predict, self$model,
        newdata = newdata,
        .args = self$param_set$get_values(tags = "predict"))

      if (self$predict_type == "response") {
        list(response = p$class)
      } else {
        list(response = p$class, prob = p$posterior)
      }
    }
  )
)
