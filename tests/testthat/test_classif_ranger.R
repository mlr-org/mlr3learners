context("classif.ranger")

test_that("autotest", {
  learner = LearnerClassifRanger$new()
  learner$param_vals = list(num.trees = 30L)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})
