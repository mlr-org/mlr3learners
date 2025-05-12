skip_if_not_installed("nnet")
skip_on_cran() # numerically instable with ATLAS blas

test_that("autotest", {
  learner = mlr3::lrn("classif.nnet")
  expect_learner(learner)
  capture.output({result = run_autotest(learner)})
  expect_true(result, info = result$error)
})
