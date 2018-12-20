library(checkmate)
library(mlr3)
lapply(list.files(system.file("testthat", package = "mlr3"), pattern = "^helper.*\\.[rR]", full.names = TRUE), source)

getLearnersByType = function(type) {
	l = grep(paste0(type, "."), mlr_learners$ids(), value = TRUE)
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

testTrainPredict = function(task, learner) {
  e = Experiment$new(task, learner)
  e$train()
  expect_false(e$has_errors, info = id)
  e$predict()
  expect_class(e$prediction, "Prediction", info = id)
  e$score()
  expect_number(e$performance, info = id)
}


testClassifLearner = function(lrn, properties) {
  task = makeClassifTestTask(lrn, properties)
  id = lrn$id

  e = Experiment$new(task, lrn)
  e$train()
  expect_false(e$has_errors, info = id)
  e$predict()
  expect_class(e$prediction, "Prediction", info = id)
  e$score()
  expect_number(e$performance, info = id)
}



makeClassifTestTask = function(lrn, properties) {
  data = makeClassifTestData(lrn, properties)
  b = as_data_backend(data)
  if ("oneclass" %in% properties) target = "oneclass"
  if ("multiclass" %in% properties) target = "multiclass"
  task = TaskClassif$new(id = "id", backend = b, target = target)
  task
}


makeClassifTestData = function(lrn, properties) {
  # checkmate::assert_subset(property, c("twoclass", "multiclass"))
  # checkmate::assert_true(length(property) == 1)
  feature_types = lrn$feature_types
  feature_types = setdiff(feature_types, "ordered") #FIXME: delete this line, if #95 get fixed
  df = makeData(feature_types, properties = properties)
  if ("multiclass" %in% properties) df$twoclass = NULL
  if ("twoclass" %in% properties) df$multiclass = NULL
  df
}

makeData = function(feature_types, properties) {
  feat_logical = rep(c(TRUE, FALSE), each = 10)
  feat_integer = rep(c(1L, 0L), each = 10)
  feat_numeric = rep(c(1.1, 0.2), each = 10)
  feat_character = rep(c("one", "zero"), each = 10)
  feat_factor = as.factor(rep(c("one", "zero"), each = 10))
  feat_ordered = factor(rep(c("one", "two", "three", "four"), each = 5), ordered = TRUE,
    levels = c("one", "two", "three", "four"))

  target_twoclass = rep(c("M", "R"), each = 10)
  target_multiclass = rep(c("M", "R", "X", "Z"), each = 5)
  target_regr = rep(c(1, 2), each = 10)
  features = data.frame(logical = feat_logical, integer = feat_integer, numeric = feat_numeric,
    character = feat_character, factor = feat_factor,
    # ordered = feat_ordered,
    stringsAsFactors = FALSE)
  targets = data.frame(twoclass = target_twoclass, multiclass = target_multiclass, regr = target_regr)
  if ("missing" %in% properties)
    for (i in 1:ncol(features)) features[i, i] = NA
  df = data.frame(features, targets)
  df[, c(feature_types, intersect(properties, c("twoclass", "multiclass", "regr")))]
}


