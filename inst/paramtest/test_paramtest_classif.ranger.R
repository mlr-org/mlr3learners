library(mlr3learners)

test_that("classif.ranger", {
  learner = lrn("classif.ranger")
  fun = ranger::ranger
  exclude = c(
    "formula", # handled via mlr3
    "y", # handled via mlr3
    "x", # handled via mlr3
    "data", # handled via mlr3
    "probability", # handled via mlr3
    "case.weights", # handled via mlr3
    "local.importance", # handled via importance() method
    "class.weights", # handled via mlr3
    "inbag", # handled via mlr3 stratification
    "quantreg", # regression only
    "dependent.variable.name", # handled via mlr3
    "status.variable.name", # handled via mlr3
    "classification" # handled via mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "Missing parameters:",
    paste0("- '", ParamTest$missing, "'", collapse = "‚")))
})

test_that("predict classif.ranger", {
  learner = lrn("classif.ranger")
  fun = ranger:::predict.ranger
  exclude = c(
    "quantiles", # required type not supported in mlr3
    "what", # required type (quantiles) not supported in mlr3
    "formula", # handled via mlr3
    "object", # handled via mlr3
    "data", # handled via mlr3
    "type" # handled via mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "Missing parameters:",
    paste0("- '", ParamTest$missing, "'", collapse = "‚")))
})