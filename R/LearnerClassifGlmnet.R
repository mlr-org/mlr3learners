#' @title GLM with Elastic Net Regularization Classification Learner
#'
#' @name mlr_learners_classif.glmnet
#'
#' @description
#' Generalized linear models with elastic net regularization.
#' Calls [glmnet::cv.glmnet()] from package \CRANpkg{glmnet}.
#'
#' @templateVar id classif.glmnet
#' @template section_dictionary_learner
#'
#' @references
#' \cite{mlr3learners}{friedman_2010}
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerClassifGlmnet = R6Class("LearnerClassifGlmnet", inherit = LearnerClassif,
  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ParamSet$new(list(
        ParamDbl$new("alpha", default = 1, lower = 0, upper = 1, tags = "train"),
        ParamInt$new("nfolds", default = 10L, lower = 3L, tags = "train"),
        ParamFct$new("type.measure", levels = c("deviance", "class", "auc", "mse", "mae"), default = "deviance", tags = "train"),
        ParamDbl$new("s", lower = 0, special_vals = list("lambda.1se", "lambda.min"), default = "lambda.1se", tags = "predict"),
        ParamInt$new("nlambda", default = 100L, lower = 1L, tags = "train"),
        ParamDbl$new("lambda.min.ratio", lower = 0, upper = 1, tags = "train"),
        ParamUty$new("lambda", tags = "train"),
        ParamLgl$new("standardize", default = TRUE, tags = "train"),
        ParamLgl$new("intercept", default = TRUE, tags = "train"),
        ParamDbl$new("thresh", default = 1e-07, lower = 0, tags = "train"),
        ParamInt$new("dfmax", lower = 0L, tags = "train"),
        ParamInt$new("pmax", lower = 0L, tags = "train"),
        ParamInt$new("exclude", lower = 1L, tags = "train"),
        ParamDbl$new("penalty.factor", lower = 0, upper = 1, tags = "train"),
        ParamUty$new("lower.limits", tags = "train"),
        ParamUty$new("upper.limits", tags = "train"),
        ParamInt$new("maxit", default = 100000L, lower = 1L, tags = "train"),
        ParamFct$new("type.logistic", levels = c("Newton", "modified.Newton"), tags = "train"),
        ParamFct$new("type.multinomial", levels = c("ungrouped", "grouped"), tags = "train"),
        ParamUty$new("gamma", tags = "train"),
        ParamLgl$new("relax", default = FALSE, tags = "train"),
        ParamDbl$new("fdev", default = 1.0e-5, lower = 0, upper = 1, tags = "train"),
        ParamDbl$new("devmax", default = 0.999, lower = 0, upper = 1, tags = "train"),
        ParamDbl$new("eps", default = 1.0e-6, lower = 0, upper = 1, tags = "train"),
        ParamDbl$new("big", default = 9.9e35, tags = "train"),
        ParamInt$new("mnlam", default = 5, lower = 1L, tags = "train"),
        ParamDbl$new("pmin", default = 1.0e-9, lower = 0, upper = 1, tags = "train"),
        ParamDbl$new("exmx", default = 250.0, tags = "train"),
        ParamDbl$new("prec", default = 1e-10, tags = "train"),
        ParamInt$new("mxit", default = 100L, lower = 1L, tags = "train")
      ))
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
      on.exit(invoke(glmnet::glmnet.control, .args = saved_ctrl))
      glmnet::glmnet.control(factory = TRUE)
      is_ctrl_pars = names(pars) %in% names(saved_ctrl)

      if (any(is_ctrl_pars)) {
        do.call(glmnet::glmnet.control, pars[is_ctrl_pars])
        pars = pars[!is_ctrl_pars]
      }

      invoke(glmnet::cv.glmnet, x = data, y = target, .args = pars)
    },

    .predict = function(task) {
      pars = self$param_set$get_values(tags = "predict")
      newdata = as.matrix(task$data(cols = task$feature_names))

      if (self$predict_type == "response") {
        response = invoke(predict, self$model, newx = newdata, type = "class", .args = pars)
        PredictionClassif$new(task = task, response = drop(response))
      } else {
        prob = invoke(predict, self$model, newx = newdata, type = "response", .args = pars)

        if (length(task$class_names) == 2L) {
          prob = cbind(prob, 1 - prob)
          colnames(prob) = task$class_names
        } else {
          prob = prob[, , 1L]
        }
        PredictionClassif$new(task = task, prob = prob)
      }
    }
  )
)
