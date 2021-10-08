library(mlr3learners)

test_that("classif.naive_bayes", {
  learner = lrn("classif.naive_bayes")
  fun = e1071::naiveBayes
  exclude = c(
    "x" # handled via mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "train")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or actually defined in additional control function:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})

test_that("predict classif.naive_bayes", {
  learner = lrn("classif.naive_bayes")
  fun = e1071:::predict.naiveBayes
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
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})
