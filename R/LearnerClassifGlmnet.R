#' @title GLM with Elastic Net Regularization Classification Learner
#'
#' @name mlr_learners_classif.glmnet
#'
#' @description
#' Generalized linear models with elastic net regularization.
#' Calls [glmnet::glmnet()] from package \CRANpkg{glmnet}.
#'
#' Caution: This learner is different to `_glmnet` in that it does not use the
#' internal optimization of lambda. The parameter needs to be tuned by the user.
#' Essentially, one needs to tune parameter `s` which is used at predict-time.
#'
#' See \url{https://stackoverflow.com/questions/50995525/} for more information.
#'
#' @templateVar id classif.glmnet
#' @template section_dictionary_learner
#'
#' @references
#' `r format_bib("friedman_2010")`
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerClassifGlmnet = R6Class("LearnerClassifGlmnet",
  inherit = LearnerClassif,

  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ps(
        alpha = p_dbl(default = 1, lower = 0, upper = 1, tags = "train"),
        s = p_dbl(lower = 0, default = 0.01, tags = "predict"),
        lambda.min.ratio = p_dbl(lower = 0, upper = 1, tags = "train"),
        lambda = p_uty(tags = "train"),
        standardize = p_lgl(default = TRUE, tags = "train"),
        intercept = p_lgl(default = TRUE, tags = "train"),
        thresh = p_dbl(default = 1e-07, lower = 0, tags = "train"),
        dfmax = p_int(lower = 0L, tags = "train"),
        pmax = p_int(lower = 0L, tags = "train"),
        exclude = p_int(lower = 1L, tags = "train"),
        penalty.factor = p_uty(tags = "train"),
        lower.limits = p_uty(tags = "train"),
        upper.limits = p_uty(tags = "train"),
        maxit = p_int(default = 100000L, lower = 1L, tags = "train"),
        type.logistic = p_fct(levels = c("Newton", "modified.Newton"), tags = "train"),
        type.multinomial = p_fct(levels = c("ungrouped", "grouped"), tags = "train"),
        keep = p_lgl(default = FALSE, tags = "train"),
        parallel = p_lgl(default = FALSE, tags = "train"),
        trace.it = p_int(default = 0, lower = 0, upper = 1, tags = "train"),
        alignment = p_fct(default = "lambda", levels = c("lambda", "fraction"), tags = "train"),
        grouped = p_lgl(default = TRUE, tags = "train"),
        offset = p_uty(default = NULL, tags = "train"),
        relax = p_lgl(default = FALSE, tags = "train"),
        fdev = p_dbl(default = 1.0e-5, lower = 0, upper = 1, tags = "train"),
        devmax = p_dbl(default = 0.999, lower = 0, upper = 1, tags = "train"),
        eps = p_dbl(default = 1.0e-6, lower = 0, upper = 1, tags = "train"),
        epsnr = p_dbl(default = 1.0e-8, lower = 0, upper = 1, tags = "train"),
        big = p_dbl(default = 9.9e35, tags = "train"),
        mnlam = p_int(default = 5, lower = 1L, tags = "train"),
        pmin = p_dbl(default = 1.0e-9, lower = 0, upper = 1, tags = "train"),
        exmx = p_dbl(default = 250.0, tags = "train"),
        prec = p_dbl(default = 1e-10, tags = "train"),
        mxit = p_int(default = 100L, lower = 1L, tags = "train"),
        mxitnr = p_int(default = 25L, lower = 1L, tags = "train"),
        newoffset = p_uty(tags = "predict"),
        exact = p_lgl(default = FALSE, tags = "predict"),
        gamma = p_dbl(default = 1, tags = "predict")
      )
      ps$add_dep("gamma", "relax", CondEqual$new(TRUE))

      super$initialize(
        id = "classif.glmnet",
        param_set = ps,
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric"),
        properties = c("weights", "twoclass", "multiclass"),
        packages = "glmnet",
        man = "mlr3learners::mlr_learners_classif.glmnet"
      )
    }
  ),

  private = list(
    .train = function(task) {

      pars = self$param_set$get_values(tags = "train")
      data = as.matrix(task$data(cols = task$feature_names))
      target = as.matrix(task$data(cols = task$target_names))
      if ("weights" %in% task$properties) {
        pars$weights = task$weights$weight
      }
      pars$family = ifelse(length(task$class_names) == 2L, "binomial", "multinomial")

      saved_ctrl = glmnet::glmnet.control()
      on.exit(mlr3misc::invoke(glmnet::glmnet.control, .args = saved_ctrl))
      glmnet::glmnet.control(factory = TRUE)
      is_ctrl_pars = names(pars) %in% names(saved_ctrl)

      if (any(is_ctrl_pars)) {
        mlr3misc::invoke(glmnet::glmnet.control, .args = pars[is_ctrl_pars])
        pars = pars[!is_ctrl_pars]
      }

      mlr3misc::invoke(glmnet::glmnet, x = data, y = target, .args = pars)
    },

    .predict = function(task) {
      pars = self$param_set$get_values(tags = "predict")
      newdata = as.matrix(ordered_features(task, glmnet_feature_names(self$model)))

      # only predict for one instance of 's' and not for 100
      if (is.null(pars$s)) {
        pars$s = self$param_set$default$s
      }

      if (self$predict_type == "response") {
        response = mlr3misc::invoke(predict, self$model,
          newx = newdata, type = "class",
          .args = pars)
        list(response = drop(response))
      } else {
        prob = mlr3misc::invoke(predict, self$model,
          newx = newdata, type = "response",
          .args = pars)

        if (length(task$class_names) == 2L) {
          # glmnet returns probabilities for the **last** alphabetical class label
          prob = cbind(1 - prob, prob)
          colnames(prob) = sort(task$class_names)
        } else {
          prob = prob[, , 1L]
        }
        list(prob = prob)
      }
    }
  )
)
