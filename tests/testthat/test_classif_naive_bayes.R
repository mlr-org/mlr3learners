context("classif.naive_bayes")

test_that("autotest", {
  learner = LearnerClassifNaiveBayes$new()
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})
