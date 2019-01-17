context("regr.xgboost")

test_that("regr.xgboost test feature types", {
  lrn = LearnerRegrXgboost$new()
  lrn$param_vals = list(nrounds = 30L)
  expect_autotest(lrn)
})
