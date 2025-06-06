skip_if_not_installed("e1071")

test_that("autotest", {
  learner = mlr3::lrn("classif.naive_bayes")
  expect_learner(learner)
  capture.output({result = run_autotest(learner)})
  expect_true(result, info = result$error)
})
