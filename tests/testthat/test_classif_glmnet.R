context("classif.glmnet")

test_that("classif.glmnet test feature types", {
  lrn = LearnerClassifGlmnet$new()
  expect_autotest(lrn, exclude = c("feat_integer", "feat_numeric"))
})
