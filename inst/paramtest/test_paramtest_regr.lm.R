library(mlr3learners)

test_that("regr.lm", {
  learner = lrn("regr.lm")
  fun = stats::lm
  exclude = c(
    "formula", # handled via mlr3
    "data", # handled via mlr3
    "weights", # handled via mlr3
    "na.action", # handled via mlr3
    "method", # handled via mlr3
    "subset", # handled via mlr3
    "contrasts" # handled via mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "train")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or actually defined in additional control function:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})

test_that("predict regr.lm", {
  learner = lrn("regr.lm")
  fun = stats::predict.lm
  exclude = c(
    "object", # handled via mlr3
    "newdata", # handled via mlr3
    "type", # handled via mlr3
    "na.action", # handled via mlr3
    "terms", # not supported by mlr3 learner
    "weights", # handled via mlr3
    "se.fit" # controlled via predict type
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "predict")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or actually defined in additional control function:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})
