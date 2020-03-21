context("classif.glmnet")

skip_if_not_installed("glmnet")

test_that("autotest", {
  learner = mlr3::lrn("classif.glmnet")
  expect_learner(learner)

  skip_on_os("solaris")
  result = run_autotest(learner, exclude = "(feat_single|sanity)")
  expect_true(result, info = result$error)

  # FIXME: Should this go into the autotest?
  expect_error(learner$importance())
  tasks = generate_tasks(learner, N = 30L)[!grepl("feat_single", names(tasks))]
  tasks1 = tasks[!grepl("multiclass", names(tasks))]
  tasks2 = tasks1[!grepl("feat_single", names(tasks1))]
  for (task in tasks2) {
    expect_numeric(learner$train(task)$importance(task))
  }
})
