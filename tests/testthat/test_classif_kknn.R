context("classif.kknn")

test_that("autotest", {
  learner = LearnerClassifKKNN$new()
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})
