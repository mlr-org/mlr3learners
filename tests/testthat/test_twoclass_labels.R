context("test twoclass positive label")

setup({
  .mlr3learners.original_predict <<- .GlobalEnv$predict
  .GlobalEnv$predict = function(...) {
    raw_out = stats::predict(...)
    .mlr3learners.captured_out <<- raw_out
    raw_out
  }
})

teardown({
  .mlr3learners.captured_out <<- NULL
  if(is.null(.mlr3learners.original_predict)) {
    rm('predict', envir=.GlobalEnv)
  } else {
    .GlobalEnv$predict = .mlr3learners.original_predict
  }
  rm('.mlr3learners.original_predict', envir=.GlobalEnv)
  rm('.mlr3learners.captured_out', envir=.GlobalEnv)
})

test_that("classifiers respect positive label for binary tasks", {
  invisible()
  
  excluded_classifiers = c(
    'classif.debug', # randomly predicts a class, not relevant for testing
    'classif.featureless', # not relevant for testing
    'classif.kknn' # doesn't call predict method, train_internal doesn't modify labels in any way
  )
  classif_learner_names = grep('^classif\\.', names(mlr_learners$items), value=T)
  classif_learner_names = setdiff(classif_learner_names, excluded_classifiers)
  classif_learners = mlr_learners$mget(classif_learner_names)
  
  iris_binary = iris
  iris_binary$Species = as.factor(as.integer(iris$Species == 'setosa'))
  
  actuals = table(iris_binary$Species)
  expect_lt(actuals['1'], actuals['0'])
  
  task = mlr3::TaskClassif$new("iris_binary",
                               mlr3::as_data_backend(iris_binary),
                               target = "Species", positive = "1")
  
  for(learner in classif_learners) {
    test_that(paste0(learner$id, " respects positive label"), {
      # predictions = table(learner$train(task)$predict(task)$response)
      invisible(learner$train(task)$predict(task))
      captured_predict_out = .mlr3learners.captured_out
      if(inherits(captured_predict_out, 'factor')) {
        # For classifiers that return classes from predict (e.g. svm)
        predictions = table(captured_predict_out)
      } else if (inherits(captured_predict_out, 'numeric')) {
        # For classifiers that return scores from predict (e.g. xgboost)
        predictions = table(as.integer(captured_predict_out>0.5))
      } else if (inherits(captured_predict_out, 'list') && 'class' %in% names(captured_predict_out)) {
        # For classifiers that return a list with class as a proprety
        predictions = table(captured_predict_out$class)
      } else if (inherits(captured_predict_out, 'matrix') && ncol(captured_predict_out) == 1 && inherits(captured_predict_out[,1], 'character')) {
        predictions = table(captured_predict_out[,1])
      } else if (inherits(captured_predict_out, 'ranger.prediction')) {
        predictions = table(captured_predict_out$predictions)
      } else {
        fail(paste0('Could not understand predict output for ', learner$id))
      }
      
      expect_lt(predictions['1'], predictions['0'])
      rm('.mlr3learners.captured_out', envir=.GlobalEnv)
      captured_predict_out = NULL
    })
  }
})

