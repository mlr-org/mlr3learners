library(mlr3learners)

test_that("regr.kknn", {
  learner = lrn("regr.kknn")
  fun = kknn::kknn
  exclude = c(
    "train", # handled via mlr3
    "test", # handled via mlr3
    "na.action", # handled via mlr3
    "formula", # handled via mlr3
    "contrasts" # causes lots of troubles just when setting the default
  )

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "Missing parameters:",
    paste0("- '", ParamTest$missing, "'", collapse = "‚")))
})
