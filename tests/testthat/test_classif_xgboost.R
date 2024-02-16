skip_if_not_installed("xgboost")
skip_on_cran()

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

test_that("hotstart", {
  task = tsk("iris")

  learner_1 = lrn("classif.xgboost", nrounds = 5L)
  learner_1$train(task)
  expect_equal(learner_1$state$param_vals$nrounds, 5L)
  expect_equal(learner_1$model$niter, 5L)

  hot = HotstartStack$new(learner_1)

  learner_2 = lrn("classif.xgboost", nrounds = 10L)
  learner_2$hotstart_stack = hot
  expect_equal(hot$start_cost(learner_2, task$hash), 5L)
  learner_2$train(task)
  expect_equal(learner_2$model$niter, 10L)
  expect_equal(learner_2$param_set$values$nrounds, 10L)
  expect_equal(learner_2$state$param_vals$nrounds, 10L)

  learner_3 = lrn("classif.xgboost", nrounds = 2L)
  learner_3$hotstart_stack = hot
  expect_equal(hot$start_cost(learner_3, task$hash), NA_real_)
  learner_3$train(task)
  expect_equal(learner_3$model$niter, 2L)
  expect_equal(learner_3$param_set$values$nrounds, 2L)
  expect_equal(learner_3$state$param_vals$nrounds, 2L)

  learner_4 = lrn("classif.xgboost", nrounds = 5L)
  learner_4$hotstart_stack = hot
  expect_equal(hot$start_cost(learner_4, task$hash), -1L)
  learner_4$train(task)
  expect_equal(learner_4$model$niter, 5L)
  expect_equal(learner_4$param_set$values$nrounds, 5L)
  expect_equal(learner_4$state$param_vals$nrounds, 5L)
})

test_that("early stopping on the test set works", {
  skip_if(packageVersion("mlr3") > "0.17.2")
  task = tsk("spam")
  split = partition(task, ratio = 0.8)
  task$set_row_roles(split$test, "test")
  learner = lrn("classif.xgboost",
    nrounds = 1000,
    early_stopping_rounds = 100,
    early_stopping_set = "test"
  )

  learner$train(task)
  expect_named(learner$model$evaluation_log, c("iter", "train_logloss", "test_logloss"))
})

test_that("early stopping on the test set works", {
  skip_if(packageVersion("mlr3") <= "0.17.2")
  task = tsk("spam")
  split = partition(task, ratio = 0.8)
  task$partition(split$test, "test")
  learner = lrn("classif.xgboost",
    nrounds = 1000,
    early_stopping_rounds = 100,
    early_stopping_set = "test"
  )

  learner$train(task)
  expect_named(learner$model$evaluation_log, c("iter", "train_logloss", "test_logloss"))
})

test_that("uses_test_task property", {
  l = lrn("classif.xgboost")
  expect_false("uses_test_task" %in% l$properties)
  l$param_set$set_values(early_stopping_set = "test")
  expect_true("uses_test_task" %in% l$properties)
})
