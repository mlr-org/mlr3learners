skip_if_not_installed("kknn")

test_that("autotest", {
  learner = mlr3::lrn("regr.kknn")
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})

test_that("custom model", {
  task = tsk("mtcars")
  learner = mlr3::lrn("regr.kknn")
  expect_null(learner$model)

  learner$train(task)
  mod = learner$model
  expect_list(mod, names = "unique", len = 4L)
  expect_null(mod$kknn)
  expect_formula(mod$formula)
  expect_data_table(mod$data)
  expect_list(mod$pars, names = "unique")

  learner$predict(task)
  mod = learner$model
  expect_list(mod, names = "unique", len = 4L)
  expect_is(mod$kknn, "kknn")
  expect_formula(mod$formula)
  expect_data_table(mod$data)
  expect_list(mod$pars, names = "unique")
})
