skip_if_not_installed("DiceKriging")

test_that("autotest", {
  learner = mlr3::lrn("regr.km", nugget.stability = 1e-8)
  expect_learner(learner)
  capture.output({result = run_autotest(learner, exclude = "feat_single", N = 50)})
  expect_true(result, info = result$error)
})

test_that("autotest w/ jitter", {
  learner = mlr3::lrn("regr.km", nugget.stability = 1e-8, jitter = 1e-12)
  expect_learner(learner)
  capture.output({result = run_autotest(learner, exclude = "feat_single|reordered", N = 50)})
  expect_true(result, info = result$error)
})
