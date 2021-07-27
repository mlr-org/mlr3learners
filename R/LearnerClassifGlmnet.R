#' @title GLM with Elastic Net Regularization Classification Learner
#'
#' @name mlr_learners_classif.glmnet
#'
#' @description
#' Generalized linear models with elastic net regularization.
#' Calls [glmnet::glmnet()] from package \CRANpkg{glmnet}.
#'
#' @details
#' Caution: This learner is different to learners calling [glmnet::cv.glmnet()]
#' in that it does not use the internal optimization of parameter `lambda`.
#' Instead, `lambda` needs to be tuned by the user (e.g., via \CRANpkg{mlr3tuning}).
#' When `lambda` is tuned, the `glmnet` will be trained for each tuning iteration.
#' While fitting the whole path of `lambda`s would be more efficient, as is done
#' by default in [glmnet::glmnet()], tuning/selecting the parameter at prediction time
#' (using parameter `s`) is currently not supported in \CRANpkg{mlr3}
#' (at least not in efficient manner).
#' Tuning the `s` parameter is, therefore, currently discouraged.
#'
#' When the data are i.i.d. and efficiency is key, we recommend using the respective
#' auto-tuning counterparts in [mlr_learners_classif_cv.glmnet()],
#' [mlr_learners_classif_regr.glmnet()], or [mlr_learners_surv_cv.glmnet()].
#' However, in some situations this is not applicable, usually when data are
#' imbalanced or not i.i.d. (longitudinal, time-series) and tuning requires
#' custom resampling strategies (blocked design, stratification).
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
        alignment        = p_fct(c("lambda", "fraction"), default = "lambda", tags = "train"),
        alpha            = p_dbl(0, 1, default = 1, tags = "train"),
        big              = p_dbl(default = 9.9e35, tags = "train"),
        devmax           = p_dbl(0, 1, default = 0.999, tags = "train"),
        dfmax            = p_int(0L, tags = "train"),
        eps              = p_dbl(0, 1, default = 1.0e-6, tags = "train"),
        epsnr            = p_dbl(0, 1, default = 1.0e-8, tags = "train"),
        exact            = p_lgl(default = FALSE, tags = "predict"),
        exclude          = p_int(1L, tags = "train"),
        exmx             = p_dbl(default = 250.0, tags = "train"),
        fdev             = p_dbl(0, 1, default = 1.0e-5, tags = "train"),
        gamma            = p_dbl(default = 1, tags = "predict"),
        grouped          = p_lgl(default = TRUE, tags = "train"),
        intercept        = p_lgl(default = TRUE, tags = "train"),
        keep             = p_lgl(default = FALSE, tags = "train"),
        lambda           = p_uty(tags = "train"),
        lambda.min.ratio = p_dbl(0, 1, tags = "train"),
        lower.limits     = p_uty(tags = "train"),
        maxit            = p_int(1L, default = 100000L, tags = "train"),
        mnlam            = p_int(1L, default = 5, tags = "train"),
        mxit             = p_int(1L, default = 100L, tags = "train"),
        mxitnr           = p_int(1L, default = 25L, tags = "train"),
        newoffset        = p_uty(tags = "predict"),
        offset           = p_uty(default = NULL, tags = "train"),
        parallel         = p_lgl(default = FALSE, tags = "train"),
        penalty.factor   = p_uty(tags = "train"),
        pmax             = p_int(0L, tags = "train"),
        pmin             = p_dbl(0, 1, default = 1.0e-9, tags = "train"),
        prec             = p_dbl(default = 1e-10, tags = "train"),
        relax            = p_lgl(default = FALSE, tags = "train"),
        s                = p_dbl(0, default = 0.01, tags = "predict"),
        standardize      = p_lgl(default = TRUE, tags = "train"),
        thresh           = p_dbl(0, default = 1e-07, tags = "train"),
        trace.it         = p_int(0, 1, default = 0, tags = "train"),
        type.logistic    = p_fct(c("Newton", "modified.Newton"), tags = "train"),
        type.multinomial = p_fct(c("ungrouped", "grouped"), tags = "train"),
        upper.limits     = p_uty(tags = "train")
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

      # if model was fit with more then one lambda,
      # set to default such that only one prediction is returned
      if (is.null(pars$s) & length(self$model$lambda) > 1L) {
        warning("Multiple lambdas have been fit. For prediction, lambda will be set to 0.01 (see parameter 's').")
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
