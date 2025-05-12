skip_if_not_installed("nnet")

test_that("autotest", {
  learner = mlr3::lrn("classif.multinom")
  expect_learner(learner)
  capture.output({result = run_autotest(learner)})
  expect_true(result, info = result$error)
})


test_that("predict single obs", { # https://github.com/mlr-org/mlr3/issues/883
  task = tsk("iris")
  lrn = lrn("classif.multinom", predict_type = "prob")
  capture.output({lrn$train(task)})

  newdata = iris[1, ]
  expect_prediction(lrn$predict_newdata(newdata))
})
