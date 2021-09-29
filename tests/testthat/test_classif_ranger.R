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

test_that("mtry.ratio", {
  task = mlr3::tsk("sonar")
  learner = mlr3::lrn("classif.ranger", mtry.ratio = 0.5)

  res = convert_ratio(learner$param_set$values, "mtry", "mtry.ratio", length(task$feature_names))
  expect_equal(
    res$mtry,
    30
  )
  expect_null(res$mtry.ratio)

  learner$train(task)
  expect_equal(
    learner$model$mtry,
    30
  )
})

test_that("convert_ratio", {
  task = tsk("sonar")
  learner = lrn("classif.ranger", num.trees = 5, mtry.ratio = .5)
  expect_equal(learner$train(task)$model$mtry, 30)

  learner$param_set$values$mtry.ratio = 0
  expect_equal(learner$train(task)$model$mtry, 1)

  learner$param_set$values$mtry.ratio = 1
  expect_equal(learner$train(task)$model$mtry, 60)

  learner$param_set$values$mtry = 10
  expect_error(learner$train(task), "exclusive")

  learner$param_set$values$mtry.ratio = NULL
  expect_equal(learner$train(task)$model$mtry, 10)

  learner$param_set$values$mtry = 10
  expect_equal(learner$train(task)$model$mtry, 10)
})
