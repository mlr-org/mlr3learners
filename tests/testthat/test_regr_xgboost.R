skip_if_not_installed("xgboost")

test_that("autotest", {
  learner = mlr3::lrn("regr.xgboost", nrounds = 5L)
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})

test_that("retrain", {
  learner = lrn("regr.xgboost", nrounds = 5L)
  task = tsk("boston_housing")
  task$select(task$feature_names[task$feature_names %nin% c("chas", "town")])
  learner$train(task)
  expect_equal(learner$model$niter, 5)
  expect_equal(learner$state$param_vals$nrounds, 5)

  expect_true(learner$is_retrainable(list(nrounds = 10)))
  learner$retrain(task, list(nrounds = 10))
  expect_equal(learner$model$niter, 10)
  expect_equal(learner$state$param_vals$nrounds, 10)

  expect_false(learner$is_retrainable(list(nrounds = 10)))
  expect_error(learner$retrain(task, list(nrounds = 10L), allow_train = FALSE),
    regexp = "is not retrainable")
})
