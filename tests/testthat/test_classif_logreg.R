context("classif.logreg")

test_that("classif.logreg test feature types", {
  lrn = LearnerClassifLogReg$new()
  expect_autotest(lrn, exclude = "sanity")
})
