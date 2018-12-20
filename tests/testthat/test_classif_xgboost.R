context("classif.xgboost")

test_that("classif.xgboost test feature types", {
  lrn = LearnerClassifXgboost$new()
  test_learner(lrn)
})
