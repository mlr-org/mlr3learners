context("regr.km")

skip_if_not_installed("DiceKriging")

test_that("autotest", {
  learner = mlr3::lrn("regr.km", nugget.stability = 1e-8)
  expect_learner(learner)
  result = run_autotest(learner, exclude = "feat_single", N = 50)
  expect_true(result, info = result$error)
})

test_that("autotest w/ jitter", {
  learner = mlr3::lrn("regr.km", nugget.stability = 1e-8, jitter = 1e-12)
  expect_learner(learner)
  result = run_autotest(learner, exclude = "feat_single", N = 50)
  expect_true(result, info = result$error)
})

test_that("update", {
  learner = lrn("regr.km")
  task = tsk("boston_housing")
  task$select(task$feature_names[task$feature_names %nin% c("chas", "town")])

  learner$train(task, row_ids = 1:20)
  expect_equal(learner$model@n, 20)
  learner$update(task, row_ids = 21:40)
  expect_equal(learner$model@n, 40)
})
