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
