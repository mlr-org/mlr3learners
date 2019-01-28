context("regr.lm")

test_that("autotest", {
  learner = LearnerRegrLm$new()
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})
