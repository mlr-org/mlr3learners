context("regr.glmnet")

test_that("autotest", {
  learner = LearnerRegrGlmnet$new()
  result = run_autotest(learner, exclude = "(feat_single|sanity)")
  expect_true(result, info = result$error)
})
