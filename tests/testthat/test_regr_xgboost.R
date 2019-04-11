context("regr.xgboost")

test_that("autotest", {
  learner = LearnerRegrXgboost$new()
  expect_learner(learner)
  learner$param_set$values = insert_named(learner$param_set$values, list(nrounds = 5L))
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})
