library(mlr3learners)

skip_on_os("solaris")

test_that("classif.glmnet", {
  learner = lrn("classif.glmnet")
  fun = list(glmnet::glmnet, glmnet::glmnet.control)
  exclude = c(
    "x", # handled by mlr3
    "y", # handled by mlr3
    "weights", # handled by mlr3
    "nfolds", # not used by learner
    "foldid", # not used by learner
    "type.measure", # only used by cv.glmnet
    "family", # handled by mlr3
    "itrace", # supported via param trace.it
    "factory", # only used in scripts, no effect within mlr3
    "offset", # handled by mlr3
    "sigma2.threshold" # added by mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "train")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or param defined in additional control function not included in list of function definitions:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})

test_that("predict classif.glmnet", {
  learner = lrn("classif.glmnet")
  fun = list(glmnet::predict.glmnet, glmnet::predict.relaxed)
  exclude = c(
    "object", # handled via mlr3
    "newx", # handled via mlr3
    "type", # handled via mlr3
    "newoffset", # handled via mlr3
    "use_pred_offset", # handled via mlr3
    "sigma2.threshold" # added by mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "predict")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or param defined in additional control function not included in list of function definitions:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})
