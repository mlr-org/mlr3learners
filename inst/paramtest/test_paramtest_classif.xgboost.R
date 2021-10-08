library(mlr3learners)

test_that("classif.xgboost", {
  learner = lrn("classif.xgboost", nrounds = 1)
  fun = xgboost::xgb.train
  exclude = c(
    "x", # handled by mlr3
    "params", # handled by mlr3
    "data", # handled by mlr3
    "obj" # handled via type parameter
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "train")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or param defined in additional control function not included in list of function definitions:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})

test_that("predict classif.xgboost", {
  learner = lrn("classif.xgboost")
  fun = xgboost:::predict.xgb.Booster
  exclude = c(
    "object", # handled by mlr3
    "newdata" # handled by mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "predict")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or param defined in additional control function not included in list of function definitions:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})
