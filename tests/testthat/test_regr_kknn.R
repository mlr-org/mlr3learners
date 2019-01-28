context("regr.kknn")

test_that("autotest", {
  learner = LearnerRegrKKNN$new()
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})
