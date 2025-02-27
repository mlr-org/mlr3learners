library(mlr3learners)

test_that("classif.logreg", {
  learner = lrn("classif.log_reg")
  fun = list(stats::glm, stats::glm.control)
  exclude = c(
    "x", # handled by mlr3
    "formula", # handled by mlr3
    "family", # handled by mlr3
    "data", # handled by mlr3
    "weights", # handled by mlr3
    "subset", # handled by mlr3
    "na.action", # handled by mlr3
    "y", # handled by mlr3
    "method", # we always use glm()
    "control", # handled by glm.control
    "contrasts", # causes lots of troubles just when setting the default
    "offset" # handled via mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "train")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or param defined in additional control function not included in list of function definitions:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})

test_that("predict classif.log_reg", {
  learner = lrn("classif.log_reg")
  fun = stats::predict.glm
  exclude = c(
    "object", # handled via mlr3
    "newdata", # handled via mlr3
    "type", # handled via mlr3
    "terms", # handled via mlr3 type arg
    "na.action", # handled via mlr3
    "se.fit", # not supported for log reg
    "use_pred_offset" # handled via mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "predict")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or param defined in additional control function not included in list of function definitions:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
  )
})
