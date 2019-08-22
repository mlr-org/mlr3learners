context("regr.svm")

test_that("autotest", {
  learner = mlr3::lrn("regr.svm")
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})
