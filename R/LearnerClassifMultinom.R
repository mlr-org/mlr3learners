#' @title Multinomial log-linear learner via neural networks
#'
#' @name mlr_learners_classif.multinom
#'
#' @description
#' Multinomial log-linear models via neural networks.
#' Calls [nnet::multinom()] from package \CRANpkg{nnet}.
#'
#' @templateVar id classif.multinom
#' @template learner
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
        entropy  = p_lgl(default = FALSE, tags = "train"),
        mask     = p_uty(tags = "train"),
        maxit    = p_int(1L, default = 100L, tags = "train"),
        MaxNWts  = p_int(1L, default = 1000L, tags = "train"),
        model    = p_lgl(default = FALSE, tags = "train"),
        linout   = p_lgl(default = FALSE, tags = "train"),
        rang     = p_dbl(default = 0.7, tags = "train"),
        reltol   = p_dbl(default = 1.0e-8, tags = "train"),
        size     = p_int(1L, tags = "train"),
        skip     = p_lgl(default = FALSE, tags = "train"),
        softmax  = p_lgl(default = FALSE, tags = "train"),
        summ     = p_fct(c("0", "1", "2", "3"), default = "0", tags = "train"),
        trace    = p_lgl(default = TRUE, tags = "train"),
        Wts      = p_uty(tags = "train")
      )

      super$initialize(
        id = "classif.multinom",
        param_set = ps,
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric", "factor"),
        properties = c("weights", "twoclass", "multiclass", "loglik"),
        packages = c("mlr3learners", "nnet"),
        label = "Multinomial Log-Linear Model",
        man = "mlr3learners::mlr_learners_classif.multinom"
      )
    },

    #' @description
    #' Extract the log-likelihood (e.g., via [stats::logLik()] from the fitted model.
    loglik = function() {
      extract_loglik(self)
    }
  ),

  private = list(
    .train = function(task) {
      pv = self$param_set$get_values(tags = "train")

      if ("weights" %in% task$properties) {
        pv$weights = task$weights$weight
      }
      if (!is.null(pv$summ)) {
        pv$summ = as.integer(pv$summ)
      }

      # nnet does not handle formulas without env, we need to create it
      # here to work with `summary()`.
      pv$formula = reformulate(".", response = task$target_names)

      invoke(nnet::multinom, data = task$data(), .args = pv)
    },

    .predict = function(task) {
      pv = self$param_set$get_values(tags = "predict")
      newdata = ordered_features(task, self)

      if (self$predict_type == "response") {
        response = invoke(predict, self$model, newdata = newdata, type = "class", .args = pv)
        list(response = drop(response))
      } else {
        lvls = self$model$lev
        prob = unname(invoke(predict, self$model, newdata = newdata, type = "probs", .args = pv))

        # fix dimensions being dropped for n == 1 (https://github.com/mlr-org/mlr3/issues/883)
        if (task$nrow == 1L) {
          prob = matrix(prob, nrow = 1L)
        }

        if (length(lvls) == 2L) {
          prob = pvec2mat(prob, lvls)
        } else {
          colnames(prob) = lvls
        }

        list(prob = prob)
      }
    }
  )
)

#' @include aaa.R
learners[["classif.multinom"]] = LearnerClassifMultinom
