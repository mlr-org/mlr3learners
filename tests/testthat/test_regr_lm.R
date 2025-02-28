test_that("autotest", {
  learner = mlr3::lrn("regr.lm")
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})

test_that("contrasts", {
  task = tsk("mtcars")
  learner = mlr3::lrn("regr.lm")

  learner$train(task)
  coefs1 = coef(learner$model)
  names(coefs1)

  opts = list(contrasts = c(ordered = "contr.poly", unordered = "contr.poly"))
  old_opts = options(opts)
  on.exit(options(old_opts))

  learner$train(task)
  coefs2 = coef(learner$model)

  expect_setequal(names(coefs1), names(coefs2))
})

test_that("offset works", {
  data = data.table(x = 1:10, y = stats::rpois(10, lambda = 5))
  offset_col = runif(10)
  data_with_offset = cbind(data, offset_col)

  task = as_task_regr(x = data, target = "y")
  task_with_offset = as_task_regr(x = data_with_offset, target = "y")
  task_with_offset$set_col_roles(cols = "offset_col", roles = "offset")
  part = partition(task)

  # train learner
  learner = lrn("regr.lm")
  learner$train(task, part$train) # no offset
  learner_offset = lrn("regr.lm")
  learner_offset$train(task_with_offset, part$train) # with offset (during training)

  # trained models are different
  expect_numeric(learner_offset$model$offset) # offset is used
  expect_null(learner$model$offset) # offset not used
  expect_false(all(learner$model$coefficients == learner_offset$model$coefficients))

  # check: we get same trained model manually using the formula interface
  model = stats::lm(y ~ x + offset(offset_col), data = data_with_offset, subset = part$train)
  expect_equal(model$coefficients, learner_offset$model$coefficients)

  # predict on test set (offset is used by default)
  p1 = learner_offset$predict(task_with_offset, part$test)
  # same thing manually
  res = unname(predict(model, newdata = data_with_offset[part$test, ]))
  expect_equal(p1$response, res)
  # use offset during predict
  learner_offset$param_set$set_values(.values = list(use_pred_offset = FALSE))
  p2 = learner_offset$predict(task_with_offset, part$test)
  # predictions are different
  expect_true(all(p1$response != p2$response))
  # offset was added to the response
  expect_equal(p2$response + offset_col[part$test], p1$response)
  # verify predictions manually
  res = unname(predict(model, newdata = cbind(data[part$test, ], offset_col = 0)))
  expect_equal(p2$response, res)

  # using a task with offset on a learner that didn't use offset during training
  # results in the same prediction: offset is completely ignored
  p3 = learner$predict(task, part$test)
  p4 = learner$predict(task_with_offset, part$test)
  expect_equal(p3$response, p4$response)
})
