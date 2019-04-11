context("classif.ranger")

test_that("autotest", {
  learner = LearnerClassifRanger$new()
  expect_learner(learner)
  learner$param_set$values = list(num.trees = 30L, importance = "impurity")
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})
