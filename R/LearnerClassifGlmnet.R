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
      ps = ParamSet$new(list(
        ParamDbl$new("alpha", default = 1, lower = 0, upper = 1, tags = "train"),
        ParamFct$new("type.measure",
          levels = c("deviance", "class", "auc", "mse", "mae"),
          default = "deviance", tags = "train"),
        ParamDbl$new("s", lower = 0, default = 0.01, tags = "predict"),
        ParamDbl$new("lambda.min.ratio", lower = 0, upper = 1, tags = "train"),
        ParamUty$new("lambda", tags = "train"),
        ParamLgl$new("standardize", default = TRUE, tags = "train"),
        ParamLgl$new("intercept", default = TRUE, tags = "train"),
        ParamDbl$new("thresh", default = 1e-07, lower = 0, tags = "train"),
        ParamInt$new("dfmax", lower = 0L, tags = "train"),
        ParamInt$new("pmax", lower = 0L, tags = "train"),
        ParamInt$new("exclude", lower = 1L, tags = "train"),
        ParamUty$new("penalty.factor", tags = "train"),
        ParamUty$new("lower.limits", tags = "train"),
        ParamUty$new("upper.limits", tags = "train"),
        ParamInt$new("maxit", default = 100000L, lower = 1L, tags = "train"),
        ParamFct$new("type.logistic",
          levels = c("Newton", "modified.Newton"),
          tags = "train"),
        ParamFct$new("type.multinomial",
          levels = c("ungrouped", "grouped"),
          tags = "train"),
        ParamLgl$new("keep", default = FALSE, tags = "train"),
        ParamLgl$new("parallel", default = FALSE, tags = "train"),
        ParamInt$new("trace.it", default = 0, lower = 0, upper = 1, tags = "train"),
        ParamFct$new("alignment",
          default = "lambda",
          levels = c("lambda", "fraction"), tags = "train"),
        ParamLgl$new("grouped", default = TRUE, tags = "train"),
        ParamUty$new("offset", default = NULL, tags = "train"),
        ParamLgl$new("relax", default = FALSE, tags = "train"),
        ParamDbl$new("fdev", default = 1.0e-5, lower = 0, upper = 1, tags = "train"),
        ParamDbl$new("devmax", default = 0.999, lower = 0, upper = 1, tags = "train"),
        ParamDbl$new("eps", default = 1.0e-6, lower = 0, upper = 1, tags = "train"),
        ParamDbl$new("epsnr", default = 1.0e-8, lower = 0, upper = 1, tags = "train"),
        ParamDbl$new("big", default = 9.9e35, tags = "train"),
        ParamInt$new("mnlam", default = 5, lower = 1L, tags = "train"),
        ParamDbl$new("pmin", default = 1.0e-9, lower = 0, upper = 1, tags = "train"),
        ParamDbl$new("exmx", default = 250.0, tags = "train"),
        ParamDbl$new("prec", default = 1e-10, tags = "train"),
        ParamInt$new("mxit", default = 100L, lower = 1L, tags = "train"),
        ParamInt$new("mxitnr", default = 25L, lower = 1L, tags = "train"),
        ParamUty$new("newoffset", tags = "predict"),
        ParamLgl$new("exact", default = FALSE, tags = "predict"),
        ParamDbl$new("gamma", default = 1, tags = "predict")
      ))
      ps$add_dep("gamma", "relax", CondEqual$new(TRUE))

      super$initialize(
        id = "classif.glmnet",
        param_set = ps,
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric"),
        properties = c("weights", "twoclass", "multiclass"),
        packages = "glmnet",
        data_formats = c("Matrix", "data.table"),
        man = "mlr3learners::mlr_learners_classif.glmnet"
      )
    }
  ),

  private = list(
    .train = function(task) {
      data_format = intersect(self$data_formats, task$data_formats)[1L]
      data = task$data(cols = task$feature_names, data_format = data_format)
      target = as.matrix(task$data(cols = task$target_names))
      pars = self$param_set$get_values(tags = "train")
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
