library(mlr3learners)

test_that("classif.qda", {
  learner = lrn("classif.qda")
  fun = MASS::qda
  exclude = c(
    "x" # handled via mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "Missing parameters:",
    paste0("- '", ParamTest$missing, "'", collapse = ",")))
})

test_that("predict classif.qda", {
  learner = lrn("classif.lda")
  fun = MASS:::predict.qda
  exclude = c(
    "object", # handled via mlr3
    "newdata", # handled via mlr3
    "method", # handled via mlr3 arg predict.method
    "prior" # renamed to predict.prior, see help page
  )

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "Missing parameters:",
    paste0("- '", ParamTest$missing, "'", collapse = ",")))
})
