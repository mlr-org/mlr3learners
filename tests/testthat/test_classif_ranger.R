context("classif.ranger")

test_that("autotest", {
  learner = mlr3::lrn("classif.ranger")
  expect_learner(learner)
  learner$param_set$values = list(num.trees = 30L, importance = "impurity")
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})
