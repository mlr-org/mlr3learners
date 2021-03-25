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

test_that("retrain", {
  learner = lrn("classif.xgboost", nrounds = 5L)
  task = tsk("pima")
  learner$train(task)
  expect_equal(learner$model$niter, 5L)
  expect_equal(learner$state$param_vals$nrounds, 5L)

  expect_true(learner$is_retrainable(list(nrounds = 10L)))
  learner$retrain(task, list(nrounds = 10L), allow_train = FALSE)
  expect_equal(learner$model$niter, 10L)
  expect_equal(learner$state$param_vals$nrounds, 10L)

  expect_false(learner$is_retrainable(list(nrounds = 10L)))
  expect_error(learner$retrain(task, list(nrounds = 10L), allow_train = FALSE),
    regexp = "is not retrainable")
})
