library(mlr3learners)

test_that("classif.lda", {
  learner = lrn("classif.lda")
  fun = MASS::lda
  exclude = c(
    "x" # handled by mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "Missing parameters:",
    paste0("- '", ParamTest$missing, "'", collapse = "‚")))
})

test_that("predict classif.lda", {
  learner = lrn("classif.lda")
  fun = MASS:::predict.lda
  exclude = c(
    "object", # handled via mlr3
    "newdata", # handled via mlr3
    "method", # renamed to predict.method, see help page
    "prior" # renamed to predict.prior, see help page
  )

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "Missing parameters:",
    paste0("- '", ParamTest$missing, "'", collapse = "‚")))
})
