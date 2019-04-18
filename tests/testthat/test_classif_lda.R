context("classif.lda")

test_that("autotest", {
  learner = LearnerClassifLDA$new()
  expect_learner(learner)
  # result = run_autotest(learner, exclude = "(feat_single)")
  # expect_true(result, info = result$error)
})
