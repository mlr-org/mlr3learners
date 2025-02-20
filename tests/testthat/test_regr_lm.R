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
  data = data.frame(x = 1:10, y = stats::rpois(10, lambda = 5))
  offset_col = runif(10)
  data_with_offset = cbind(data, offset_col)

  task = as_task_regr(x = data_with_offset, target = "y")
  task$set_col_roles(cols = "offset_col", roles = "offset")
  part = partition(task)

  # train task using offset
  l = lrn("regr.lm")
  l$train(task, part$train)

  # manually train with offset
  model_with_offset = lm(y ~ ., data = data[part$train, ], offset = offset_col[part$train])
  # model with no offset for comparison
  model = lm(y ~ ., data = data[part$train, ])

  # model with offset has different coefficients
  expect_false(all(l$model$coefficients == model$coefficients))
  expect_equal(l$model$coefficients, model_with_offset$coefficients)

  # predict - fails
  # l$predict(task, part$test)
  predict(model_with_offset, newdata = data_with_offset[1:2, ])
  predict(model_with_offset, newdata = cbind(data[1:2, ], offset_col = 0))
})
