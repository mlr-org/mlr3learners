test_that("re-populate dictionaries", {
  rm("classif.log_reg", envir = mlr_learners$items)
  expect_disjunct("classif.log_reg", mlr_learners$keys())
  register_mlr3()
  expect_subset("classif.log_reg", mlr_learners$keys())
})
