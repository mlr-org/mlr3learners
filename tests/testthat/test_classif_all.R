context("classif learners")

test_that("learner construction", {
  learners_string = getLearnersByType("classif")
  learners = characterToLearner(learners_string)

  for (id in learners_string) expect_learner(learners[[id]])
})

test_that("simple train/predict multiclass", {
  learners_string = getLearnersByType("classif")
  learners_string = filterLearnerByProperties(learners_string, "multiclass")
  learners = characterToLearner(learners_string)

  task = mlr_tasks$get("iris")
  for (id in learners_string) {
    testTrainPredict(id, task, learners)
  }
})

test_that("simple train/predict twoclass", {
  learners_string = getLearnersByType("classif")
  learners_string = filterLearnerByProperties(learners_string, "twoclass")
  learners = characterToLearner(learners_string)

  task = mlr_tasks$get("sonar")
  for (id in learners_string) {
    testTrainPredict(id, task, learners)
  }
})

test_that("simple train/predict with probs multiclass", {
  learners_string = getLearnersByType("classif")
  learners_string = filterLearnerByProperties(learners_string, "multiclass")
  learners_string = filterLearnerByPredicttype(learners_string, "prob")
  learners = characterToLearner(learners_string)
  lapply(learners, function(x) x$predict_type = "prob")

  task = mlr_tasks$get("iris")
  for (id in learners_string) {
    testTrainPredict(id, task, learners)
  }
})

test_that("simple train/predict with probs twoclass", {
  learners_string = getLearnersByType("classif")
  learners_string = filterLearnerByProperties(learners_string, "twoclass")
  learners_string = filterLearnerByPredicttype(learners_string, "prob")
  learners = characterToLearner(learners_string)
  lapply(learners, function(x) x$predict_type = "prob")

  task = mlr_tasks$get("sonar")
  for (id in learners_string) {
    testTrainPredict(id, task, learners)
  }
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
