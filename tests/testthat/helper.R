library(checkmate)
library(mlr3)
lapply(list.files(system.file("testthat", package = "mlr3"), pattern = "^helper.*\\.[rR]", full.names = TRUE), source)

filterLearnerByProperties = function(x, properties = character()) {
  learners = setNames(lapply(x, mlr_learners$get), x)
  x[unlist(lapply(learners, function(x) properties %in% x$properties))]
}

filterLearnerByPredicttype = function(x, predict_type = character()) {
  learners = setNames(lapply(x, mlr_learners$get), x)
  x[unlist(lapply(learners, function(x) predict_type %in% x$predict_types))]
}

characterToLearner = function(x) {
  setNames(lapply(x, mlr_learners$get), x)
}
