context("classif.qda")

test_that("autotest", {
  learner = LearnerClassifQDA$new()
  expect_learner(learner)
  result = run_autotest(learner, N = 50L, exclude = "feat_single")
  expect_true(result, info = result$error)
})
