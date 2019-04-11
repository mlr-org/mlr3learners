context("regr.kknn")

test_that("autotest", {
  learner = LearnerRegrKKNN$new()
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})
