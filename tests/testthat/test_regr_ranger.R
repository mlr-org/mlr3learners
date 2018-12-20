context("regr.ranger")

test_that("regr.ranger test feature types", {
  lrn = LearnerRegrRanger$new()
  lrn$param_vals = list(keep.inbag = TRUE)
  test_learner(lrn)
})
