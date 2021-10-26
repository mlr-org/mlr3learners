library(mlr3learners)

test_that("classif.qda", {
  learner = lrn("classif.qda")
  fun = list(MASS::qda, MASS:::qda.default)
  exclude = c(
    "x", # handled via mlr3
    "grouping", # handled via mlr3
    "CV" # handled via mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "train")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or param defined in additional control function not included in list of function definitions:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})

test_that("predict classif.qda", {
  learner = lrn("classif.qda")
  fun = MASS:::predict.qda
  exclude = c(
    "object", # handled via mlr3
    "newdata", # handled via mlr3
    "method", # renamed to predict.method, see help page
    "predict.method", # renamed from method, see help page
    "prior", # renamed from predict.prior, see help page
    "predict.prior" # renamed from prior, see help page
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "predict")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or param defined in additional control function not included in list of function definitions:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})
