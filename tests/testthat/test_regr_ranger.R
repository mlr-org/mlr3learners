context("regr.ranger")

test_that("regr.ranger test feature types", {
  lrn = LearnerRegrRanger$new()
  lrn$param_vals = list(keep.inbag = TRUE, num.trees = 30L)
  expect_autotest(lrn)
})
