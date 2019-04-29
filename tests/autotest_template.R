# TODO: Replace template with your learner name.
context("classif.template")

test_that("autotest", {
  # TODO: Replace TEMPLATE with your learner name.
  learner = LearnerClassifTEMPLATE$new()
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})
