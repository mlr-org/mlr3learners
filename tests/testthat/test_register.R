context("populate dictionaries")

test_that("re-populate dictionaries", {
  rm("classif.ranger", envir = mlr_learners$items)
  expect_disjunct("classif.ranger", mlr_learners$keys())
  register_mlr3()
  expect_subset("classif.ranger", mlr_learners$keys())
})
