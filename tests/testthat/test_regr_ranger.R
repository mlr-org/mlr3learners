context("regr.ranger")

test_that("autotest", {
  learner = LearnerRegrRanger$new()
  expect_learner(learner)
  learner$param_set$values = list(keep.inbag = TRUE, num.trees = 100L, importance = "impurity")
  result = run_autotest(learner, N = 50L)
  expect_true(result, info = result$error)
})
