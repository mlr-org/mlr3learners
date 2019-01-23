context("classif.kknn")

test_that("classif.kknn autotest", {
  learner = LearnerClassifKKNN$new()
  expect_autotest(learner)
})
