skip_if_not_installed("e1071")

test_that("autotest", {
  learner = mlr3::lrn("regr.svm")
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})


test_that("autotest with type nu-regression (#209)", {
  learner = mlr3::lrn("regr.svm", type = "nu-regression")
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})
