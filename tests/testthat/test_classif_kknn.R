context("classif.kknn")

skip_if_not_installed("kknn")

test_that("autotest", {
  learner = mlr3::lrn("classif.kknn")
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})

test_that("custom model AB", {
  task = tsk("iris")
  learner = mlr3::lrn("classif.kknn")
  expect_null(learner$model)

  learner$train(task)
  expect_null(learner$model)

  learner$predict(task)
  learner$state
  expect_is(learner$model, "kknn")
})
