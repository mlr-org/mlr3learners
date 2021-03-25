#' @title GLM with Elastic Net Regularization Classification Learner
#'
#' @name mlr_learners_classif.cv_glmnet
#'
#' @description
#' Generalized linear models with elastic net regularization.
#' Calls [glmnet::cv.glmnet()] from package \CRANpkg{glmnet}.
#'
#' The default for hyperparameter `family` is set to `"binomial"` or `"multinomial"`,
#' depending on the number of classes.
#'
#' @templateVar id classif.cv_glmnet
#' @template section_dictionary_learner
#'
#' @references
#' `r format_bib("friedman_2010")`
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerClassifCVGlmnet = R6Class("LearnerClassifCVGlmnet",
  inherit = LearnerClassif,

  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ps(
        alignment        = p_fct(c("lambda", "fraction"), default = "lambda", tags = "train"),
        alpha            = p_dbl(0, 1, default = 1, tags = "train"),
        big              = p_dbl(tags = "train", default = 9.9e35),
        devmax           = p_dbl(0, 1, default = 0.999, tags = "train"),
        dfmax            = p_int(0L, tags = "train"),
        epsnr            = p_dbl(0, 1, default = 1.0e-8, tags = "train"),
        eps              = p_dbl(0, 1, default = 1.0e-6, tags = "train"),
        exclude          = p_int(1L, tags = "train"),
        exmx             = p_dbl(default = 250.0, tags = "train"),
        fdev             = p_dbl(0, 1, default = 1.0e-5, tags = "train"),
        foldid           = p_uty(default = NULL, tags = "train"),
        gamma            = p_uty(tags = "train"),
        grouped          = p_lgl(default = TRUE, tags = "train"),
        intercept        = p_lgl(default = TRUE, tags = "train"),
        keep             = p_lgl(default = FALSE, tags = "train"),
        lambda.min.ratio = p_dbl(0, 1, tags = "train"),
        lambda           = p_uty(tags = "train"),
        lower.limits     = p_uty(tags = "train"),
        maxit            = p_int(1L, default = 100000L, tags = "train"),
        mnlam            = p_int(1L, default = 5, tags = "train"),
        mxitnr           = p_int(1L, default = 25L, tags = "train"),
        mxit             = p_int(1L, default = 100L, tags = "train"),
        newoffset        = p_uty(tags = "predict"),
        nfolds           = p_int(3L, default = 10L, tags = "train"),
        offset           = p_uty(default = NULL, tags = "train"),
        parallel         = p_lgl(default = FALSE, tags = "train"),
        penalty.factor   = p_uty(tags = "train"),
        pmax             = p_int(0L, tags = "train"),
        pmin             = p_dbl(0, 1, default = 1.0e-9, tags = "train"),
        prec             = p_dbl(default = 1e-10, tags = "train"),
        predict.gamma    = p_dbl(default = 1, tags = "predict"),
        relax            = p_lgl(default = FALSE, tags = "train"),
        s                = p_dbl(0, special_vals = list("lambda.1se", "lambda.min"), default = "lambda.1se", tags = "predict"),
        standardize      = p_lgl(default = TRUE, tags = "train"),
        thresh           = p_dbl(0, default = 1e-07, tags = "train"),
        trace.it         = p_int(0, 1, default = 0, tags = "train"),
        type.logistic    = p_fct(c("Newton", "modified.Newton"), tags = "train"),
        type.measure     = p_fct(c("deviance", "class", "auc", "mse", "mae"), default = "deviance", tags = "train"),
        type.multinomial = p_fct(c("ungrouped", "grouped"), tags = "train"),
        upper.limits     = p_uty(tags = "train")
      )
      ps$add_dep("gamma", "relax", CondEqual$new(TRUE))

      super$initialize(
        id = "classif.cv_glmnet",
        param_set = ps,
        predict_types = c("response", "prob"),
        feature_types = c("logical", "integer", "numeric"),
        properties = c("weights", "twoclass", "multiclass"),
        packages = "glmnet",
        man = "mlr3learners::mlr_learners_classif.cv_glmnet"
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

      mlr3misc::invoke(glmnet::cv.glmnet, x = data, y = target, .args = pars)
    },

    .predict = function(task) {
      pars = self$param_set$get_values(tags = "predict")
      newdata = as.matrix(ordered_features(task, glmnet_feature_names(self$model)))

      if (!is.null(pars$predict.gamma)) {
        pars$gamma = pars$predict.gamma
        pars$predict.gamma = NULL
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
