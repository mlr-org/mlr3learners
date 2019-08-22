if (requireNamespace("testthat", quietly = TRUE)) {
  library(testthat)
  library(mlr3learners)
  test_check("mlr3learners")
}
