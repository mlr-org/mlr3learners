context("classif.kknn")

test_that("autotest", {
  learner = mlr3::lrn("classif.kknn")
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})
