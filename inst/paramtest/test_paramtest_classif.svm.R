library(mlr3learners)

test_that("classif.svm", {
  learner = lrn("classif.svm")
  fun = list(e1071:::tune.control, e1071:::svm.default)
  exclude = c(
    "x" # handled by mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "train")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or actually defined in additional control function:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})

test_that("classif.svm", {
  learner = lrn("classif.svm")
  fun = e1071:::predict.svm
  exclude = c(
    "object", # handled by mlr3
    "newdata", # handled by mlr3
    "probability", # handled by mlr3
    "na.action" # handled by mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "predict")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or actually defined in additional control function:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})
