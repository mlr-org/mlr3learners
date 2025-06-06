test_that("autotest", {
  learner = mlr3::lrn("classif.log_reg")
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})

test_that("class labels are correctly encoded", {
  task = tsk("sonar")
  learner = lrn("classif.log_reg")

  task$positive = "M"
  suppressWarnings(learner$train(task))
  expect_equal(unname(learner$model$y), rep(0:1, c(97, 111)))

  task$positive = "R"
  suppressWarnings(learner$train(task))
  expect_equal(unname(learner$model$y), rep(1:0, c(97, 111)))
})

test_that("offset works", {
  with_seed(7832, {
    data = data.table(x = 1:30, y = stats::rbinom(30, size = 1, prob = 0.5))
    offset_col = runif(30)
    data_with_offset = cbind(data, offset_col)
  })

  task = as_task_classif(x = data, target = "y", positive = "1")
  task_with_offset = as_task_classif(x = data_with_offset, target = "y", positive = "1")
  task_with_offset$set_col_roles(cols = "offset_col", roles = "offset")
  part = partition(task)

  # train learner
  learner = lrn("classif.log_reg", predict_type = "prob")
  learner$train(task, part$train) # no offset
  learner_offset = lrn("classif.log_reg", predict_type = "prob")
  learner_offset$train(task_with_offset, part$train) # with offset (during training)

  # trained models are different
  expect_numeric(learner_offset$model$offset) # offset is used
  expect_null(learner$model$offset) # offset not used
  expect_false(all(learner$model$coefficients == learner_offset$model$coefficients))

  # check: we get same trained model manually using the formula interface
  model = stats::glm(y ~ x + offset(offset_col), family = "binomial",
                     data = data_with_offset, subset = part$train)
  expect_equal(model$coefficients, learner_offset$model$coefficients)

  # predict on test set (offset is used by default)
  p1 = learner_offset$predict(task_with_offset, part$test)
  # same thing manually
  res = unname(predict(model, type = "response",
                       newdata = data_with_offset[part$test, ]))
  prob_offset = p1$prob[, "1"]
  expect_equal(prob_offset, res)
  # no offset during predict
  learner_offset$param_set$set_values(.values = list(use_pred_offset = FALSE))
  p2 = learner_offset$predict(task_with_offset, part$test)
  prob = p2$prob[, "1"]
  off = offset_col[part$test]
  # predictions are different
  expect_true(all(prob_offset != prob))
  # but connected via:
  expect_equal(log(prob_offset/(1 - prob_offset)), log(prob/(1 - prob)) + off)

  # verify predictions manually
  res = unname(predict(model, type = "response",
                       newdata = cbind(data[part$test, ], offset_col = 0)))
  expect_equal(prob, res)

  # using a task with offset on a learner that didn't use offset during training
  # results in the same prediction: offset is completely ignored
  p3 = learner$predict(task, part$test)
  p4 = learner$predict(task_with_offset, part$test)
  expect_equal(p3$prob, p4$prob)
})
