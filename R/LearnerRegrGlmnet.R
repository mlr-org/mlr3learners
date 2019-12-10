#' @title GLM with Elastic Net Regularization Regression Learner
#'
#' @usage NULL
#' @aliases mlr_learners_regr.glmnet
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerRegr].
#'
#' @section Construction:
#' ```
#' LearnerRegrGlmnet$new()
#' mlr3::mlr_learners$get("regr.glmnet")
#' mlr3::lrn("regr.glmnet")
#' ```
#'
#' @description
#' Generalized linear models with elastic net regularization.
#' Calls [glmnet::cv.glmnet()] from package \CRANpkg{glmnet}.
#'
#' The default for hyperparameter `family` is changed to `"gaussian"`.
#'
#' @references
#' \cite{mlr3learners}{friedman_2010}
#'
#' @export
#' @template seealso_learner
#' @templateVar learner_name regr.glmnet
#' @template example
LearnerRegrGlmnet = R6Class("LearnerRegrGlmnet", inherit = LearnerRegr,
  public = list(
    initialize = function() {
      ps = ParamSet$new(list(
        ParamFct$new("family", default = "gaussian", levels = c("gaussian", "poisson"), tags = "train"),
        ParamUty$new("offset", default = NULL, tags = "train"),
        ParamDbl$new("alpha", default = 1, lower = 0, upper = 1, tags = "train"),
        ParamInt$new("nfolds", lower = 3L, default = 10L, tags = "train"),
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
        ParamFct$new("type.gaussian", levels = c("covariance", "naive"), tags = "train"),
        ParamFct$new("type.logistic", levels = c("Newton", "modified.Newton"), tags = "train"),
        ParamFct$new("type.multinomial", levels = c("ungrouped", "grouped"), tags = "train"),
        ParamUty$new("gamma", tags = "train"),
        ParamLgl$new("relax", default = FALSE, tags = "train"),
        ParamDbl$new("fdev", default = 1.0e-5, lower = 0, upper = 1, tags = "train"),
        ParamDbl$new("devmax", default = 0.999, lower = 0, upper = 1, tags = "train"),
        ParamDbl$new("eps", default = 1.0e-6, lower = 0, upper = 1, tags = "train"),
        ParamDbl$new("big", default = 9.9e35, tags = "train"),
        ParamInt$new("mnlam", default = 5L, lower = 1L, tags = "train"),
        ParamDbl$new("pmin", default = 1.0e-9, lower = 0, upper = 1, tags = "train"),
        ParamDbl$new("exmx", default = 250.0, tags = "train"),
        ParamDbl$new("prec", default = 1e-10, tags = "train"),
        ParamInt$new("mxit", default = 100L, lower = 1L, tags = "train")
      ))
      ps$add_dep("gamma", "relax", CondEqual$new(TRUE))
      ps$add_dep("type.gaussian", "family", CondEqual$new("gaussian"))

      ps$values = list(family = "gaussian")

      super$initialize(
        id = "regr.glmnet",
        param_set = ps,
        feature_types = c("integer", "numeric"),
        properties = c("weights", "importance"),
        packages = "glmnet",
        man = "mlr3learners::mlr_learners_regr.glmnet"
      )
    },

    train_internal = function(task) {

      pars = self$param_set$get_values(tags = "train")
      data = as.matrix(task$data(cols = task$feature_names))
      target = as.matrix(task$data(cols = task$target_names))
      if ("weights" %in% task$properties) {
        pars$weights = task$weights$weight
      }

      saved_ctrl = glmnet::glmnet.control()
      on.exit(invoke(glmnet::glmnet.control, .args = saved_ctrl))
      glmnet::glmnet.control(factory = TRUE)
      is_ctrl_pars = (names(pars) %in% names(saved_ctrl))

      if (any(is_ctrl_pars)) {
        do.call(glmnet::glmnet.control, pars[is_ctrl_pars])
        pars = pars[!is_ctrl_pars]
      }

      invoke(glmnet::cv.glmnet, x = data, y = target, .args = pars)
    },

    predict_internal = function(task) {
      pars = self$param_set$get_values(tags = "predict")
      newdata = as.matrix(task$data(cols = task$feature_names))

      response = invoke(predict, self$model, newx = newdata, type = "response", .args = pars)
      PredictionRegr$new(task = task, response = drop(response))
    },

    importance = function() {
      model = self$model$glmnet.fit

      res = sapply(seq_len(nrow(model$beta)), function(i) {
        ind = which(model$beta[i,] != 0)[1]
        model$lambda[ind]
      })

      names(res) = model$beta@Dimnames[[1]]
      sort(res, decreasing = TRUE)
    }
  )
)
