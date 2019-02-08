context("classif.xgboost")

test_that("autotest", {
  learner = LearnerClassifXgboost$new()
  learner$param_set$values = insert_named(learner$param_set$values, list(nrounds = 5L))
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})
