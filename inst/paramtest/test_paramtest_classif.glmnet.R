library(mlr3learners)

test_that("classif.glmnet", {
  learner <- lrn("classif.glmnet")
  fun <- glmnet::cv.glmnet
  exclude <- c(
    "x", # handled by mlr3
    "y", # handled by mlr3
    "weights" # handled by mlr3
  )

  ParamTest <- run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "
Missing parameters:
",
    paste0("- '", ParamTest$missing, "'", collapse = "
")
  ))
})

# example for checking a "control" function of a learner
test_that("classif.glmnet", {
  learner <- lrn("classif.glmnet")
  fun <- glmnet::glmnet_control
  exclude <- c()

  ParamTest <- run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters:\n",
    paste0("- '", ParamTest$missing, "'", collapse = "\n")
  ))
})
