skip_if_not_installed("ranger")

test_that("autotest", {
  learner = mlr3::lrn("classif.ranger")
  expect_learner(learner)
  learner$param_set$set_values(num.trees = 30L, importance = "impurity")
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})

test_that("hotstart", {
  task = tsk("iris")

  learner_1 = lrn("classif.ranger", num.trees = 1000L)
  learner_1$train(task)
  expect_equal(learner_1$state$param_vals$num.trees, 1000L)
  expect_equal(learner_1$model$num.trees, 1000L)

  hot = HotstartStack$new(learner_1)

  learner_2 = lrn("classif.ranger", num.trees = 500L)
  expect_equal(hot$start_cost(learner_2, task$hash), 0L)
  learner_2$train(task)
  expect_equal(learner_2$model$num.trees, 500L)
  expect_equal(learner_2$param_set$values$num.trees, 500L)
  expect_equal(learner_2$state$param_vals$num.trees, 500L)

  learner_3 = lrn("classif.ranger", num.trees = 1500L)
  expect_equal(hot$start_cost(learner_3, task$hash), NA_real_)

  learner_4 = lrn("classif.ranger", num.trees = 1000L)
  expect_equal(hot$start_cost(learner_4, task$hash), -1L)
  learner_4$train(task)
  expect_equal(learner_4$model$num.trees, 1000L)
  expect_equal(learner_4$param_set$values$num.trees, 1000L)
  expect_equal(learner_4$state$param_vals$num.trees, 1000L)
})

test_that("mtry.ratio", {
  task = mlr3::tsk("sonar")
  learner = mlr3::lrn("classif.ranger", mtry.ratio = 0.5)

  res = convert_ratio(learner$param_set$values, "mtry", "mtry.ratio", length(task$feature_names))
  expect_equal(
    res$mtry,
    30
  )
  expect_null(res$mtry.ratio)

  learner$train(task)
  expect_equal(
    learner$model$mtry,
    30
  )
})

test_that("convert_ratio", {
  task = tsk("sonar")
  learner = lrn("classif.ranger", num.trees = 5, mtry.ratio = 0.5)
  expect_equal(learner$train(task)$model$mtry, 30)

  learner$param_set$values$mtry.ratio = 0
  expect_equal(learner$train(task)$model$mtry, 1)

  learner$param_set$values$mtry.ratio = 1
  expect_equal(learner$train(task)$model$mtry, 60)

  learner$param_set$values$mtry = 10
  expect_error(learner$train(task), "exclusive")

  learner$param_set$values$mtry.ratio = NULL
  expect_equal(learner$train(task)$model$mtry, 10)

  learner$param_set$values$mtry = 10
  expect_equal(learner$train(task)$model$mtry, 10)
})

test_that("default_values", {
  learner = lrn("classif.ranger")
  search_space = ps(
    replace = p_lgl(),
    sample.fraction = p_dbl(0.1, 1),
    num.trees = p_int(1, 2000),
    mtry.ratio = p_dbl(0, 1)
  )
  task = tsk("pima")

  values = default_values(learner, search_space, task)
  expect_names(names(values), permutation.of =  c("replace", "sample.fraction", "num.trees", "mtry.ratio"))
})

test_that("selected_features", {
  learner = lrn("classif.ranger")
  expect_error(learner$selected_features())

  task = tsk("iris")
  learner$train(task)
  expect_set_equal(learner$selected_features(), c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width"))
})
