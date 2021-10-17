library(mlr3learners)

test_that("surv.cv_glmnet", {
  learner = lrn("surv.cv_glmnet")
  fun = list(glmnet::cv.glmnet, glmnet::glmnet.control, glmnet::glmnet)
  exclude = c(
    "x", # handled by mlr3
    "y", # handled by mlr3
    "weights", # handled by mlr3
    "itrace", # supported via param trace.it
    "factory", # only used in scripts, no effect within mlr3
    "family" # handled by mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "train")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or param defined in additional control function not included in list of function definitions:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})

test_that("predict surv.cv_glmnet", {
  learner = lrn("surv.cv_glmnet")
  fun = glmnet:::predict.cv.glmnet
  exclude = c(
    "object", # handled via mlr3
    "newx", # handled via mlr3
    "predict.gamma" # renamed from gamma
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "predict")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or param defined in additional control function not included in list of function definitions:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})
