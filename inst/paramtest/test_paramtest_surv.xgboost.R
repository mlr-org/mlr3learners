library(mlr3learners)

test_that("surv.xgboost", {
  learner = lrn("surv.xgboost", nrounds = 1)
  fun = xgboost::xgb.train
  exclude = c(
    "x", # handled by mlr3
    "params", # handled by mlr3
    "data", # handled by mlr3
    "obj" # handled via type parameter
  )

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "Missing parameters:",
    paste0("- '", ParamTest$missing, "'", collapse = ",")))
})

test_that("predict surv.xgboost", {
  learner = lrn("surv.xgboost")
  fun = xgboost:::predict.xgb.Booster
  exclude = c(
    "object", # handled by mlr3
    "newdata", # handled by mlr3
    "outputmargin", # always FALSE
    "predleaf", # always FALSE
    "predcontrib", # always FALSE
    "approxcontrib", # unused
    "predinteraction", # always FALSE
    "reshape", # handled internally
    "training" # always FALSE
  )

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "Missing parameters:",
    paste0("- '", ParamTest$missing, "'", collapse = ",")))
})
