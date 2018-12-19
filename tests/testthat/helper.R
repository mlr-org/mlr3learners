library(checkmate)
library(mlr3)
lapply(list.files(system.file("testthat", package = "mlr3"), pattern = "^helper.*\\.[rR]", full.names = TRUE), source)

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
