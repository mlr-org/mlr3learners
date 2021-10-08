library(mlr3learners)

test_that("surv.glmnet", {
  learner = mlr3learners::LearnerSurvGlmnet$new()
  fun = list(glmnet::glmnet, glmnet::glmnet.control)
  exclude = c(
    "x", # handled by mlr3
    "y", # handled by mlr3
    "weights", # handled by mlr3
    "nfolds", # not used by learner
    "foldid", # not used by learner
    "family", # only coxnet available
    "type.gaussian", # not used by learner
    "standardize.response", # for 'mgaussian' only
    "itrace", # supported via param trace.it
    "factory" # only used in scripts, no effect within mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "train")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or param defined in additional control function not included in list of function definitions:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})

test_that("predict surv.glmnet", {
  learner = mlr3learners::LearnerSurvGlmnet$new()
  fun = glmnet::predict.glmnet
  exclude = c(
    "object", # handled via mlr3
    "newx", # handled via mlr3
    "type" # handled via mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "predict")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or param defined in additional control function not included in list of function definitions:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})
