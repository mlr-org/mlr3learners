#' @title Classification GLM with Lasso or Elasticnet Regularization Learner
#' @name mlr_learners_classif_glmnet
#' @format [R6::R6Class()] inheriting from [LearnerClassif].
#' @description
#' A learner for a classification logistic regression implemented in [glmnet::glmnet()].
#' @export
LearnerClassifGlmnet = R6Class("LearnerClassifGlmnet", inherit = LearnerClassif,
  public = list(
    initialize = function(id = "classif.glmnet") {
      super$initialize(
        id = id,
        packages = "glmnet",
        feature_types = c("integer", "numeric"),
        predict_types = c("response", "prob"),
        param_set = ParamSet$new(
          params = list(
            ParamDbl$new(id = "alpha", default = 1, lower = 0, upper = 1, tags = "train"),
            ParamDbl$new(id = "s", lower = 0, tags = "predict"),
            ParamLgl$new(id = "exact", default = FALSE, tags = "predict"),
            ParamInt$new(id = "nlambda", default = 100L, lower = 1L, tags = "train"),
            ParamDbl$new(id = "lambda.min.ratio", lower = 0, upper = 1, tags = "train"),
            ParamDbl$new(id = "lambda", lower = 0, tags = "train"),
            ParamLgl$new(id = "standardize", default = TRUE, tags = "train"),
            ParamLgl$new(id = "intercept", default = TRUE, tags = "train"),
            ParamDbl$new(id = "thresh", default = 1e-07, lower = 0, tags = "train"),
            ParamInt$new(id = "dfmax", lower = 0L, tags = "train"),
            ParamInt$new(id = "pmax", lower = 0L, tags = "train"),
            ParamInt$new(id = "exclude", lower = 1L, tags = "train"),
            ParamDbl$new(id = "penalty.factor", lower = 0, upper = 1, tags = "train"),
            ParamDbl$new(id = "lower.limits", upper = 0, tags = "train"),
            ParamDbl$new(id = "upper.limits", lower = 0, tags = "train"),
            ParamInt$new(id = "maxit", default = 100000L, lower = 1L, tags = "train"),
            ParamFct$new(id = "type.logistic", values = c("Newton", "modified.Newton"), tags = "train"),
            ParamFct$new(id = "type.multinomial", values = c("ungrouped", "grouped"), tags = "train"),
            ParamDbl$new(id = "fdev", default = 1.0e-5, lower = 0, upper = 1, tags = "train"),
            ParamDbl$new(id = "devmax", default = 0.999, lower = 0, upper = 1, tags = "train"),
            ParamDbl$new(id = "eps", default = 1.0e-6, lower = 0, upper = 1, tags = "train"),
            ParamDbl$new(id = "big", default = 9.9e35, tags = "train"),
            ParamInt$new(id = "mnlam", default = 5, lower = 1, tags = "train"),
            ParamDbl$new(id = "pmin", default = 1.0e-9, lower = 0, upper = 1, tags = "train"),
            ParamDbl$new(id = "exmx", default = 250.0, tags = "train"),
            ParamDbl$new(id = "prec", default = 1e-10, tags = "train"),
            ParamInt$new(id = "mxit", default = 100L, lower = 1, tags = "train")
          )
        ),
        param_vals = list(s = 0.01),
        properties = c("weights", "twoclass", "multiclass")
      )
    },

    train = function(task) {
      pars = self$params_train
      data = as.matrix(task$data(cols = task$feature_names))
      target = as.matrix(task$data(cols = task$target_names))
      # if (!is.null(task$weights))
        # pars$weights = task$weights # FIXME: weights are not implemented in the task yet
      pars$family = ifelse(length(task$class_names) == 2L, "binomial", "multinomial")
      
      glmnet::glmnet.control(factory = TRUE)
      saved_ctrl = glmnet::glmnet.control()
      is_ctrl_pars = names(pars) %in% names(saved_ctrl)

      if (any(is_ctrl_pars)) {
        on.exit(glmnet::glmnet.control(factory = TRUE))
        do.call(glmnet::glmnet.control, pars[is_ctrl_pars])
        pars = pars[!is_ctrl_pars]
      }

      self$model = invoke(glmnet::glmnet,
        x = data,
        y = target,
        .args = pars
      )
      self
    },

    predict = function(task) {
      pars = self$params_predict
      newdata = as.matrix(task$data(cols = task$feature_names))
      response = prob = NULL

      if (self$predict_type == "prob") {
        prob = invoke(predict,
          self$model,
          newx = newdata,
          type = "response",
          .args = pars
        )

        if (length(task$class_names) == 2L) {
          prob = set_names(cbind(1 - prob, prob), task$class_names)
        } else {
          prob = prob[, , 1]
        }
      } else {
        response = drop(invoke(predict,
          self$model,
          newx = newdata,
          type = "class",
          .args = pars)
        )
        response = as.factor(response)
      }

      PredictionClassif$new(task, response, prob)
    }
  )
)

