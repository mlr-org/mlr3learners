context("classif.svm")

test_that("autotest", {
  learner = LearnerClassifSvm$new()
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})
