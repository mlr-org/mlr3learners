skip_if_not_installed("ranger")

test_that("autotest", {
  learner = mlr3::lrn("regr.ranger", num.trees = 100, importance = "impurity")
  expect_learner(learner)
  result = run_autotest(learner, N = 50L)
  expect_true(result, info = result$error)
})

test_that("retrain", {
  learner = lrn("regr.ranger", num.trees = 1000L)
  task = tsk("boston_housing")
  task$select(task$feature_names[task$feature_names %nin% c("chas", "town")])
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

test_that("mtry.ratio", {
  task = mlr3::tsk("mtcars")
  learner = mlr3::lrn("regr.ranger", mtry.ratio = 0.5)

  res = convert_ratio(learner$param_set$values, "mtry", "mtry.ratio", length(task$feature_names))
  expect_equal(
    res$mtry,
    5
  )
  expect_null(res$mtry.ratio)

  learner$train(task)
  expect_equal(
    learner$model$mtry,
    5
  )
})
