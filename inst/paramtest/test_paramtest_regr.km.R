library(mlr3learners)

test_that("regr.km", {
  learner = lrn("regr.km")
  fun = DiceKriging::km
  exclude = c(
    "formula", # handled via mlr3
    "design", # handled via mlr3
    "response" # handled via mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "Missing parameters:",
    paste0("- '", ParamTest$missing, "'", collapse = ",")))
})

test_that("predict regr.km", {
  learner = lrn("regr.km")
  fun = DiceKriging::predict.km
  exclude = c(
    "object", # handled via mlr3
    "newdata" # handled via mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0(
    "Missing parameters:",
    paste0("- '", ParamTest$missing, "'", collapse = ",")))
})
