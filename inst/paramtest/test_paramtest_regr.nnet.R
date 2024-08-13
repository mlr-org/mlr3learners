library(mlr3learners)

test_that("regr.nnet", {
  learner = lrn("regr.nnet")
  fun = list(nnet::nnet.default, nnet::nnet.formula)
  exclude = c(
    "x", # handled via mlr3
    "y", # handled via mlr3
    "weights", # handled via mlr3
    "use_weights", # handled by mlr3
    "data", # handled via mlr3
    "linout", # automatically set to TRUE, since it's the regression learner
    "entropy", # mutually exclusive with linout
    "softmax" # mutually exclusive with linout
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "train")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or param defined in additional control function not included in list of function definitions:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})
