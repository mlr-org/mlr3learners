library(mlr3learners)

test_that("classif.logreg", {
  learner = lrn("classif.log_reg")
  fun = stats::glm
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
    "se.fit" # not supported for log reg
  )

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "Missing parameters:",
    paste0("- '", ParamTest$missing, "'", collapse = ",")))
})

# example for checking a "control" function of a learner
test_that("classif.log_reg", {
  learner = lrn("classif.log_reg")
  fun = stats::glm.control
  exclude = c()

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "Missing parameters:",
    paste0("- '", ParamTest$missing, "'", collapse = ",")))
})

test_that("predict classif.log_reg", {
  learner = lrn("classif.log_reg")
  fun = stats::predict.glm
  exclude = c(
    "object", # handled via mlr3
    "newdata", # handled via mlr3
    "type", # handled via mlr3
    "terms", # handled via mlr3 type arg
    "na.action" # handled via mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "Missing parameters:",
    paste0("- '", ParamTest$missing, "'", collapse = ",")))
})
