library(mlr3learners)

test_that("classif.glmnet", {
  learner = lrn("classif.glmnet")
  fun = glmnet::cv.glmnet
  exclude = c(
    "x", # handled by mlr3
    "y", # handled by mlr3
    "weights" # handled by mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "Missing parameters:",
    paste0("- '", ParamTest$missing, "'", collapse = "‚")))
})

# example for checking a "control" function of a learner
test_that("classif.glmnet", {
  learner = lrn("classif.glmnet")
  fun = glmnet::glmnet.control
  exclude = c(
    "itrace", # supported via param trace.it
    "factory" # only used in scripts, no effect within mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "Missing parameters:",
    paste0("- '", ParamTest$missing, "'", collapse = "‚")))
})

test_that("predict classif.glmnet", {
  learner = lrn("classif.glmnet")
  fun = glmnet::predict.glmnet
  exclude = c(
    "object", # handled via mlr3
    "newx", # handled via mlr3
    "type" # handled via mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "Missing parameters:",
    paste0("- '", ParamTest$missing, "'", collapse = "‚")))
})
