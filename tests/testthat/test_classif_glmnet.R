context("classif.glmnet")
test_that("classif.glmnet test feature types", {
  learner = LearnerClassifGlmnet$new()
  expect_autotest(learner, exclude = "(feat_single|sanity)")
})
