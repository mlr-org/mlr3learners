context("classif.lda")

skip_if_not_installed("MASS")

test_that("autotest", {
  learner = mlr3::lrn("classif.lda")
  expect_learner(learner)
  result = run_autotest(learner, exclude = "feat_single")
  expect_true(result, info = result$error)
})
