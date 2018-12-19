library(checkmate)
library(mlr3)
lapply(list.files(system.file("testthat", package = "mlr3"), pattern = "^helper.*\\.[rR]", full.names = TRUE), source)

getLearnersByType = function(type) {
	l = grep(paste0(type, "."), mlr_learners$keys(), value = TRUE)
  return(setdiff(l, "classif.debug"))
}

filterLearnerByProperties = function(x, properties = character()) {
  learners = setNames(lapply(x, mlr_learners$get), x)
  x[unlist(lapply(learners, function(x) all(properties %in% x$properties)))]
}

filterLearnerByPredictType = function(x, predict_types = character()) {
  learners = setNames(lapply(x, mlr_learners$get), x)
  x[unlist(lapply(learners, function(x) all(predict_types %in% x$predict_types)))]
}

filterLearnerByFeatureType = function(x, feature_types = character()) {
  learners = setNames(lapply(x, mlr_learners$get), x)
  x[unlist(lapply(learners, function(x) all(feature_types %in% x$feature_types)))]
}

characterToLearner = function(x) {
  setNames(lapply(x, mlr_learners$get), x)
}

testTrainPredict = function(id, task, learners) {
  e = Experiment$new(task, learners[[id]])
  e$train()
  expect_false(e$has_errors, info = id)
  e$predict()
  expect_class(e$prediction, "Prediction", info = id)
  e$score()
  expect_number(e$performance, info = id)
}
