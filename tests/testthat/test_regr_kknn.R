context("regr.kknn")

skip_if_not_installed("kknn")

test_that("autotest", {
  learner = mlr3::lrn("regr.kknn")
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})
