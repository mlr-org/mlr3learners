skip_if_not_installed("glmnet")
skip_on_os("solaris")

test_that("autotest", {
  learner = mlr3::lrn("classif.glmnet", lambda = .1)
  expect_learner(learner)

  skip_on_os("solaris")
  result = run_autotest(learner, exclude = "feat_single")
  expect_true(result, info = result$error)
})

test_that("prob column reordering (#155)", {
  task = tsk("sonar")
  learner = mlr3::lrn("classif.glmnet", predict_type = "prob", lambda = .1)

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
  task = tgen("2dnormals")$generate(50)
  for (pos in task$class_names) {
    task$positive = pos

    l1 = lrn("classif.log_reg")
    l2 = lrn("classif.glmnet", lambda = 0)
    l1$train(task)
    l2$train(task)

    expect_equal(sign(as.numeric(coef(l1$model))), sign(as.numeric(coef(l2$model))),
      info = sprintf("positive label = %s", pos))
  }
})
