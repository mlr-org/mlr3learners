context("classif.glmnet")

test_that("autotest", {
  learner = LearnerClassifGlmnet$new()
  result = run_autotest(learner, exclude = "(feat_single|sanity)")
  expect_true(result, info = result$error)
})
