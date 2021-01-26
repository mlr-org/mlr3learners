skip_if_not_installed("xgboost")

test_that("autotest", {
  learner = mlr3::lrn("classif.xgboost", nrounds = 5L)
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})

test_that("xgboost with softmax", {
  learner = mlr3::lrn("classif.xgboost", nrounds = 5L, objective = "multi:softmax")
  result = run_autotest(learner, predict_types = "response")
  expect_true(result, info = result$error)
})

test_that("xgboost with multi:softprob", {
  task = mlr_tasks$get("sonar")
  learner = mlr3::lrn("classif.xgboost", nrounds = 5L, objective = "multi:softprob")
  p = learner$train(task)$predict(task)
  expect_equal(unname(p$score()), 0)
})

test_that("xgboost with binary:logistic", {
  task = mlr_tasks$get("sonar")
  learner = mlr3::lrn("classif.xgboost", nrounds = 5L)
  p = learner$train(task)$predict(task)
  expect_equal(unname(p$score()), 0)
})

test_that("continue", {
  learner = mlr3::lrn("classif.xgboost", nrounds = 5L)
  task = tsk("pima")

  learner$train(task)
  expect_equal(learner$model$niter, 5)

  learner$param_set$values$nrounds = 10
  learner$continue(task)
  expect_equal(learner$model$niter, 10)
})

test_that("update", {
  learner = mlr3::lrn("classif.xgboost", nrounds = 5L)
  task = tsk("pima")

  learner$train(task, row_ids = 1:50)
  expect_equal(learner$model$niter, 5)

  learner$param_set$values$nrounds = 10
  learner$update(task, row_ids = 51:100)
  expect_equal(learner$model$niter, 10)
})
