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
