library(mlr3learners)

test_that("classif.kknn", {
  learner = lrn("classif.kknn")
  fun = kknn::kknn
  exclude = c(
    "train", # handled via mlr3
    "test", # handled via mlr3
    "na.action", # handled via mlr3
    "formula", # handled via mlr3
    "contrasts", # causes lots of troubles just when setting the default,
    "store_model" # our parameter
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "train")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or param defined in additional control function not included in list of function definitions:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})
