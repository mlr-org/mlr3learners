skip_on_os("solaris") # glmnet not working properly on solaris
skip_if_not_installed("glmnet")

test_that("autotest", {
  learner = mlr3::lrn("regr.glmnet", lambda = 0.1)
  expect_learner(learner)

  skip_on_os("solaris")
  result = run_autotest(learner, exclude = "feat_single")
  expect_true(result, info = result$error)
})

test_that("selected_features", {
  task = tsk("mtcars")
  learner = lrn("regr.glmnet")
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
  data = data.table(x = 1:50, z = runif(50), y = stats::rpois(50, lambda = 5))
  offset_col = runif(50)

  data_with_offset = cbind(data, offset_col)

  task = as_task_regr(x = data, target = "y")
  task_with_offset = as_task_regr(x = data_with_offset, target = "y")
  task_with_offset$set_col_roles(cols = "offset_col", roles = "offset")
  part = partition(task)

  # train learner
  learner = lrn("regr.glmnet", lambda = 0.01, family = "poisson")
  learner$train(task, part$train) # no offset
  learner_offset = lrn("regr.glmnet", lambda = 0.01, family = "poisson")
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
  # predictions are different
  expect_true(all(p1$response != p2$response))
  expect_equal(p2$response * exp(offset_col[part$test]), p1$response)

  # using a task with offset on a learner that didn't use offset during training
  # results in the same prediction: offset is completely ignored
  p3 = learner$predict(task, part$test)
  p4 = learner$predict(task_with_offset, part$test)
  expect_equal(p3$response, p4$response)
})
