skip_if_not_installed("e1071")

test_that("autotest", {
  learner = mlr3::lrn("classif.svm")
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})

test_that("default_values", {
  learner = lrn("classif.svm")
  search_space = ps(
    cost = p_dbl(1e-2, 100),
    gamma = p_dbl(0, 1)
  )
  task = tsk("pima")

  values = default_values(learner, search_space, task)
  expect_names(names(values), permutation.of =  c("cost", "gamma"))
})
