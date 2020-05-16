context("surv.glmnet")

skip_if_not_installed("glmnet")

test_that("autotest", {
  learner = mlr3::lrn("surv.glmnet")
  expect_learner(learner)

  skip_on_os("solaris")
  result = run_autotest(learner, exclude = "(feat_single|sanity)")
  expect_true(result, info = result$error)
})
