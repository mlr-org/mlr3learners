skip_if_not_installed("kknn")

test_that("autotest", {
  learner = mlr3::lrn("classif.kknn")
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})

test_that("custom model", {
  task = tsk("iris")
  learner = mlr3::lrn("classif.kknn")
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
  expect_s3_class(mod$kknn, "kknn")
  expect_formula(mod$formula)
  expect_data_table(mod$data)
  expect_list(mod$pars, names = "unique")
})

test_that("error for k >= n", {
  task = tsk("iris")$filter(1:3)
  learner = mlr3::lrn("classif.kknn", k = 4)

  expect_error(learner$train(task))
})
