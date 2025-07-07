skip_if_not_installed("ranger")




test_that("autotest", {
  learner = mlr3::lrn("regr.ranger", num.trees = 100, importance = "impurity")
  expect_learner(learner)
  result = run_autotest(learner, N = 50L)
  expect_true(result, info = result$error)
})

test_that("hotstart", {
  task = tsk("mtcars")

  learner_1 = lrn("regr.ranger", num.trees = 1000L)
  learner_1$train(task)
  expect_equal(learner_1$state$param_vals$num.trees, 1000L)
  expect_equal(learner_1$model$num.trees, 1000L)

  hot = HotstartStack$new(learner_1)

  learner_2 = lrn("regr.ranger", num.trees = 500L)
  expect_equal(hot$start_cost(learner_2, task$hash), 0L)
  learner_2$train(task)
  expect_equal(learner_2$model$num.trees, 500L)
  expect_equal(learner_2$param_set$values$num.trees, 500L)
  expect_equal(learner_2$state$param_vals$num.trees, 500L)

  learner_3 = lrn("regr.ranger", num.trees = 1500L)
  expect_equal(hot$start_cost(learner_3, task$hash), NA_real_)

  learner_4 = lrn("regr.ranger", num.trees = 1000L)
  expect_equal(hot$start_cost(learner_4, task$hash), -1L)
  learner_4$train(task)
  expect_equal(learner_4$model$num.trees, 1000L)
  expect_equal(learner_4$param_set$values$num.trees, 1000L)
  expect_equal(learner_4$state$param_vals$num.trees, 1000L)
})

test_that("mtry.ratio", {
  task = mlr3::tsk("mtcars")
  learner = mlr3::lrn("regr.ranger", mtry.ratio = 0.5)

  res = convert_ratio(learner$param_set$values, "mtry", "mtry.ratio", length(task$feature_names))
  expect_equal(
    res$mtry,
    5
  )
  expect_null(res$mtry.ratio)

  learner$train(task)
  expect_equal(
    learner$model$mtry,
    5
  )
})

test_that("default_values", {
  learner = lrn("regr.ranger")
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

test_that("quantile prediction", {
  learner = mlr3::lrn("regr.ranger",
    num.trees = 100,
    predict_type = "quantiles",
    quantiles = c(0.1, 0.5, 0.9),
    quantile_response = 0.5)
  task = tsk("mtcars")

  learner$train(task)
  pred = learner$predict(task)

  expect_matrix(pred$quantiles, ncol = 3L)
  expect_true(!any(apply(pred$quantiles, 1L, is.unsorted)))
  expect_equal(pred$response, pred$quantiles[, 2L])

  tab = as.data.table(pred)
  expect_names(names(tab), identical.to = c("row_ids", "truth", "q0.1", "q0.5", "q0.9", "response"))
  expect_equal(tab$response, tab$q0.5)
})

test_that("selected_features", {
  learner = lrn("regr.ranger")
  expect_error(learner$selected_features())

  task = tsk("mtcars")
  task$select(c("am", "cyl", "wt"))
  learner$train(task)
  expect_set_equal(learner$selected_features(), c("am", "cyl", "wt"))
})

test_that("se.method works", {
  learner = lrn("regr.ranger", se.method = "simple", predict_type = "se")
  task = tsk("mtcars")
  learner$train(task)
  pred = learner$predict(task)
  expect_numeric(pred$se, any.missing = FALSE)

  learner = lrn("regr.ranger", se.method = "law_of_total_variance", predict_type = "se")
  learner$train(task)
  pred = learner$predict(task)
  expect_numeric(pred$se, any.missing = FALSE)

  learner = lrn("regr.ranger", se.method = "infjack", predict_type = "se")
  learner$train(task)
  pred = learner$predict(task)
  expect_numeric(pred$se, any.missing = FALSE)

  learner = lrn("regr.ranger", se.method = "jack", predict_type = "se")
  learner$train(task)
  pred = learner$predict(task)
  expect_numeric(pred$se, any.missing = FALSE)
})

test_that("simple se method works", {
  learner = lrn("regr.ranger", se.method = "simple", predict_type = "se")
  task = tsk("mtcars")
  learner$train(task)

  # calculate with R functions
  mu_sigma = compute_mu_sigma2(learner$model$model, task)
  simple_response = simple_var(learner, task$data(), mu_sigma$mu_sigma2_per_node_per_tree)

  # compare with C functions
  pred = learner$predict(task)
  expect_equal(pred$response, simple_response$response)
  expect_equal(pred$se, simple_response$se)
})

test_that("law of total variance se method works", {
  learner = lrn("regr.ranger", se.method = "law_of_total_variance", predict_type = "se")
  task = tsk("mtcars")
  learner$train(task)

  # calculate with R functions
  mu_sigma = compute_mu_sigma2(learner$model$model, task)
  ltv_response = ltv(learner, task$data(), mu_sigma$mu_sigma2_per_node_per_tree)

  # compare with C functions
  pred = learner$predict(task)
  expect_equal(pred$response, ltv_response$response)
  expect_equal(pred$se, ltv_response$se)
})
