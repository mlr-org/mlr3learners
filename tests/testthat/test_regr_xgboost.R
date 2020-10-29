context("regr.xgboost")

skip_if_not_installed("xgboost")

test_that("autotest", {
  learner = mlr3::lrn("regr.xgboost", nrounds = 5L)
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})

test_that("continue", {
  learner = mlr3::lrn("regr.xgboost", nrounds = 5L)
  task = tsk("boston_housing")
  task$select(task$feature_names[task$feature_names %nin% c("chas", "town")])

  learner$train(task)
  expect_equal(learner$model$niter, 5)

  learner$param_set$values$nrounds = 10
  learner$continue(task)
  expect_equal(learner$model$niter, 10)
})

test_that("update", {
  learner = mlr3::lrn("regr.xgboost", nrounds = 5L)
  task = tsk("boston_housing")
  task$select(task$feature_names[task$feature_names %nin% c("chas", "town")])

  learner$train(task, row_ids = 1:50)
  expect_equal(learner$model$niter, 5)

  learner$param_set$values$nrounds = 10
  learner$update(task, row_ids = 51:100)
  expect_equal(learner$model$niter, 10)
})
