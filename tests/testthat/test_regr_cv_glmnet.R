skip_on_os("solaris") # glmnet not working properly on solaris
skip_if_not_installed("glmnet")

options(warnPartialMatchArgs = FALSE)
on.exit(options(warnPartialMatchArgs = TRUE))

test_that("autotest", {
  learner = mlr3::lrn("regr.cv_glmnet")
  expect_learner(learner)

  skip_on_os("solaris")
  result = run_autotest(learner, exclude = "feat_single")
  expect_true(result, info = result$error)
})

test_that("selected_features", {
  task = tsk("mtcars")
  learner = lrn("regr.cv_glmnet")
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

test_that("relax = TRUE works", {
  task = tsk("mtcars")
  train_rows = 1:25
  test_rows = 26:32

  # by default, fits for gamma in (0, 0.25, 0.5, 0.75, 1)
  learner = lrn("regr.cv_glmnet", relax = TRUE, nfolds = 5)
  # relaxed fit produces warnings about convergence, but this is expected
  learner$train(task, train_rows)
  assert_class(learner$model, "cv.relaxed")
  expect_equal(learner$model$relaxed$gamma, c(0, 0.25, 0.5, 0.75, 1))
  # fit custom gamma values
  gammas = seq(0, 1, length.out = 8)
  learner$param_set$set_values(gamma = gammas)
  learner$train(task, train_rows)
  expect_equal(learner$model$relaxed$gamma, gammas)

  p1 = learner$predict(task, test_rows)
  # default used gamma for prediction, should not change anything
  learner$param_set$set_values(predict.gamma = "gamma.1se")
  p2 = learner$predict(task, test_rows)
  expect_equal(p1$response, p2$response)

  # numeric gamma value should also work and give different predictions
  learner$param_set$set_values(predict.gamma = 0.33)
  p3 = learner$predict(task, test_rows)
  expect_false(all(p1$response == p3$response))
})
