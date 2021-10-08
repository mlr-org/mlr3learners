library(mlr3learners)

test_that("classif.nnet", {
  learner = lrn("classif.nnet")
  fun = list(nnet::nnet.default, nnet::nnet.formula)
  exclude = c(
    "x", # handled via mlr3
    "y", # handled via mlr3
    "weights", # handled via mlr3
    "formula", # handled via mlr3
    "data", # handled via mlr3
    "entropy", # automatically set to TRUE if two-class task
    "softmax", # automatically set to TRUE if multi-class task
    "linout" # automatically set to FALSE if two-class and TRUE if multi-class
  )

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "Missing parameters:",
    paste0("- '", ParamTest$missing, "'", collapse = ",")))
})
