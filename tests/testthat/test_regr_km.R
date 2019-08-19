context("regr.km")

test_that("autotest", {
  learner = LearnerRegrKM$new()
  expect_learner(learner)
  result = run_autotest(learner, exclude = "feat_single", N = 50)
  expect_true(result, info = result$error)
})

test_that("autotest w/ jitter", {
  learner = LearnerRegrKM$new()
  learner$param_set$values = list(jitter = 1e-8)
  expect_learner(learner)
  result = run_autotest(learner, exclude = "feat_single", N = 50)
  expect_true(result, info = result$error)
})

test_that("autotest w/ nugget.stability", {
  learner = LearnerRegrKM$new()
  learner$param_set$values = list(nugget.stability = 1e-8)
  expect_learner(learner)
  result = run_autotest(learner, exclude = "feat_single", N = 50)
  expect_true(result, info = result$error)
})
