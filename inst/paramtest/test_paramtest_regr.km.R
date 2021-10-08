library(mlr3learners)

test_that("regr.km", {
  learner = lrn("regr.km")
  fun = DiceKriging::km
  exclude = c(
    "formula", # handled via mlr3
    "design", # handled via mlr3
    "response" # handled via mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "train")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or param defined in additional control function not included in list of function definitions:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})

test_that("predict regr.km", {
  learner = lrn("regr.km")
  fun = DiceKriging::predict.km
  exclude = c(
    "object", # handled via mlr3
    "newdata" # handled via mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "predict")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or param defined in additional control function not included in list of function definitions:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})
