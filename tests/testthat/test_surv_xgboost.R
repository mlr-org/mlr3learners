test_that("autotest", {
  skip_on_cran()
  with_seed(1, {
    learner = mlr_learners$get("surv.xgboost")
    expect_learner(learner)
    result = run_autotest(learner, N = 10, check_replicable = FALSE)
    expect_true(result, info = result$error)
  })
})


test_that("manual aft", {
  skip_on_cran()
  set.seed(2)
  learner = lrn("surv.xgboost", objective = "survival:aft")
  task = generate_tasks(learner, 30)$sanity
  p = learner$train(task)$predict(task)
  expect_true(inherits(p, "PredictionSurv"))
  expect_true(p$score() >= 0.5)
})

test_that("early_stopping", {
  skip_on_cran()
  task = tsk("gbcs")
  task$set_row_roles(seq(40), roles = "early_stopping")
  learner = lrn("surv.xgboost", early_stopping_rounds = 10, nrounds = 100)

  learner$train(task)
  expect_names(names(learner$model$evaluation_log), must.include = "early_stopping_cox_nloglik")
})
