skip_if_not_installed("MASS")

test_that("autotest", {
  learner = mlr3::lrn("classif.qda")
  expect_learner(learner)
  result = run_autotest(learner, N = 50L, exclude = "feat_single")
  expect_true(result, info = result$error)
})
