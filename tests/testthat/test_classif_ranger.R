skip_if_not_installed("ranger")

test_that("autotest", {
  learner = mlr3::lrn("classif.ranger")
  expect_learner(learner)
  learner$param_set$values = list(num.trees = 30L, importance = "impurity")
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})

test_that("mtry.ratio", {
  task = mlr3::tsk("sonar")
  learner = mlr3::lrn("classif.ranger", mtry.ratio = 0.5)

  res = ranger_get_mtry(learner$param_set$values, task)
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
