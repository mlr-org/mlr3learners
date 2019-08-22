context("regr.km")

test_that("autotest", {
  learner = mlr3::lrn("regr.km", nugget.stability = 1e-8)
  expect_learner(learner)
  result = run_autotest(learner, exclude = "feat_single", N = 50)
  expect_true(result, info = result$error)
})

test_that("autotest w/ jitter", {
  learner = mlr3::lrn("regr.km", nugget.stability = 1e-8, jitter = 1e-8)
  expect_learner(learner)
  result = run_autotest(learner, exclude = "feat_single", N = 50)
  expect_true(result, info = result$error)
})
