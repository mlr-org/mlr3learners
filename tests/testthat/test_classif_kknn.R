context("classif.kknn")

test_that("autotest", {
  learner = LearnerClassifKKNN$new()
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})
