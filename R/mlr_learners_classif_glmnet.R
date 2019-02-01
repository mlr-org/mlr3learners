#' @title Classification GLM with Elastic net Regularization
#' @name mlr_learners_classif_glmnet
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerClassif].
#' @description
#' A learner for a classification GLM with elastic net regularization implemented in [glmnet::glmnet()].
#' @export
LearnerClassifGlmnet = R6Class("LearnerClassifGlmnet", inherit = LearnerClassif,
  public = list(
    initialize = function() {
      super$initialize(
        id = "classif.glmnet",
        packages = "glmnet",
        feature_types = c("integer", "numeric"),
        predict_types = c("response", "prob"),
        param_set = ParamSet$new(
          params = list(
            ParamDbl$new(id = "alpha", default = 1, lower = 0, upper = 1, tags = "train"),
            ParamInt$new(id = "nfolds", default = 10L, lower = 3L),
            ParamUty$new(id = "foldid"),
            ParamFct$new(id = "type.measure", values = c("deviance", "class", "auc", "mse", "mae"), default = "deviance", tags = "train"),
            ParamLgl$new(id = "grouped", default = TRUE),
            ParamLgl$new(id = "keep", default = FALSE),
            ParamUty$new(id = "s", default = "lambda.1se", tags = "predict"),
            ParamInt$new(id = "nlambda", default = 100L, lower = 1L, tags = "train"),
            ParamDbl$new(id = "lambda.min.ratio", lower = 0, upper = 1, tags = "train"),
            ParamUty$new(id = "lambda", tags = "train"),
            ParamLgl$new(id = "standardize", default = TRUE, tags = "train"),
            ParamLgl$new(id = "intercept", default = TRUE, tags = "train"),
            ParamDbl$new(id = "thresh", default = 1e-07, lower = 0, tags = "train"),
            ParamInt$new(id = "dfmax", lower = 0L, tags = "train"),
            ParamInt$new(id = "pmax", lower = 0L, tags = "train"),
            ParamInt$new(id = "exclude", lower = 1L, tags = "train"),
            ParamDbl$new(id = "penalty.factor", lower = 0, upper = 1, tags = "train"),
            ParamUty$new(id = "lower.limits", tags = "train"),
            ParamUty$new(id = "upper.limits", tags = "train"),
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
        param_vals = list(),
        properties = c("weights", "twoclass", "multiclass")
      )
    },

    train = function(task) {
      pars = self$params("train")
      data = as.matrix(task$data(cols = task$feature_names))
      target = as.matrix(task$data(cols = task$target_names))
      if (!is.null(task$weights))
         pars$weights = task$weights # FIXME: weights are not implemented in the task yet
      pars$family = ifelse(length(task$class_names) == 2L, "binomial", "multinomial")

      glmnet::glmnet.control(factory = TRUE)
      saved_ctrl = glmnet::glmnet.control()
      is_ctrl_pars = names(pars) %in% names(saved_ctrl)

      if (any(is_ctrl_pars)) {
        on.exit(glmnet::glmnet.control(factory = TRUE))
        do.call(glmnet::glmnet.control, pars[is_ctrl_pars])
        pars = pars[!is_ctrl_pars]
      }

      self$model = invoke(glmnet::cv.glmnet,
        x = data,
        y = target,
        .args = pars
      )
      self
    },

    predict = function(task) {
      pars = self$params("predict")
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
          prob = cbind(prob, 1 - prob)
          colnames(prob) = task$class_names
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
        levels = task$levels(col = task$target_names)
        response = factor(response, levels = levels)
      }

      PredictionClassif$new(task, response, prob)
    }
  )
)

