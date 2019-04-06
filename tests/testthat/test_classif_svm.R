context("classif.svm")

test_that("autotest", {
  learner = LearnerClassifSvm$new()
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})
