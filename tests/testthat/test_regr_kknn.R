context("regr.kknn")

test_that("regr.kknn autotest", {
  learner = LearnerRegrKKNN$new()
  expect_autotest(learner)
})
