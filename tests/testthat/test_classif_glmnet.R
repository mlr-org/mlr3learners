context("classif.glmnet")

test_that("classif.glmnet test feature types", {
  lrn = LearnerClassifGlmnet$new()
  test_learner(lrn)
})
