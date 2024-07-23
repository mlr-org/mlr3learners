skip_if_not_installed("nnet")
skip_on_cran() # numerically instable with ATLAS blas

test_that("autotest", {
  learner = mlr3::lrn("regr.nnet")
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})
