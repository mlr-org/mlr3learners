skip_on_os("solaris") # glmnet not working properly on solaris
skip_if_not_installed("glmnet")

test_that("autotest", {
  learner = mlr3::lrn("classif.cv_glmnet")
  expect_learner(learner)

  skip_on_os("solaris")
  result = run_autotest(learner, exclude = "feat_single")
  expect_true(result, info = result$error)


  learner = result$learner
  learner$importance()
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

    expect_equal(sign(as.numeric(coef(l1$model))), sign(as.numeric(coef(l2$model, s = 0))),
      info = sprintf("positive label = %s", pos))
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
