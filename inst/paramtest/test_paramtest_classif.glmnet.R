library(mlr3learners)

skip_on_os("solaris")

test_that("classif.glmnet", {
  learner = lrn("classif.glmnet")
  fun = list(glmnet::glmnet, glmnet::relax.glmnet, glmnet::glmnet.control)
  exclude = c(
    "x", # handled by mlr3
    "y", # handled by mlr3
    "family", # handled by mlr3
    "weights", # handled by mlr3
    "offset", # handled by mlr3
    "fit", # fit object is passed on to relax.glmnet()
    "check.args", # default TRUE is good for mlr3, no need to expose
    "type.gaussian", # not applicable for classification
    "standardize.response", # not applicable for classification
    "itrace", # supported via param trace.it
    "factory", # only used in scripts, no effect within mlr3
    "control", # individual control params are set directly
    "cox.ties" # only used for cox models
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "train")
  expect_true(
    ParamTest,
    info = paste0(
      "\nMissing parameters in mlr3 param set:\n",
      paste0("- ", ParamTest$missing, "\n", collapse = ""),
      "\nOutdated param or param defined in additional control function not in list of function definitions:\n",
      paste0("- ", ParamTest$extra, "\n", collapse = "")
    )
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
    "use_pred_offset" # for using the offset during prediction
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "predict")
  expect_true(
    ParamTest,
    info = paste0(
      "\nMissing parameters in mlr3 param set:\n",
      paste0("- ", ParamTest$missing, "\n", collapse = ""),
      "\nOutdated param or param defined in additional control function not in list of function definitions:\n",
      paste0("- ", ParamTest$extra, "\n", collapse = "")
    )
  )
})
