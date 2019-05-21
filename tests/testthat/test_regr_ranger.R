context("regr.ranger")

test_that("autotest", {
  learner = LearnerRegrRanger$new()
  expect_learner(learner)
  learner$param_set$values = list(num.trees = 100L, importance = "impurity")
  result = run_autotest(learner, N = 50L)
  expect_true(result, info = result$error)

  learner = LearnerRegrRanger$new()
  learner$predict_type = "se"
  e = Experiment$new("boston_housing", learner)
  e$train()
  self = e$learner
  task = e$task
})
