#' @title Classification Logistic Regression Learner
#' @name mlr_learners_classif_logreg
#' @format [R6::R6Class()] inheriting from [LearnerClassif].
#' @description
#' A learner for a classification logistic regression implemented in [stats::glm()].
#' @export
LearnerClassifLogReg = R6Class("LearnerClassifLogReg", inherit = LearnerClassif,
  public = list(
    initialize = function(id = "classif.logreg") {
      super$initialize(
        id = id,
        packages = "stats",
        feature_types = c("logical", "integer", "numeric", "character", "factor", "ordered"),
        predict_types = c("response", "prob"),
        param_set = ParamSet$new(
          params = list()
        ),
        properties = c("weights", "twoclass", "missings")
      )
    },

    train = function(task) {
      self$model = invoke(stats::glm, 
        formula = task$formula,
        data = task$data(),
        family = "binomial"
      ) # FIXME: weights = task$weights
      self
    },

    predict = function(task) {
      newdata = task$data(cols = task$feature_names)
      response = prob = NULL

      pred = predict(self$model, newdata = newdata, type = "response")
      levs = task$class_names

      if (self$predict_type == "prob") {
        prob = propVectorToMatrix(pred, levs) # FIXME
      } else {
        p = as.factor(ifelse(pred > 0.5, levs[1L], levs[2L]))
        response = unname(p)
      }

      PredictionClassif$new(task, response, prob)
    }
  )
)


# makeRLearner.classif.logreg = function() {
#   makeRLearnerClassif(
#     cl = "classif.logreg",
#     package = "stats",
#     par.set = makeParamSet(
#       makeLogicalLearnerParam("model", default = TRUE, tunable = FALSE)
#     ),
#     par.vals = list(
#       model = FALSE
#     ),
#     properties = c("twoclass", "numerics", "factors", "prob", "weights"),
#     name = "Logistic Regression",
#     short.name = "logreg",
#     note = "Delegates to `glm` with `family = binomial(link = 'logit')`. We set 'model' to FALSE by default to save memory.",
#     callees = "glm"
#   )
# }

# #' @export
# trainLearner.classif.logreg = function(.learner, .task, .subset, .weights = NULL,  ...) {
#   f = getTaskFormula(.task)
#   stats::glm(f, data = getTaskData(.task, .subset), family = "binomial", weights = .weights, ...)
# }

# #' @export
# predictLearner.classif.logreg = function(.learner, .model, .newdata, ...) {
#   x = predict(.model$learner.model, newdata = .newdata, type = "response", ...)
#   levs = .model$task.desc$class.levels
#   if (.learner$predict.type == "prob") {
#     propVectorToMatrix(x, levs)
#   } else {
#     levs = .model$task.desc$class.levels
#     p = as.factor(ifelse(x > 0.5, levs[2L], levs[1L]))
#     unname(p)
#   }
# }