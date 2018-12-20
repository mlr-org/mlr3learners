context("classif.logreg")

test_that("classif.logreg test feature types", {
  lrn = LearnerClassifLogReg$new()
  test_learner(lrn)
})
