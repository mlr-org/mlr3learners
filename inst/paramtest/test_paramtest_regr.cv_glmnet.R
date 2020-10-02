library(mlr3learners)

test_that("regr.cv_glmnet", {
  learner = lrn("regr.cv_glmnet")
  fun = glmnet::cv.glmnet
  exclude = c(
    "x", # handled by mlr3
    "y", # handled by mlr3
    "weights" # handled by mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "Missing parameters:",
    paste0("- '", ParamTest$missing, "'", collapse = ",")))
})

# example for checking a "control" function of a learner
test_that("regr.cv_glmnet", {
  learner = lrn("regr.cv_glmnet")
  fun = glmnet::glmnet.control
  exclude = c(
    "itrace", # supported via param trace.it
    "factory" # only used in scripts, no effect within mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "Missing parameters:",
    paste0("- '", ParamTest$missing, "'", collapse = ",")))
})

test_that("predict regr.cv_glmnet", {
  learner = lrn("regr.cv_glmnet")
  fun = glmnet:::predict.cv.glmnet
  exclude = c(
    "object", # handled via mlr3
    "newx" # handled via mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "Missing parameters:",
    paste0("- '", ParamTest$missing, "'", collapse = ",")))
})
