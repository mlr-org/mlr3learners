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
  result = run_autotest(learner, predict_types = "response", exclude = "offset_binary")
  expect_true(result, info = result$error)
})

test_that("xgboost with multi:softprob", {
  task = tsk("sonar")
  learner = mlr3::lrn("classif.xgboost", nrounds = 5L, objective = "multi:softprob")
  p = learner$train(task)$predict(task)
  expect_equal(unname(p$score()), 0)
})

test_that("xgboost with binary:logistic", {
  task = tsk("sonar")
  learner = mlr3::lrn("classif.xgboost", nrounds = 5L)
  p = learner$train(task)$predict(task)
  expect_equal(unname(p$score()), 0)
})

test_that("hotstart", {
  task = tsk("iris")

  learner_1 = lrn("classif.xgboost", nrounds = 5L)
  learner_1$train(task)
  expect_equal(learner_1$state$param_vals$nrounds, 5L)
  expect_equal(xgboost::xgb.get.num.boosted.rounds(learner_1$model), 5L)

  hot = HotstartStack$new(learner_1)

  # learner 2 should be hotstarted from learner 1
  learner_2 = lrn("classif.xgboost", nrounds = 10L)
  learner_2$hotstart_stack = hot
  expect_equal(hot$start_cost(learner_2, task$hash), 5L)
  learner_2$train(task)
  expect_equal(xgboost::xgb.get.num.boosted.rounds(learner_2$model), 10L)
  expect_equal(learner_2$param_set$values$nrounds, 10L)
  expect_equal(learner_2$state$param_vals$nrounds, 10L)

  # learner 3 should not be hotstarted
  learner_3 = lrn("classif.xgboost", nrounds = 2L)
  learner_3$hotstart_stack = hot
  expect_equal(hot$start_cost(learner_3, task$hash), NA_real_)
  learner_3$train(task)
  expect_equal(xgboost::xgb.get.num.boosted.rounds(learner_3$model), 2L)
  expect_equal(learner_3$param_set$values$nrounds, 2L)
  expect_equal(learner_3$state$param_vals$nrounds, 2L)

  # learner 4 should be hotstarted from learner 1
  learner_4 = lrn("classif.xgboost", nrounds = 5L)
  learner_4$hotstart_stack = hot
  expect_equal(hot$start_cost(learner_4, task$hash), -1L)
  learner_4$train(task)
  expect_equal(xgboost::xgb.get.num.boosted.rounds(learner_4$model), 5L)
  expect_equal(learner_4$param_set$values$nrounds, 5L)
  expect_equal(learner_4$state$param_vals$nrounds, 5L)
})

test_that("validation and inner tuning", {
  task = tsk("spam")

  learner = lrn("classif.xgboost",
    nrounds = 10,
    early_stopping_rounds = 1,
    validate = 0.2
  )

  learner$train(task)
  expect_named(attributes(learner$model)$evaluation_log, c("iter", "test_logloss"))
  expect_list(learner$internal_valid_scores, types = "numeric")
  expect_equal(names(learner$internal_valid_scores), "logloss")

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
  expect_named(attributes(learner$model)$evaluation_log, c("iter", "test_logloss"))
  expect_list(learner$internal_valid_scores, types = "numeric")
  expect_equal(names(learner$internal_valid_scores), "logloss")

  learner = lrn("classif.xgboost",
    nrounds = to_tune(upper = 1000, internal = TRUE),
    validate = 0.2
  )
  s = learner$param_set$search_space()
  expect_error(learner$param_set$convert_internal_search_space(s), "Parameter")
  learner$param_set$set_values(early_stopping_rounds = 10)
  learner$param_set$disable_internal_tuning("nrounds")
  expect_equal(learner$param_set$values$early_stopping_rounds, NULL)

  learner = lrn("classif.xgboost",
    nrounds = 100,
    early_stopping_rounds = 5,
    validate = 0.3
  )
  learner$train(task)
  expect_equal(learner$internal_valid_scores$logloss,
    attributes(learner$model)$evaluation_log$test_logloss[learner$internal_tuned_values$nrounds])

  learner = lrn("classif.xgboost")
  learner$train(task)
  expect_true(is.null(learner$internal_valid_scores))
  expect_true(is.null(learner$internal_tuned_values))

  learner = lrn("classif.xgboost", validate = 0.3, nrounds = 10)
  learner$train(task)
  expect_equal(learner$internal_valid_scores$logloss, attributes(learner$model)$evaluation_log$test_logloss[10L])
  expect_true(is.null(learner$internal_tuned_values))

  learner$param_set$set_values(
    nrounds = to_tune(upper = 100, internal = TRUE),
    early_stopping_rounds = 10
  )
  expect_error(
    learner$param_set$convert_internal_search_space(learner$param_set$search_space()),
    "Parameter 'custom_metric' or 'eval_metric' must be set explicitly when using internal tuning."
  )
})

test_that("custom inner validation measure", {

  # internal measure
  task = tsk("sonar")

  learner = lrn("classif.xgboost",
    nrounds = 10,
    objective = "binary:logistic",
    validate = 0.2,
    early_stopping_rounds = 10,
    eval_metric = "error"
  )

  learner$train(task)

  expect_named(attributes(learner$model)$evaluation_log, c("iter", "test_error"))
  expect_list(learner$internal_valid_scores, types = "numeric")
  expect_equal(names(learner$internal_valid_scores), "error")

  # function
  task = tsk("sonar")

  learner = lrn("classif.xgboost",
    nrounds = 10,
    objective = "binary:logistic",
    validate = 0.2,
    early_stopping_rounds = 10,
    maximize = FALSE
  )

  learner$param_set$set_values(custom_metric = function(preds, dtrain) {
    labels = xgboost::getinfo(dtrain, "label")
    err = as.numeric(sum(labels != (preds > 0))) / length(labels)
    return(list(metric = "error_fun", value = err))
  })
  learner$train(task)

  expect_named(attributes(learner$model)$evaluation_log, c("iter", "test_error_fun"))
  expect_list(learner$internal_valid_scores, types = "numeric")
  expect_equal(names(learner$internal_valid_scores), "error_fun")


  # binary task and mlr3 measure binary response
  task = tsk("sonar")

  learner = lrn("classif.xgboost",
    nrounds = 10,
    validate = 0.2,
    custom_metric = msr("classif.ce")
  )

  learner$train(task)

  expect_named(attributes(learner$model)$evaluation_log, c("iter",  "test_classif.ce"))
  expect_numeric(attributes(learner$model)$evaluation_log$test_classif.ce, len = 10)
  expect_list(learner$internal_valid_scores, types = "numeric")
  expect_equal(names(learner$internal_valid_scores), "classif.ce")

  # binary task and mlr3 measure binary prob
  task = tsk("sonar")

  learner = lrn("classif.xgboost",
    nrounds = 10,
    validate = 0.2,
    early_stopping_rounds = 10,
    predict_type = "prob",
    custom_metric = msr("classif.logloss")
  )

  learner$train(task)

  expect_named(attributes(learner$model)$evaluation_log, c("iter",  "test_classif.logloss"))
  expect_numeric(attributes(learner$model)$evaluation_log$test_classif.logloss, len = 10)
  expect_list(learner$internal_valid_scores, types = "numeric")
  expect_equal(names(learner$internal_valid_scores), "classif.logloss")

  # binary task and mlr3 measure multiclass prob
  task = tsk("sonar")

  learner = lrn("classif.xgboost",
    nrounds = 10,
    validate = 0.2,
    early_stopping_rounds = 10,
    predict_type = "prob",
    custom_metric = msr("classif.auc")
  )

  learner$train(task)

  expect_named(attributes(learner$model)$evaluation_log, c("iter",  "test_classif.auc"))
  expect_numeric(attributes(learner$model)$evaluation_log$test_classif.auc, len = 10)
  expect_list(learner$internal_valid_scores, types = "numeric")
  expect_equal(names(learner$internal_valid_scores), "classif.auc")

  # multiclass task and mlr3 measure multiclass response
  task = tsk("iris")

  learner = lrn("classif.xgboost",
    nrounds = 10,
    validate = 0.2,
    early_stopping_rounds = 10,
    predict_type = "prob",
    custom_metric = msr("classif.ce")
  )

  learner$train(task)

  expect_named(attributes(learner$model)$evaluation_log, c("iter",  "test_classif.ce"))
  expect_numeric(attributes(learner$model)$evaluation_log$test_classif.ce, len = 10)
  expect_list(learner$internal_valid_scores, types = "numeric")
  expect_equal(names(learner$internal_valid_scores), "classif.ce")

  # multiclass task and mlr3 measure multiclass prob
  task = tsk("iris")

  learner = lrn("classif.xgboost",
    nrounds = 10,
    validate = 0.2,
    early_stopping_rounds = 10,
    predict_type = "prob",
    custom_metric = msr("classif.logloss")
  )

  learner$train(task)

  expect_named(attributes(learner$model)$evaluation_log, c("iter",  "test_classif.logloss"))
  expect_numeric(attributes(learner$model)$evaluation_log$test_classif.logloss, len = 10)
  expect_list(learner$internal_valid_scores, types = "numeric")
  expect_equal(names(learner$internal_valid_scores), "classif.logloss")
})

test_that("mlr3measures are equal to internal measures", {
  # response
  set.seed(1)
  task = tsk("sonar")

  learner = lrn("classif.xgboost",
    nrounds = 10,
    objective = "binary:logistic",
    validate = 0.2,
    early_stopping_rounds = 10
  )

  learner$param_set$set_values(custom_metric = msr("classif.ce"))
  learner$train(task)
  log_mlr3 = attributes(learner$model)$evaluation_log

  set.seed(1)
  learner$param_set$set_values(eval_metric = "error", custom_metric = NULL)
  learner$train(task)

  log_internal = attributes(learner$model)$evaluation_log

  expect_equal(log_mlr3$test_classif.ce, log_internal$test_error)

  # prob
  set.seed(1)
  task = tsk("sonar")

  learner = lrn("classif.xgboost",
    nrounds = 10,
    objective = "binary:logistic",
    validate = 0.2,
    early_stopping_rounds = 10
  )

  learner$param_set$set_values(custom_metric = msr("classif.auc"))
  learner$train(task)
  log_mlr3 = attributes(learner$model)$evaluation_log

  set.seed(1)
  learner$param_set$set_values(eval_metric = "auc", custom_metric = NULL)
  learner$train(task)

  log_internal = attributes(learner$model)$evaluation_log

  expect_equal(log_mlr3$test_classif.auc, log_internal$test_auc)

  # multiclass response
  set.seed(1)
  task = tsk("zoo")

  learner = lrn("classif.xgboost",
    nrounds = 10,
    objective = "multi:softmax",
    validate = 0.5,
    early_stopping_rounds = 10
  )

  learner$param_set$set_values(custom_metric = msr("classif.ce"))
  learner$train(task)
  log_mlr3 = attributes(learner$model)$evaluation_log

  set.seed(1)
  learner$param_set$set_values(eval_metric = "merror", custom_metric = NULL)
  learner$train(task)

  log_internal = attributes(learner$model)$evaluation_log

  expect_equal(log_mlr3$test_classif.ce, log_internal$test_merror)

  # multiclass prob
  set.seed(1)
  task = tsk("zoo")

  learner = lrn("classif.xgboost",
    nrounds = 10,
    objective = "multi:softprob",
    validate = 0.5,
    early_stopping_rounds = 10
  )

  learner$param_set$set_values(custom_metric = msr("classif.logloss"))
  learner$train(task)
  log_mlr3 = attributes(learner$model)$evaluation_log

  set.seed(1)
  learner$param_set$set_values(eval_metric = "mlogloss", custom_metric = NULL)
  learner$train(task)

  log_internal = attributes(learner$model)$evaluation_log

  expect_equal(round(log_mlr3$test_classif.logloss, 4), round(log_internal$test_mlogloss, 4))
})

test_that("base_margin (offset)", {
  # binary classification task
  task = tsk("sonar")

  # same task but with a numeric column acting as offset
  task_offset = task$clone()
  task_offset$set_col_roles(cols = "V42", roles = "offset")
  # same task but with a zero offset (base_margin)
  task_offset2 = task$clone()
  task_offset2$cbind(data.frame(zeros = rep(0, task$nrow)))
  task_offset2$set_col_roles(cols = "zeros", roles = "offset")

  # add predefined internal validation task
  part = partition(task, c(0.6, 0.2)) # 60% train, 20% test, 20% validate
  task$internal_valid_task = part$validation
  task_offset$internal_valid_task = part$validation
  task_offset2$internal_valid_task = part$validation

  l1 = lrn("classif.xgboost", objective = "binary:logistic", nrounds = 3, predict_type = "prob")
  l2 = l1$clone()
  l3 = l1$clone()
  l1$param_set$set_values(base_score = 0.5)
  l1$validate = "predefined"
  l2$validate = "predefined"
  l3$validate = "predefined"

  # train
  l1$train(task, part$train) # fixed global intercept (base_score = 0.5 <=> base_margin = 0)
  l2$train(task_offset, part$train) # with "V42" values as offset
  l3$train(task_offset2, part$train) # with base_margin = 0 as offset

  expect_true("V42" %in% xgboost::getinfo(l1$model, "feature_name"))
  expect_true("V42" %nin% xgboost::getinfo(l2$model, "feature_name"))
  expect_true("zeros" %nin% xgboost::getinfo(l3$model, "feature_name"))
  # different models: base_score = 0.5 vs "V42" base_margin
  expect_false(length(xgboost::xgb.dump(l1$model)) == length(xgboost::xgb.dump(l2$model)))
  # same models:  base_score = 0.5 <=> base_margin = 0 for logit
  # logit(p) = base_margin + f(x)
  # https://xgboost.readthedocs.io/en/stable/tutorials/intercept.html
  expect_equal(xgboost::xgb.dump(l1$model), xgboost::xgb.dump(l3$model))

  # predict (default: use_pred_offset = TRUE)
  p1 = l1$predict(task, part$test) # task has no offset, base_score = 0.5 is used
  p2 = l2$predict(task_offset, part$test) # "V42" offset is used
  p3 = l3$predict(task_offset2, part$test) # zero offset is used

  # different models + offsets => different predictions
  expect_false(all(p1$prob[, 1L] == p2$prob[, 1L]))
  expect_false(all(p2$prob[, 1L] == p3$prob[, 1L]))
  # same models + same offsets => same predictions
  expect_equal(p1$prob, p3$prob)

  # predict (default: use_pred_offset = FALSE)
  l1$param_set$set_values(use_pred_offset = FALSE)
  l2$param_set$set_values(use_pred_offset = FALSE)
  l3$param_set$set_values(use_pred_offset = FALSE)

  p11 = l1$predict(task, part$test)
  p22 = l2$predict(task_offset, part$test)
  p33 = l3$predict(task_offset2, part$test)
  expect_equal(p1$prob, p11$prob) # task has no offset, again base_score = 0.5 is used
  expect_false(all(p2$prob[, 1L] == p22$prob[, 1L])) # "V42" offset is not used
  # task was trained with zero offset, so even if no offset was applied during
  # prediction, we get exactly the same logit probabilities as before
  expect_equal(p3$prob, p33$prob)

  # multiclass task
  task = tsk("iris")

  # same task with multiclass offset
  data = task$data()
  set(data, j = "offset_setosa", value = runif(nrow(data)))
  set(data, j = "offset_virginica", value = runif(nrow(data)))
  set(data, j = "offset_versicolor", value = runif(nrow(data)))
  task_offset = as_task_classif(data, target = "Species")
  task_offset2 = task_offset$clone()
  task_offset$set_col_roles(cols = c("offset_setosa", "offset_virginica", "offset_versicolor"), roles = "offset")
  task_offset2$set_col_roles(cols = c("offset_setosa", "offset_versicolor"), roles = "offset")
  part = partition(task)

  l = lrn("classif.xgboost", nrounds = 3, predict_type = "prob")
  # xgboost doesn't work with less offset columns than the class labels
  expect_error(l$train(task_offset2), "2 offset columns are provided")
  p1 = l$train(task, part$train)$predict(task, part$test) # no offset
  p2 = l$train(task_offset, part$train)$predict(task_offset, part$test) # with offset

  expect_false(all(p1$prob == p2$prob))
})
