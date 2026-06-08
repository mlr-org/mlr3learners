skip_on_os("solaris") # glmnet not working properly on solaris
skip_if_not_installed("glmnet")

options(warnPartialMatchArgs = FALSE)
on.exit(options(warnPartialMatchArgs = TRUE))

test_that("autotest", {
  learner = mlr3::lrn("classif.cv_glmnet")
  expect_learner(learner)

  skip_on_os("solaris")
  result = run_autotest(learner, exclude = "feat_single", N = 100L)
  expect_true(result, info = result$error)
})

test_that("prob column reordering (#155)", {
  task = tsk("sonar")
  learner = mlr3::lrn("classif.cv_glmnet", predict_type = "prob")

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
    l2 = lrn("classif.cv_glmnet")
    l1$train(task)
    l2$train(task)

    expect_equal(
      sign(as.numeric(coef(l1$model))),
      sign(as.numeric(coef(l2$model, s = 0))),
      info = sprintf("positive label = %s", pos)
    )
  }
})

test_that("selected_features", {
  task = tsk("iris")
  learner = lrn("classif.cv_glmnet")
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
  task = tsk("iris")
  part = partition(task)
  train_rows = part$train
  test_rows = part$test

  # by default, fits for gamma in (0, 0.25, 0.5, 0.75, 1)
  learner = lrn("classif.cv_glmnet", relax = TRUE, predict_type = "prob")
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
  expect_equal(p1$prob[, "setosa"], p2$prob[, "setosa"])

  # change gamma, should change predictions
  if (learner$model$relaxed$gamma.min != learner$model$relaxed$gamma.1se) {
    learner$param_set$set_values(predict.gamma = "gamma.min")
    p3 = learner$predict(task, test_rows)
    expect_false(all(p1$prob[, "setosa"] == p3$prob[, "setosa"]))
  }

  # numeric gamma value should also work and give different predictions
  learner$param_set$set_values(predict.gamma = 0.33)
  p4 = learner$predict(task, test_rows)
  expect_false(all(p1$prob[, "setosa"] == p4$prob[, "setosa"]))
})
