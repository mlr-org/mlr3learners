context("classif.ranger")

test_that("classif.ranger registration", {
  expect_subset("classif.ranger", mlr_learners$keys())
})

test_that("classif.ranger construction", {
  learner = LearnerClassifRanger$new()
  expect_learner(learner)
})

test_that("simple train/predict", {
  # FIXME: we want this automated

  learner = LearnerClassifRanger$new()
  task = mlr_tasks$get("iris")
  e = Experiment$new(task, learner)
  e$train()
  expect_false(e$has_errors)
  expect_class(e$model, "ranger")
  e$predict()
  expect_class(e$prediction, "Prediction")
  e$score()
  expect_number(e$performance)
})

test_that("simple train/predict with probs", {
  # FIXME: we want this automated

  learner = LearnerClassifRanger$new()
  learner$predict_type = "prob"

  task = mlr_tasks$get("iris")
  e = Experiment$new(task, learner)
  e$train()
  expect_false(e$has_errors)
  expect_class(e$model, "ranger")
  e$predict()
  expect_class(e$prediction, "Prediction")
  e$score()
  expect_number(e$performance)
})

test_that("extract importance", {
  # FIXME: we want this automated

  learner = LearnerClassifRanger$new()
  learner$param_vals = list(importance = "impurity")

  task = mlr_tasks$get("iris")
  e = Experiment$new(task, learner)
  e$train()

  tab = e$learner$importance()
  expect_data_table(tab, ncol = 2L, nrow = task$ncol - 1L)
  expect_set_equal(tab$name, task$feature_names)
  expect_numeric(rev(tab$value), any.missing = FALSE, sorted = TRUE)
})
