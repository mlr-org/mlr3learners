context("regr.glmnet")

test_that("autotest", {
  learner = mlr3::lrn("regr.glmnet")
  expect_learner(learner)

  skip_on_os("solaris")
  result = run_autotest(learner, exclude = "feat_single")
  expect_true(result, info = result$error)
})
