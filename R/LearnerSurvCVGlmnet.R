#' @title Cross-Validated  GLM with Elastic Net Regularization Survival Learner
#'
#' @name mlr_learners_surv.cv_glmnet
#'
#' @description
#' Generalized linear models with elastic net regularization.
#' Calls [glmnet::cv.glmnet()] from package \CRANpkg{glmnet}.
#'
#' The default for hyperparameter `family` is changed to `"cox"`.
#'
#' @templateVar id surv.cv_glmnet
#' @template section_dictionary_learner
#'
#' @references
#' \cite{mlr3learners}{friedman_2010}
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerSurvCVGlmnet = R6Class("LearnerSurvCVGlmnet",
  inherit = mlr3proba::LearnerSurv,

  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ParamSet$new(
        list(
          ParamUty$new("offset", default = NULL, tags = "train"),
          ParamDbl$new("alpha", default = 1, lower = 0, upper = 1, tags = "train"),
          ParamInt$new("nfolds", lower = 3L, default = 10L, tags = "train"),
          ParamUty$new("foldid", default = NULL, tags = "train"),
          ParamFct$new("alignment",
            default = "lambda",
            levels = c("lambda", "fraction"), tags = "train"),
          ParamLgl$new("grouped", default = TRUE, tags = "train"),
          ParamInt$new("nlambda", default = 100L, lower = 1L, tags = "train"),
          ParamDbl$new("lambda.min.ratio", lower = 0, upper = 1, tags = "train"),
          ParamUty$new("lambda", tags = "train"),
          ParamFct$new("type.measure",
            default = "deviance",
            levels = c("deviance", "C"), tags = "train"),
          ParamLgl$new("keep", default = FALSE, tags = "train"),
          ParamLgl$new("parallel", default = FALSE, tags = "train"),
          ParamInt$new("trace.it", default = 0, lower = 0, upper = 1, tags = "train"),
          ParamUty$new("gamma", tags = "train"),
          ParamLgl$new("relax", default = FALSE, tags = "train"),
          ParamLgl$new("standardize", default = TRUE, tags = "train"),
          ParamLgl$new("intercept", default = TRUE, tags = "train"),
          ParamDbl$new("thresh", default = 1e-07, lower = 0, tags = "train"),
          ParamInt$new("dfmax", lower = 0L, tags = "train"),
          ParamDbl$new("epsnr", default = 1.0e-8, lower = 0, upper = 1, tags = "train"),
          ParamInt$new("pmax", lower = 0L, tags = "train"),
          ParamUty$new("exclude", tags = "train"),
          ParamUty$new("penalty.factor", tags = "train"),
          ParamUty$new("lower.limits", default = -Inf, tags = "train"),
          ParamUty$new("upper.limits", default = Inf, tags = "train"),
          ParamInt$new("maxit", default = 100000L, lower = 1L, tags = "train"),
          ParamInt$new("mxitnr", default = 25L, lower = 1L, tags = "train"),
          ParamFct$new("type.logistic",
            default = "Newton",
            levels = c("Newton", "modified.Newton"), tags = "train"),
          ParamFct$new("type.multinomial",
            default = "ungrouped",
            levels = c("ungrouped", "grouped"), tags = "train"),
          ParamDbl$new("fdev", default = 1.0e-5, lower = 0, upper = 1, tags = "train"),
          ParamDbl$new("devmax", default = 0.999, lower = 0, upper = 1, tags = "train"),
          ParamDbl$new("eps", default = 1.0e-6, lower = 0, upper = 1, tags = "train"),
          ParamDbl$new("big", default = 9.9e35, tags = "train"),
          ParamInt$new("mnlam", default = 5L, lower = 1L, tags = "train"),
          ParamDbl$new("pmin", default = 1.0e-9, lower = 0, upper = 1, tags = "train"),
          ParamDbl$new("exmx", default = 250.0, tags = "train"),
          ParamDbl$new("prec", default = 1e-10, tags = "train"),
          ParamInt$new("mxit", default = 100L, lower = 1L, tags = "train"),
          ParamDbl$new("s",
            lower = 0, upper = 1, special_vals = list("lambda.1se", "lambda.min"),
            default = "lambda.1se", tags = "predict")
        )
      )

      super$initialize(
        id = "surv.cv_glmnet",
        param_set = ps,
        feature_types = c("logical", "integer", "numeric"),
        predict_types = c("crank", "lp"),
        properties = "weights",
        packages = "glmnet",
        man = "mlr3learners::mlr_learners_surv.cv_glmnet"
      )
    }
  ),

  private = list(
    .train = function(task) {

      pars = self$param_set$get_values(tags = "train")
      data = as.matrix(task$data(cols = task$feature_names))
      target = task$truth()

      if ("weights" %in% task$properties) {
        pars$weights = task$weights$weight
      }

      saved_ctrl = glmnet::glmnet.control()
      on.exit(mlr3misc::invoke(glmnet::glmnet.control, .args = saved_ctrl))
      glmnet::glmnet.control(factory = TRUE)
      is_ctrl_pars = (names(pars) %in% names(saved_ctrl))

      if (any(is_ctrl_pars)) {
        mlr3misc::invoke(glmnet::glmnet.control, .args = pars[is_ctrl_pars])
        pars = pars[!is_ctrl_pars]
      }

      mlr3misc::invoke(glmnet::cv.glmnet, x = data, y = target, family = "cox", .args = pars)
    },

    .predict = function(task) {
      pars = self$param_set$get_values(tags = "predict")
      newdata = as.matrix(task$data(cols = task$feature_names))

      if (!is.null(pars$predict.gamma)) {
        pars$gamma = pars$predict.gamma
        pars$predict.gamma = NULL
      }

      lp = as.numeric(invoke(stats::predict, self$model, newx = newdata, type = "link", .args = pars))
      list(lp = lp, crank = lp)
    }
  )
)
