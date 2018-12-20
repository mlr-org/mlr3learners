context("classif.ranger")

test_that("classif.ranger test feature types", {
  lrn = LearnerClassifRanger$new()
  test_learner(lrn)
})
