context("regr.glmnet")

skip_on_os("solaris")

test_that("autotest", {
  learner = LearnerRegrGlmnet$new()
  expect_learner(learner)
  result = run_autotest(learner, exclude = "feat_single")
  expect_true(result, info = result$error)
})
