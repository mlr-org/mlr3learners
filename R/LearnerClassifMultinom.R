#' @title Multinomial log-linear learner via neural networks
#'
#' @name mlr_learners_classif.multinom
#'
#' @description
#' Multinomial log-linear models via neural networks.
#' Calls [nnet::multinom()] from package \CRANpkg{nnet}.
#'
#' @templateVar id classif.multinom
#' @template section_dictionary_learner
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerClassifMultinom = R6Class("LearnerClassifMultinom",
  inherit = LearnerClassif,

  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ps(
        Hess     = p_lgl(default = FALSE, tags = "train"),
        abstol   = p_dbl(default = 1.0e-4, tags = "train"),
        censored = p_lgl(default = FALSE, tags = "train"),
        decay    = p_dbl(default = 0, tags = "train"),
        maxit    = p_int(1L, default = 100L, tags = "train"),
        model    = p_lgl(default = FALSE, tags = "train"),
        rang     = p_dbl(default = 0.7, tags = "train"),
        reltol   = p_dbl(default = 1.0e-8, tags = "train"),
        summ     = p_fct(c("0", "1", "2", "3"), default = "0", tags = "train"),
        trace    = p_lgl(default = TRUE, tags = "train")
      )

      super$initialize(
        id = "classif.multinom",
        param_set = ps,
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric", "factor"),
        properties = c("weights", "twoclass", "multiclass"),
        packages = "nnet",
        man = "mlr3learners::mlr_learners_classif.multinom"
      )
    }
  ),

  private = list(
    .train = function(task) {
      pars = self$param_set$get_values(tags = "train")
      data = task$data()

      if ("weights" %in% task$properties) {
        pars$weights = task$weights$weight
      }
      if (!is.null(pars$summ)) {
        pars$summ = as.integer(pars$summ)
      }

      invoke(nnet::multinom, data = data, .args = pars)
    },

    .predict = function(task) {
      newdata = task$data(cols = task$feature_names)
      levs = task$class_names

      if (self$predict_type == "response") {
        response = invoke(predict, self$model, newdata = newdata, type = "class")
        list(response = drop(response))
      } else {
        prob = invoke(predict, self$model, newdata = newdata, type = "probs")
        if (length(levs) == 2L) {
          prob = matrix(c(1 - prob, prob), ncol = 2L, byrow = FALSE)
          colnames(prob) = levs
        }
        list(prob = prob)
      }
    }
  )
)
