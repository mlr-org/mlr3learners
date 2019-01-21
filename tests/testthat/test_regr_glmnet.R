context("regr.glmnet")

test_that("regr.glmnet test feature types", {
  lrn = LearnerRegrGlmnet$new()
  expect_autotest(lrn, exclude = "feat_single")
})
