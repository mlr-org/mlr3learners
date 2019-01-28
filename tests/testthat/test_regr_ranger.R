context("regr.ranger")

test_that("regr.ranger test feature types", {
  lrn = LearnerRegrRanger$new()
  lrn$param_vals = list(keep.inbag = TRUE, num.trees = 30L)
  expect_autotest(lrn)
})

# TODO: make this an autotest?
test_that("importance", {
  task = TaskRegr$new("foo", as_data_backend(cbind(iris, data.frame(unimportant = runif(150)))), target = "Sepal.Length")
  learner = mlr_learners$get("regr.ranger")

  for (type in c("permutation", "impurity", "impurity_corrected")) {
    learner$param_vals = list(importance = "permutation")
    imp = Experiment$new(task, learner)$train()$learner$importance()
    expect_numeric(imp, min.len = 1L, any.missing = FALSE)
    expect_names(names(imp), subset.of = task$feature_names)
    expect_false(is.unsorted(rev(imp)))
    expect_true("unimportant" %nin% head(names(imp), 1L))
  }
})
