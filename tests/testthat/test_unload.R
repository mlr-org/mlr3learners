test_that("unloading leaves no trace", {
  library(mlr3leaners)
  n_learners = length(learners)
  n_total = length(mlr_learners$keys())
  unloadNamespace("mlr3learners")
  n_mlr = length(mlr_learners$keys())
  expect_true(n_learners == n_total - n_mlr)
})
