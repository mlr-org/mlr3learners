context("regr.xgboost")

test_that("regr.xgboost test feature types", {
  lrn = LearnerRegrXgboost$new()
  lrn$param_vals = insert_named(lrn$param_vals, list(nrounds = 5L))
  expect_autotest(lrn)
})

# TODO: make this an autotest?
test_that("importance", {
  task = TaskRegr$new("foo", as_data_backend(cbind(iris, data.frame(unimportant = runif(150)))), target = "Sepal.Length")
  learner = mlr_learners$get("regr.xgboost")
  learner$param_vals = insert_named(learner$param_vals, list(nrounds = 20))

  imp = Experiment$new(task, learner)$train()$learner$importance()
  expect_numeric(imp, min.len = 1L, any.missing = FALSE)
  expect_names(names(imp), subset.of = task$feature_names)
  expect_false(is.unsorted(rev(imp)))
  expect_true("unimportant" %nin% head(names(imp), 1L))
})
