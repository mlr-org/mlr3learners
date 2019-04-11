context("classif.glmnet")

test_that("autotest", {
  learner = LearnerClassifGlmnet$new()
  expect_learner(learner)
  result = run_autotest(learner, exclude = "(feat_single|sanity)")
  expect_true(result, info = result$error)
})
