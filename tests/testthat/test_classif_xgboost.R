context("classif.xgboost")

test_that("autotest", {
  learner = LearnerClassifXgboost$new()
  expect_learner(learner)
  learner$param_set$values = insert_named(learner$param_set$values, list(nrounds = 5L))
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})

test_that("xgboost with softmax", {
  learner = LearnerClassifXgboost$new()
  learner$param_set$values = insert_named(learner$param_set$values, list(nrounds = 5L, objective = "multi:softmax"))
  result = run_autotest(learner, predict_types = "response")
  expect_true(result, info = result$error)
})
