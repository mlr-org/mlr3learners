library(mlr3learners)

test_that("classif.svm", {
  learner = lrn("classif.svm")
  fun = e1071::svm
  exclude = c(
    "x" # handled by mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "Missing parameters:",
    paste0("- '", ParamTest$missing, "'", collapse = ",")))
})

test_that("classif.svm", {
  learner = lrn("classif.svm")
  fun = e1071:::predict.svm
  exclude = c(
    "object", # handled by mlr3
    "newdata", # handled by mlr3
    "probability", # handled by mlr3
    "na.action" # handled by mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "Missing parameters:",
    paste0("- '", ParamTest$missing, "'", collapse = ",")))
})
