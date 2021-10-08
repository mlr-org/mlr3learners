test_that("classif.nnet", {
  learner = lrn("classif.nnet")
  fun = nnet::nnet.formula
  exclude = c(
    "formula", # handled via mlr3
    "data", # handled via mlr3
    "weights", # handled via mlr3
    "..." # not used
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "train")
  expect_true(ParamTest, info = paste0("\nMissing parameters:\n",
    paste0("- '", ParamTest$missing, "'", collapse = "\n")))
})

test_that("predict classif.nnet", {
  learner = lrn("classif.nnet")
  fun = nnet:::predict.nnet
  exclude = c(
    "object", # handled via mlr3
    "newdata", # handled via mlr3
    "type" # handled via mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "predict")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or actually defined in additional control function:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = "")))
})
