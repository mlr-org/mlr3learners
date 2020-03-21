context("regr.glmnet")

skip_if_not_installed("glmnet")

test_that("autotest", {
  learner = mlr3::lrn("regr.glmnet")
  expect_learner(learner)

  skip_on_os("solaris")
  result = run_autotest(learner, exclude = "feat_single")
  expect_true(result, info = result$error)


  # FIXME: Should this go into the autotest?
  expect_error(learner$importance())
  tasks = generate_tasks(learner, N = 30L)[!grepl("feat_single", names(tasks))]
  for (task in tasks) {
    expect_numeric(learner$train(task)$importance())
  }
})
