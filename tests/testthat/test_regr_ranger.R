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
  expect_equal(learner_1$model$model$num.trees, 1000L)

  hot = HotstartStack$new(learner_1)

  learner_2 = lrn("regr.ranger", num.trees = 500L)
  expect_equal(hot$start_cost(learner_2, task$hash), 0L)
  learner_2$train(task)
  expect_equal(learner_2$model$model$num.trees, 500L)
  expect_equal(learner_2$param_set$values$num.trees, 500L)
  expect_equal(learner_2$state$param_vals$num.trees, 500L)

  learner_3 = lrn("regr.ranger", num.trees = 1500L)
  expect_equal(hot$start_cost(learner_3, task$hash), NA_real_)

  learner_4 = lrn("regr.ranger", num.trees = 1000L)
  expect_equal(hot$start_cost(learner_4, task$hash), -1L)
  learner_4$train(task)
  expect_equal(learner_4$model$model$num.trees, 1000L)
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
    learner$model$model$mtry,
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

  expect_matrix(pred$quantiles, ncolss = 3L)
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

# simple se method -------------------------------------------------------------

test_that("c_ranger_mu_sigma works with one tree", {
  # one terminal node and one observation
  term_ids = matrix(c(0L)) # terminal nodes are zero-indexed
  truth = c(1)
  res = .Call("c_ranger_mu_sigma", term_ids, truth, 0)[[1]]
  expect_matrix(res, nrows = 1, ncols = 2)
  expect_equal(unname(res[1, 1]), 1)
  expect_equal(unname(res[1, 2]), 0)

  # one terminal node and two observations
  term_ids = matrix(c(0L, 0L))
  truth = c(1, 2)
  res = .Call("c_ranger_mu_sigma", term_ids, truth, 0)[[1]]
  expect_matrix(res, nrows = 1, ncols = 2)
  expect_equal(unname(res[1, 1]), 1.5)
  expect_equal(unname(res[1, 2]), 0.5)

  # two terminal nodes and four observations
  term_ids = matrix(c(0L, 0L, 1L, 1L))
  truth = c(1, 1, 2, 2) # truth[1] and truth[2] are in the same terminal node
  res = .Call("c_ranger_mu_sigma", term_ids, truth, 0)[[1]]
  expect_matrix(res, nrows = 2, ncols = 2)
  expect_equal(unname(res[1, 1]), 1)
  expect_equal(unname(res[1, 2]), 0)
  expect_equal(unname(res[2, 1]), 2)
  expect_equal(unname(res[2, 2]), 0)

  # four terminal nodes and eight observations
  term_ids = matrix(c(0L, 0L, 1L, 1L, 2L, 2L, 3L, 3L))
  truth = c(1, 1, 2, 2, 3, 3, 4, 4)
  res = .Call("c_ranger_mu_sigma", term_ids, truth, 0)[[1]]
  expect_matrix(res, nrows = 4, ncols = 2)
  expect_equal(unname(res[1, 1]), 1)
  expect_equal(unname(res[1, 2]), 0)
  expect_equal(unname(res[2, 1]), 2)
  expect_equal(unname(res[2, 2]), 0)
  expect_equal(unname(res[3, 1]), 3)
  expect_equal(unname(res[3, 2]), 0)
  expect_equal(unname(res[4, 1]), 4)
  expect_equal(unname(res[4, 2]), 0)
})

test_that("c_ranger_mu_sigma works with two trees", {
  # two trees, one terminal node per tree
  term_ids = matrix(c(0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L), nrows = 4, ncols = 2)
  truth = c(1, 1, 2, 2)
  res = .Call("c_ranger_mu_sigma", term_ids, truth, 0)
  assert_list(res, len = 2)
  expect_matrix(res[[1]], nrows = 1, ncols = 2)
  expect_equal(unname(res[[1]][1, 1]), 1.5)
  expect_equal(unname(res[[1]][1, 2]), 1 / 3)
  expect_matrix(res[[2]], nrows = 1, ncols = 2)
  expect_equal(unname(res[[2]][1, 1]), 1.5)
  expect_equal(unname(res[[2]][1, 2]), 1 / 3)

  # two trees, first tree has one terminal node, second tree has two terminal nodes
  term_ids = matrix(c(0L, 0L, 0L, 0L, 1L, 1L, 1L, 1L), nrows = 4, ncols = 2)
  truth = c(1, 1, 2, 2)
  res = .Call("c_ranger_mu_sigma", term_ids, truth, 0)
  assert_list(res, len = 2)
  expect_matrix(res[[1]], nrows = 1, ncols = 2)
  expect_equal(unname(res[[1]][1, 1]), 1.5)
  expect_equal(unname(res[[1]][1, 2]), 1 / 3)
  expect_matrix(res[[2]], nrows = 2, ncols = 2) # 2 rows because first terminal node is empty
  expect_equal(unname(res[[2]][1, 1]), 0)
  expect_equal(unname(res[[2]][1, 2]), 0)
  expect_equal(unname(res[[2]][2, 1]), 1.5)
  expect_equal(unname(res[[2]][2, 2]), 1 / 3)
})

test_that("c_ranger_mu_sigma variance calculation works", {
  # one terminal node and one tree
  term_ids = matrix(c(0L, 0L, 0L, 0L, 0L), nrows = 5, ncols = 1)
  truth = c(1, 2, 3, 4, 5)
  res = .Call("c_ranger_mu_sigma", term_ids, truth, 0)
  assert_list(res, len = 1)
  expect_matrix(res[[1]], nrows = 1, ncols = 2)
  expect_equal(unname(res[[1]][1, 1]), 3)
  expect_equal(unname(res[[1]][1, 2]), 2.5)

  # two terminal nodes and one tree
  term_ids = matrix(c(0L, 0L, 1L, 1L, 1L), nrows = 5, ncols = 1)
  truth = c(1, 2, 3, 4, 5)
  res = .Call("c_ranger_mu_sigma", term_ids, truth, 0)
  assert_list(res, len = 1)
  expect_matrix(res[[1]], nrows = 2, ncols = 2)
  expect_equal(unname(res[[1]][1, 1]), 1.5)
  expect_equal(unname(res[[1]][1, 2]), 0.5)
  expect_equal(unname(res[[1]][2, 1]), 4)
  expect_equal(unname(res[[1]][2, 2]), 1)

  # two terminal nodes and two trees
  # observations that are in terminal node 0 in the first tree and are in terminal node 1 in the second tree
  # observations that are in terminal node 1 in the first tree and are in terminal node 0 in the second tree
  term_ids = matrix(c(0L, 0L, 1L, 1L, 0L, 0L, 1L, 1L, 1L, 1L, 0L, 0L, 1L, 1L, 0L, 0L), nrows = 8, ncols = 2)
  truth = c(1, 2, 4, 5, 3, 7, 8, 9)
  res = .Call("c_ranger_mu_sigma", term_ids, truth, 0)
  assert_list(res, len = 2)
  expect_matrix(res[[1]], nrows = 2, ncols = 2)
  expect_equal(unname(res[[1]][1, 1]), mean(c(1, 2, 3, 7)))
  expect_equal(unname(res[[1]][1, 2]), var(c(1, 2, 3, 7)))
  expect_equal(unname(res[[1]][2, 1]), mean(c(4, 5, 8, 9)))
  expect_equal(unname(res[[1]][2, 2]), var(c(4, 5, 8, 9)))

  expect_matrix(res[[2]], nrows = 2, ncols = 2)
  expect_equal(unname(res[[2]][1, 1]), mean(c(4, 5, 8, 9)))
  expect_equal(unname(res[[2]][1, 2]), var(c(4, 5, 8, 9)))
  expect_equal(unname(res[[2]][2, 1]), mean(c(1, 2, 3, 7)))
  expect_equal(unname(res[[2]][2, 2]), var(c(1, 2, 3, 7)))
})

test_that("c_ranger_var simple works with one tree", {
  # one terminal node, one training observation and one test observation
  term_ids = matrix(c(0L)) # terminal nodes are zero-indexed
  truth = c(1)
  mu_sigma = .Call("c_ranger_mu_sigma", term_ids, truth, 0)

  term_ids = matrix(c(0L))
  res = .Call("c_ranger_var", term_ids, mu_sigma, 0)
  expect_equal(res$response, 1)
  expect_equal(res$se, 0)

  # one terminal node, two training observations and one test observation
  term_ids = matrix(c(0L, 0L))
  truth = c(1, 2)
  mu_sigma = .Call("c_ranger_mu_sigma", term_ids, truth, 0)

  term_ids = matrix(c(0L))
  res = .Call("c_ranger_var", term_ids, mu_sigma, 0)
  expect_equal(res$response, 1.5)
  expect_equal(res$se, 0)

  # one terminal node, two training observations and two test observations
  term_ids = matrix(c(0L, 0L))
  truth = c(1, 2)
  mu_sigma = .Call("c_ranger_mu_sigma", term_ids, truth, 0)

  term_ids = matrix(c(0L, 0L))
  res = .Call("c_ranger_var", term_ids, mu_sigma, 0)
  expect_equal(res$response, c(1.5, 1.5))
  expect_equal(res$se, c(0, 0))
})

test_that("c_ranger_var simple works with two trees", {
  # one terminal node, five training observation and one test observation
  term_ids = matrix(c(0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L), nrows = 5, ncols = 2)
  truth = c(1, 2, 3, 4, 5)
  mu_sigma = .Call("c_ranger_mu_sigma", term_ids, truth, 0)

  term_ids = matrix(c(0L, 0L), ncols = 2)
  res = .Call("c_ranger_var", term_ids, mu_sigma, 0)
  expect_equal(res$response, 3)
  expect_equal(res$se, 0)
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

test_that("simple se method works with single tree", {
  learner = lrn("regr.ranger",
    se.method = "simple",
    predict_type = "se",
    num.trees = 1,
    seed = 1
  )

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

test_that("simple se method works with stump trees", {
  learner = lrn("regr.ranger",
    se.method = "simple",
    predict_type = "se",
    num.trees = 2,
    max.depth = 1,
    seed = 1
  )
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

test_that("simple se method works with single stump tree", {
  learner = lrn("regr.ranger",
    se.method = "simple",
    predict_type = "se",
    num.trees = 1,
    max.depth = 1,
    seed = 1
  )
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

# law of total variance --------------------------------------------------------

test_that("c_ranger_var ltv works with one tree", {
  # one terminal node, one training observation and one test observation
  term_ids = matrix(c(0L)) # terminal nodes are zero-indexed
  truth = c(1)
  mu_sigma = .Call("c_ranger_mu_sigma", term_ids, truth, 0)

  term_ids = matrix(c(0L))
  res = .Call("c_ranger_var", term_ids, mu_sigma, 1)
  expect_equal(res$response, 1)
  expect_equal(res$se, 0)

  # one terminal node, two training observations and one test observation
  term_ids = matrix(c(0L, 0L))
  truth = c(1, 2)
  mu_sigma = .Call("c_ranger_mu_sigma", term_ids, truth, 0)

  term_ids = matrix(c(0L))
  res = .Call("c_ranger_var", term_ids, mu_sigma, 1)
  expect_equal(res$response, 1.5)
  expect_equal(res$se, 0.7, tolerance = 1e-1)

  # one terminal node, two training observations and two test observations
  term_ids = matrix(c(0L, 0L))
  truth = c(1, 2)
  mu_sigma = .Call("c_ranger_mu_sigma", term_ids, truth, 0)

  term_ids = matrix(c(0L, 0L))
  res = .Call("c_ranger_var", term_ids, mu_sigma, 1)
  expect_equal(res$response, c(1.5, 1.5))
  expect_equal(res$se, c(0.7, 0.7), tolerance = 1e-1)
})

test_that("c_ranger_var ltv works with two trees", {
  # one terminal node per tree, five training observation and one test observation
  term_ids = matrix(c(0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L), nrows = 4, ncols = 2)
  truth = c(1, 1, 1, 1)
  mu_sigma = .Call("c_ranger_mu_sigma", term_ids, truth, 0)

  term_ids = matrix(c(0L, 0L), ncols = 2)
  res = .Call("c_ranger_var", term_ids, mu_sigma, 1)
  expect_equal(res$response, 1)
  expect_equal(res$se, 0)

  # one terminal node per tree, five training observation and one test observation
  term_ids = matrix(c(0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L), nrows = 5, ncols = 2)
  truth = c(1, 2, 3, 4, 5)
  mu_sigma = .Call("c_ranger_mu_sigma", term_ids, truth, 0)

  term_ids = matrix(c(0L, 0L), ncols = 2)
  res = .Call("c_ranger_var", term_ids, mu_sigma, 1)
  expect_equal(res$response, 3)
  expect_equal(res$se, 1.581139, tolerance = 1e-6)
})

test_that("law of total variance se method works", {
  learner = lrn("regr.ranger", se.method = "law_of_total_variance", predict_type = "se", sigma2.threshold = 0)
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

test_that("oob_error available without stored model", {
  task = tsk("mtcars")
  learner = lrn("regr.ranger")

  rr = resample(task, learner, rsmp("holdout"), store_models = FALSE)

  expect_number(rr$aggregate(msr("oob_error")))
})
