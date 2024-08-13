library(mlr3learners)

test_that("classif.multinom", {
  learner = lrn("classif.multinom")
  fun = list(nnet::multinom, nnet::nnet.default)
  exclude = c(
    "x", # handled via mlr3
    "y", # handled via mlr3
    "formula", # handled via mlr3
    "data", # handled via mlr3
    "weights", # handled via mlr3
    "use_weights", # handled by mlr3
    "subset", # handled via mlr3
    "na.action", # handled via mlr3
    "contrasts" # handled via mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "train")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or param defined in additional control function not included in list of function definitions:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})

# no extra args for predict.multinom
# test_that("predict classif.multinom", {
#   learner = lrn("classif.multinom")
#   fun = nnet:::predict.multinom
#   exclude = c(
#   )

#   ParamTest = run_paramtest(learner, fun, exclude)
#   expect_true(ParamTest, info = paste0(
#     "Missing parameters:",
#     paste0("- '", ParamTest$missing, "'", collapse = ",")))
# })
