context("regr.xgboost")

test_that("autotest", {
  learner = mlr3::lrn("regr.xgboost", nrounds = 5L)
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})
