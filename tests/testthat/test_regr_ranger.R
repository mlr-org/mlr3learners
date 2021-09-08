skip_if_not_installed("ranger")

test_that("autotest", {
  learner = mlr3::lrn("regr.ranger", num.trees = 100, importance = "impurity")
  expect_learner(learner)
  result = run_autotest(learner, N = 50L)
  expect_true(result, info = result$error)
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
