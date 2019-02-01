context("classif.logreg")

test_that("autotest", {
  learner = LearnerClassifLogReg$new()
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})
