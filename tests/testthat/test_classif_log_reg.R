test_that("autotest", {
  learner = mlr3::lrn("classif.log_reg")
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})
