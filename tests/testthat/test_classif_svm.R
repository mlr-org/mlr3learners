context("classif.svm")

skip_if_not_installed("e1071")

test_that("autotest", {
  learner = mlr3::lrn("classif.svm")
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})
