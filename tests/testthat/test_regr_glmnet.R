context("regr.glmnet")

test_that("regr.glmnet test feature types", {
  learner = LearnerRegrGlmnet$new()
  expect_autotest(learner, exclude = "(feat_single|sanity)")
})
