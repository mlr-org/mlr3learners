library(mlr3learners)

test_that("classif.multinom", {
  learner = lrn("classif.multinom")
  fun = nnet::multinom
  exclude = c(
    "formula", # handled via mlr3
    "data", # handled via mlr3
    "weights", # handled via mlr3
    "subset", # handled via mlr3
    "na.action", # handled via mlr3
    "contrasts" # handled via mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "Missing parameters:",
    paste0("- '", ParamTest$missing, "'", collapse = "‚")))
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
#     paste0("- '", ParamTest$missing, "'", collapse = "‚")))
# })
