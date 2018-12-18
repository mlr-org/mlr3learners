context("classif learners")

test_that("learner construction", {
  classif.learners = grep("classif.", mlr_learners$keys(), value = TRUE)
  classif.learners = setdiff(classif.learners, "classif.debug")
  learners = setNames(lapply(classif.learners, mlr_learners$get), classif.learners)
  lapply(learners, expect_learner)
})

test_that("simple train/predict", {
  classif.learners = grep("classif.", mlr_learners$keys(), value = TRUE)
  classif.learners = setdiff(classif.learners, "classif.debug")
  learners = setNames(lapply(classif.learners, mlr_learners$get), classif.learners)

  task = mlr_tasks$get("iris")
  experiments = lapply(learners, function(x) Experiment$new(task, x))
  lapply(experiments, function(x) x$train())
  lapply(experiments, function(x) expect_false(x$has_errors))
  # FIXME: test models like expect_class(e$model, "ranger")
  lapply(experiments, function(x) x$predict())
  lapply(experiments, function(x) expect_class(x$prediction, "Prediction"))
  lapply(experiments, function(x) x$score())
  lapply(experiments, function(x) expect_number(x$performance))
})

test_that("simple train/predict with probs", {
  classif.learners = grep("classif.", mlr_learners$keys(), value = TRUE)
  classif.learners = setdiff(classif.learners, "classif.debug")
  learners = setNames(lapply(classif.learners, mlr_learners$get), classif.learners)

  pt = lapply(learners, function(x) x$predict_types)
  p_learners = setNames(lapply(classif.learners, mlr_learners$get), classif.learners)
  p_learners = p_learners[unlist(lapply(pt, function(x) "prob" %in% x))]

  lapply(p_learners, function(x) expect_equal(x$predict_type, "response"))

  task = mlr_tasks$get("iris")
  experiments = lapply(p_learners, function(x) Experiment$new(task, x))

  lapply(p_learners, function(x) x$predict_type = "prob")
  lapply(p_learners, function(x) expect_equal(x$predict_type, "prob"))

  lapply(experiments, function(x) x$train())
  lapply(experiments, function(x) expect_false(x$has_errors))
  # FIXME: test models like expect_class(e$model, "ranger")
  lapply(experiments, function(x) x$predict())
  lapply(experiments, function(x) expect_class(x$prediction, "Prediction"))
  lapply(experiments, function(x) x$score())
  lapply(experiments, function(x) expect_number(x$performance))
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
