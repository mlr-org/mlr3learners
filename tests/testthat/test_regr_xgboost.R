skip_if_not_installed("xgboost")
skip_on_cran()

test_that("autotest", {
  learner = mlr3::lrn("regr.xgboost", nrounds = 5L)
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})

test_that("hotstart", {
  task = tsk("boston_housing")
  task$select(task$feature_names[task$feature_names %nin% c("chas", "town")])

  learner_1 = lrn("regr.xgboost", nrounds = 5L)
  learner_1$train(task)
  expect_equal(learner_1$state$param_vals$nrounds, 5L)
  expect_equal(learner_1$model$niter, 5L)

  hot = HotstartStack$new(learner_1)

  learner_2 = lrn("regr.xgboost", nrounds = 10L)
  learner_2$hotstart_stack = hot
  expect_equal(hot$start_cost(learner_2, task$hash), 5L)
  learner_2$train(task)
  expect_equal(learner_2$model$niter, 10L)
  expect_equal(learner_2$param_set$values$nrounds, 10L)
  expect_equal(learner_2$state$param_vals$nrounds, 10L)

  learner_3 = lrn("regr.xgboost", nrounds = 2L)
  learner_3$hotstart_stack = hot
  expect_equal(hot$start_cost(learner_3, task$hash), NA_real_)
  learner_3$train(task)
  expect_equal(learner_3$model$niter, 2L)
  expect_equal(learner_3$param_set$values$nrounds, 2L)
  expect_equal(learner_3$state$param_vals$nrounds, 2L)

  learner_4 = lrn("regr.xgboost", nrounds = 5L)
  learner_4$hotstart_stack = hot
  expect_equal(hot$start_cost(learner_4, task$hash), -1L)
  learner_4$train(task)
  expect_equal(learner_4$model$niter, 5L)
  expect_equal(learner_4$param_set$values$nrounds, 5L)
  expect_equal(learner_4$state$param_vals$nrounds, 5L)
})

test_that("validation and inner tuning", {
  task = tsk("mtcars")

  learner = lrn("regr.xgboost",
    nrounds = 10,
    early_stopping_rounds = 1,
    validate = 0.2
  )

  learner$train(task)
  expect_named(learner$model$evaluation_log, c("iter", "test_rmse"))
  expect_list(learner$internal_valid_scores, types = "numeric")
  expect_equal(names(learner$internal_valid_scores), "rmse")

  expect_list(learner$internal_tuned_values, types = "integerish")
  expect_equal(names(learner$internal_tuned_values), "nrounds")

  learner$validate = NULL
  expect_error(learner$train(task), "field 'validate'")

  learner$validate = 0.2
  task$internal_valid_task = NULL
  learner$param_set$set_values(
    early_stopping_rounds = NULL
  )
  learner$train(task)
  expect_equal(learner$internal_tuned_values, NULL)
  expect_named(learner$model$evaluation_log, c("iter", "test_rmse"))
  expect_list(learner$internal_valid_scores, types = "numeric")
  expect_equal(names(learner$internal_valid_scores), "rmse")

  learner = lrn("regr.xgboost",
    nrounds = to_tune(upper = 1000, internal = TRUE),
    validate = 0.2
  )
  s = learner$param_set$search_space()
  expect_error(learner$param_set$convert_internal_search_space(s), "Parameter")
  learner$param_set$set_values(early_stopping_rounds = 10)
  learner$param_set$disable_internal_tuning("nrounds")
  expect_equal(learner$param_set$values$early_stopping_rounds, NULL)

  learner = lrn("regr.xgboost",
    nrounds = 100L,
    early_stopping_rounds = 5,
    validate = 0.2
  )
  learner$train(task)
  expect_equal(learner$internal_valid_scores$rmse,
    learner$model$evaluation_log$test_rmse[learner$internal_tuned_values$nrounds])

  learner = lrn("regr.xgboost")
  learner$train(task)
  expect_true(is.null(learner$internal_valid_scores))
  expect_true(is.null(learner$internal_tuned_values))

  learner = lrn("regr.xgboost", validate = 0.3, nrounds = 10)
  learner$train(task)
  expect_equal(learner$internal_valid_scores$rmse, learner$model$evaluation_log$test_rmse[10L])
  expect_true(is.null(learner$internal_tuned_values))

  learner$param_set$set_values(
    nrounds = to_tune(upper = 100, internal = TRUE),
    early_stopping_rounds = 10
  )
  expect_error(
    learner$param_set$convert_internal_search_space(learner$param_set$search_space()),
    "eval_metric"
  )

  learner$param_set$set_values(
    eval_metric = "rmse"
  )
  expect_error(
    learner$param_set$convert_internal_search_space(learner$param_set$search_space()),
    regexp = NA
  )
})

test_that("custom inner validation measure", {

  # internal measure
  task = tsk("mtcars")

  learner = lrn("regr.xgboost",
    nrounds = 10,
    validate = 0.2,
    early_stopping_rounds = 10,
    eval_metric = "error"
  )

  learner$train(task)

  expect_named(learner$model$evaluation_log, c("iter", "test_error"))
  expect_list(learner$internal_valid_scores, types = "numeric")
  expect_equal(names(learner$internal_valid_scores), "error")

  # function
  task = tsk("mtcars")

  rmse = function(preds, dtrain) {
    truth = xgboost::getinfo(dtrain, "label")
    rmse = sqrt(mean((truth - preds)^2))
    return(list(metric = "rmse", value = rmse))
  }

  learner = lrn("regr.xgboost",
    nrounds = 10,
    validate = 0.2,
    early_stopping_rounds = 10,
    eval_metric = rmse,
    maximize = FALSE
  )

  learner$train(task)

  expect_named(learner$model$evaluation_log, c("iter", "test_rmse"))
  expect_list(learner$internal_valid_scores, types = "numeric")
  expect_equal(names(learner$internal_valid_scores), "rmse")

  # mlr3 measure
  task = tsk("mtcars")

  learner = lrn("regr.xgboost",
    nrounds = 10,
    validate = 0.2,
    early_stopping_rounds = 10,
    eval_metric = msr("regr.rmse")
  )

  learner$train(task)

  expect_named(learner$model$evaluation_log, c("iter", "test_regr.rmse"))
  expect_list(learner$internal_valid_scores, types = "numeric")
  expect_equal(names(learner$internal_valid_scores), "regr.rmse")
})

test_that("mlr3measures are equal to internal measures", {
  # reg:squarederror
  set.seed(1)
  task = tsk("mtcars")

  learner = lrn("regr.xgboost",
    nrounds = 10,
    validate = 0.2,
    early_stopping_rounds = 10,
    eval_metric = msr("regr.rmse")
  )

  learner$train(task)
  log_mlr3 = learner$model$evaluation_log$test_regr.rmse

  set.seed(1)
  learner$param_set$set_values(eval_metric = "rmse")
  learner$train(task)

  log_internal = learner$model$evaluation_log$test_rmse

  expect_equal(log_mlr3, log_internal)

  # reg:absoluteerror
  set.seed(1)
  task = tsk("mtcars")

  learner = lrn("regr.xgboost",
    nrounds = 10,
    validate = 0.2,
    objective = "reg:absoluteerror",
    early_stopping_rounds = 10,
    eval_metric = msr("regr.rmse")
  )

  learner$train(task)
  log_mlr3 = learner$model$evaluation_log$test_regr.rmse

  set.seed(1)
  learner$param_set$set_values(eval_metric = "rmse")
  learner$train(task)

  log_internal = learner$model$evaluation_log$test_rmse

  expect_equal(log_mlr3, log_internal)
})
