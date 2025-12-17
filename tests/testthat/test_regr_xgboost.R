skip_if_not_installed("xgboost")
skip_on_cran()

test_that("autotest", {
  learner = mlr3::lrn("regr.xgboost", nrounds = 5L)
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})

test_that("hotstart", {
  task = tsk("mtcars")
  task$select(task$feature_names[task$feature_names %nin% c("chas", "town")])

  learner_1 = lrn("regr.xgboost", nrounds = 5L)
  learner_1$train(task)
  expect_equal(learner_1$state$param_vals$nrounds, 5L)
  expect_equal(xgboost::xgb.get.num.boosted.rounds(learner_1$model), 5L)

  hot = HotstartStack$new(learner_1)

  learner_2 = lrn("regr.xgboost", nrounds = 10L)
  learner_2$hotstart_stack = hot
  expect_equal(hot$start_cost(learner_2, task$hash), 5L)
  learner_2$train(task)
  expect_equal(xgboost::xgb.get.num.boosted.rounds(learner_2$model), 10L)
  expect_equal(learner_2$param_set$values$nrounds, 10L)
  expect_equal(learner_2$state$param_vals$nrounds, 10L)

  learner_3 = lrn("regr.xgboost", nrounds = 2L)
  learner_3$hotstart_stack = hot
  expect_equal(hot$start_cost(learner_3, task$hash), NA_real_)
  learner_3$train(task)
  expect_equal(xgboost::xgb.get.num.boosted.rounds(learner_3$model), 2L)
  expect_equal(learner_3$param_set$values$nrounds, 2L)
  expect_equal(learner_3$state$param_vals$nrounds, 2L)

  learner_4 = lrn("regr.xgboost", nrounds = 5L)
  learner_4$hotstart_stack = hot
  expect_equal(hot$start_cost(learner_4, task$hash), -1L)
  learner_4$train(task)
  expect_equal(xgboost::xgb.get.num.boosted.rounds(learner_4$model), 5L)
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
  expect_named(attributes(learner$model)$evaluation_log, c("iter", "test_rmse"))
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
  expect_named(attributes(learner$model)$evaluation_log, c("iter", "test_rmse"))
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
    attributes(learner$model)$evaluation_log$test_rmse[learner$internal_tuned_values$nrounds])

  learner = lrn("regr.xgboost")
  learner$train(task)
  expect_true(is.null(learner$internal_valid_scores))
  expect_true(is.null(learner$internal_tuned_values))

  learner = lrn("regr.xgboost", validate = 0.3, nrounds = 10)
  learner$train(task)
  expect_equal(learner$internal_valid_scores$rmse, attributes(learner$model)$evaluation_log$test_rmse[10L])
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

  expect_named(attributes(learner$model)$evaluation_log, c("iter", "test_error"))
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
    custom_metric = rmse,
    maximize = FALSE
  )

  learner$train(task)

  expect_named(attributes(learner$model)$evaluation_log, c("iter", "test_rmse"))
  expect_list(learner$internal_valid_scores, types = "numeric")
  expect_equal(names(learner$internal_valid_scores), "rmse")

  # mlr3 measure
  task = tsk("mtcars")

  learner = lrn("regr.xgboost",
    nrounds = 10,
    validate = 0.2,
    early_stopping_rounds = 10,
    custom_metric = msr("regr.rmse")
  )

  learner$train(task)

  expect_named(attributes(learner$model)$evaluation_log, c("iter", "test_regr.rmse"))
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
    custom_metric = msr("regr.rmse")
  )

  learner$train(task)
  log_mlr3 = attributes(learner$model)$evaluation_log$test_regr.rmse

  set.seed(1)
  learner$param_set$set_values(eval_metric = "rmse", custom_metric = NULL)
  learner$train(task)

  log_internal = attributes(learner$model)$evaluation_log$test_rmse

  expect_equal(log_mlr3, log_internal)

  # reg:absoluteerror
  set.seed(1)
  task = tsk("mtcars")

  learner = lrn("regr.xgboost",
    nrounds = 10,
    validate = 0.2,
    objective = "reg:absoluteerror",
    early_stopping_rounds = 10,
    custom_metric = msr("regr.rmse")
  )

  learner$train(task)
  log_mlr3 = attributes(learner$model)$evaluation_log$test_regr.rmse

  set.seed(1)
  learner$param_set$set_values(eval_metric = "rmse", custom_metric = NULL)
  learner$train(task)

  log_internal = attributes(learner$model)$evaluation_log$test_rmse

  expect_equal(log_mlr3, log_internal)
})

test_that("base_margin (offset)", {
  data = with_seed(1, {
    n = 200
    x = rnorm(n)
    eta = 0.3 * x
    lambda = exp(eta)
    y = rpois(n, lambda)
    data.frame(x, y)
  })

  # main task
  task = as_task_regr(data, target = "y")

  # task with a zero constant offset
  task_offset = task$clone()
  task_offset$cbind(data.frame(zeros = rep(0, n)))
  task_offset$set_col_roles(cols = "zeros", roles = "offset")

  # task with a random offset per observation
  task_offset2 = task$clone()
  task_offset2$cbind(data.frame(random_offset = runif(n)))
  task_offset2$set_col_roles(cols = "random_offset", roles = "offset")

  # add predefined internal validation task
  part = partition(task, c(0.6, 0.2)) # 60% train, 20% test, 20% validate
  task$internal_valid_task = part$validation
  task_offset$internal_valid_task = part$validation
  task_offset2$internal_valid_task = part$validation

  # use Poisson where base_score = 1 is equivalent to base_margin = 0:
  # log(mean-scale) = base_margin + f(x)
  # https://xgboost.readthedocs.io/en/stable/tutorials/intercept.html#offset
  l0 = lrn("regr.xgboost", objective = "count:poisson",
           nrounds = 3, base_score = 1)
  l1 = lrn("regr.xgboost", objective = "count:poisson",
           nrounds = 3) # estimated base_score (learned global intercept)
  l2 = l1$clone(deep = TRUE) # train and test on task_offset
  l3 = l1$clone(deep = TRUE) # train and test on task_offset2
  l0$validate = "predefined"
  l1$validate = "predefined"
  l2$validate = "predefined"
  l3$validate = "predefined"

  # train
  l0$train(task, part$train) # uses base_score = 1
  l1$train(task, part$train) # estimates base_score
  l2$train(task_offset, part$train) # uses base_margin = 0
  l3$train(task_offset2, part$train) # uses random base_margin
  # if you peek inside the l1, l2 and l3 xgboost models, you will see a
  # base_score value that has been estimated (i.e. to be used for prediction)
  # https://github.com/dmlc/xgboost/issues/11872#issuecomment-3666848941

  # different models: base_score = 1 vs estimated base_score
  expect_false(length(xgboost::xgb.dump(l0$model)) == length(xgboost::xgb.dump(l1$model)))
  # different models: estimated base_score vs base_margin = 0
  expect_false(length(xgboost::xgb.dump(l1$model)) == length(xgboost::xgb.dump(l2$model)))
  # different models: estimated base_score vs random base_margin
  expect_false(length(xgboost::xgb.dump(l1$model)) == length(xgboost::xgb.dump(l3$model)))
  # same models: base_score = 1 <=> base_margin = 0
  expect_equal(xgboost::xgb.dump(l0$model), xgboost::xgb.dump(l2$model))

  # l2 model: "zeros" is not a feature (it is the offset), "x" is a feature
  expect_true("zeros" %nin% xgboost::getinfo(l2$model, "feature_name"))
  expect_true("x" %in% xgboost::getinfo(l2$model, "feature_name"))
  # similar for the l3 model
  expect_true("random_offset" %nin% xgboost::getinfo(l3$model, "feature_name"))
  expect_true("x" %in% xgboost::getinfo(l3$model, "feature_name"))

  # predict (default: use_pred_offset = TRUE)
  p0 = l0$predict(task, part$test) # task has no offset, base_score = 1 is used
  p1 = l1$predict(task, part$test) # task has no offset, the estimated global intercept from train data is used
  p2 = l2$predict(task_offset, part$test) # zero offset from test data applied
  p3 = l3$predict(task_offset2, part$test) # random offset from test data is applied
  # when different offsets are used, we expect different results
  expect_false(all(p0$response == p1$response))
  expect_false(all(p0$response == p3$response))
  expect_false(all(p1$response == p2$response))
  expect_false(all(p1$response == p3$response))
  expect_false(all(p2$response == p3$response))
  # predictions came from exactly the same models + the test offsets were exactly
  # the same: base_score = 1 (p0) and base_margin = 0 (p2)
  expect_equal(p0$response, p2$response)

  # predict (use_pred_offset = FALSE)
  l0$param_set$set_values(use_pred_offset = FALSE)
  l1$param_set$set_values(use_pred_offset = FALSE)
  l2$param_set$set_values(use_pred_offset = FALSE)
  l3$param_set$set_values(use_pred_offset = FALSE)

  # task has no offset => offset is taken from the train model as before
  p00 = l0$predict(task, part$test)
  p11 = l1$predict(task, part$test)
  expect_equal(p0$response, p00$response) # base_score = 1 is used
  expect_equal(p1$response, p11$response) # estimated offset from train data is used

  # tasks have offsets now but they are disabled upon prediction!
  p22 = l2$predict(task_offset, part$test)
  p33 = l3$predict(task_offset2, part$test)
  # these differ from previous predictions (where task offsets were applied)
  expect_true(all(p2$response != p22$response))
  expect_true(all(p3$response != p33$response))
})
