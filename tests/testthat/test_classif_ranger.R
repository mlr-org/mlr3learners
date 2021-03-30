skip_if_not_installed("ranger")

test_that("autotest", {
  learner = mlr3::lrn("classif.ranger")
  expect_learner(learner)
  learner$param_set$values = list(num.trees = 30L, importance = "impurity")
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})

test_that("retrain", {
  learner = lrn("classif.ranger", num.trees = 1000L)
  task = tsk("iris")
  learner$train(task)
  expect_equal(learner$state$param_vals$num.trees, 1000L)
  expect_equal(learner$model$num.trees, 1000L)

  expect_true(learner$is_retrainable(list(num.trees = 500L)))
  learner$retrain(task, list(num.trees = 500L), allow_train = FALSE)
  expect_equal(learner$state$param_vals$num.trees, 500L)
  expect_equal(learner$model$num.trees, 500L)

  expect_false(learner$is_retrainable(list(num.trees = 2000L)))
  expect_error(learner$retrain(task, list(num.trees = 2000L), allow_train = FALSE),
    regexp = "is not retrainable")
})
