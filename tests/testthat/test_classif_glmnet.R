skip_on_os("solaris") # glmnet not working properly on solaris
skip_if_not_installed("glmnet")

test_that("autotest", {
  learner = mlr3::lrn("classif.glmnet", lambda = 0.1)
  expect_learner(learner)

  skip_on_os("solaris")
  result = run_autotest(learner, exclude = "feat_single")
  expect_true(result, info = result$error)
})

test_that("prob column reordering (#155)", {
  task = tsk("sonar")
  learner = mlr3::lrn("classif.glmnet", predict_type = "prob", lambda = 0.1)

  task$positive = "M"
  learner$train(task)
  p = learner$predict(task)
  expect_gt(p$score(msr("classif.acc")), 0.6)

  task$positive = "R"
  learner$train(task)
  p = learner$predict(task)
  expect_gt(p$score(msr("classif.acc")), 0.6)
})

test_that("same label ordering as in glm() / log_reg", {
  task = with_seed(123, tgen("2dnormals")$generate(100))
  for (pos in task$class_names) {
    task$positive = pos

    l1 = lrn("classif.log_reg")
    l2 = lrn("classif.glmnet", lambda = 0)
    l1$train(task)
    l2$train(task)

    expect_equal(
      sign(as.numeric(coef(l1$model))),
      sign(as.numeric(coef(l2$model))),
      info = sprintf("positive label = %s", pos)
    )
  }
})

test_that("selected_features", {
  task = tsk("iris")
  learner = lrn("classif.glmnet")
  learner$train(task)

  expect_equal(
    learner$selected_features(0),
    task$feature_names
  )

  expect_equal(
    learner$selected_features(Inf),
    character()
  )
})

test_that("offset works", {
  with_seed(7832, {
    data = data.table(x = 1:50, z = runif(50), y = stats::rbinom(50, size = 1, prob = 0.5))
    offset_col = runif(50)
    data_with_offset = cbind(data, offset_col)
  })

  task = as_task_classif(x = data, target = "y", positive = "1")
  task_with_offset = as_task_classif(x = data_with_offset, target = "y", positive = "1")
  task_with_offset$set_col_roles(cols = "offset_col", roles = "offset")
  part = partition(task)

  # train learner
  learner = lrn("classif.glmnet", predict_type = "prob", lambda = 0.01)
  learner$train(task, part$train) # no offset
  learner_offset = lrn("classif.glmnet", predict_type = "prob", lambda = 0.01)
  learner_offset$train(task_with_offset, part$train) # with offset (during training)

  # trained models are different
  expect_true(learner_offset$model$offset) # offset is used
  expect_false(learner$model$offset) # offset not used
  expect_false(all(learner$model$beta == learner_offset$model$beta))

  # predict on test set (offset is used by default)
  p1 = learner_offset$predict(task_with_offset, part$test)
  # no offset during predict
  learner_offset$param_set$set_values(.values = list(use_pred_offset = FALSE))
  p2 = learner_offset$predict(task_with_offset, part$test)
  prob_offset = p1$prob[, "1"]
  prob = p2$prob[, "1"]
  off = offset_col[part$test]
  # predictions are different
  expect_true(all(prob != prob_offset))
  # but connected via:
  expect_equal(log(prob_offset / (1 - prob_offset)), log(prob / (1 - prob)) + off)

  # using a task with offset on a learner that didn't use offset during training
  # results in the same prediction: offset is completely ignored
  p3 = learner$predict(task, part$test)
  p4 = learner$predict(task_with_offset, part$test)
  expect_equal(p3$prob, p4$prob)
})

test_that("relax = TRUE works", {
  task = tsk("sonar")
  train_rows = 1:150
  test_rows = 151:208

  learner = lrn("classif.glmnet", relax = TRUE, s = 0.03, predict_type = "prob")
  learner$train(task, train_rows)
  assert_class(learner$model, "relaxed")

  # gamma = 1 gives the original lasso fit
  # gamma = 0 gives the fully relaxed (unpenalized refit) model
  # intermediate gamma values mix the two
  p1 = learner$predict(task, test_rows)
  learner$param_set$set_values(gamma = 1) # original lasso fit
  p2 = learner$predict(task, test_rows)
  expect_equal(p1$response, p2$response)
  expect_equal(p1$prob, p2$prob)

  learner$param_set$set_values(gamma = 0.5)
  p3 = learner$predict(task, test_rows)
  expect_false(all(p2$prob[, "M"] == p3$prob[, "M"]))

  learner$param_set$set_values(gamma = 0)
  p4 = learner$predict(task, test_rows)
  expect_false(all(p2$prob[, "M"] == p4$prob[, "M"]))
})
