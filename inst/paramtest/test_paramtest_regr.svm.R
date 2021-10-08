library(mlr3learners)

test_that("regr.svm", {
  learner = lrn("regr.svm")
  fun = list(e1071:::svm.default)
  exclude = c(
    "x", # handled by mlr3
    "y", # handled by mlr3
    "probability", # handled by mlr3
    "subset", # handled by mlr3
    "na.action", # handled by mlr3
    "class.weights" # not defined in regr
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "train")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or param defined in additional control function not included in list of function definitions:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})

test_that("regr.svm", {
  learner = lrn("regr.svm")
  fun = e1071:::predict.svm
  exclude = c(
    "object", # handled by mlr3
    "newdata", # handled by mlr3
    "probability", # handled by mlr3
    "na.action", # handled by mlr3
    "decision.values" # classif only
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "predict")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or param defined in additional control function not included in list of function definitions:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})
