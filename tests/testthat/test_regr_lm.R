context("regr.lm")

test_that("regr.lm test feature types", {
  lrn = LearnerRegrLm$new()
  expect_autotest(lrn)
})
