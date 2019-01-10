context("classif.ranger")

test_that("classif.ranger test feature types", {
  lrn = LearnerClassifRanger$new()
  lrn$param_vals = list(num.trees = 30L)
  expect_autotest(lrn)
})
