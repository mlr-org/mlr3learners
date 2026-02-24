skip_on_os("solaris") # glmnet not working properly on solaris
skip_if_not_installed("glmnet")

options(warnPartialMatchArgs = FALSE)
on.exit(options(warnPartialMatchArgs = TRUE))

test_that("autotest", {
  learner = mlr3::lrn("classif.cv_glmnet")
  expect_learner(learner)

  skip_on_os("solaris")
  result = run_autotest(learner, exclude = "feat_single", N = 100L)
  expect_true(result, info = result$error)
})

test_that("prob column reordering (#155)", {
  task = tsk("sonar")
  learner = mlr3::lrn("classif.cv_glmnet", predict_type = "prob")

  task$positive = "M"
  learner$train(task)
  p = learner$predict(task)
  expect_gt(p$score(msr("classif.acc")), 0.6)

  task$positive = "R"
  learner$train(task)
  p = learner$predict(task)
  expect_gt(p$score(msr("classif.acc")), 0.6)
})

test_that("same label ordering as in glm() / log_reg", {
  task = with_seed(123, tgen("2dnormals")$generate(100))
  for (pos in task$class_names) {
    task$positive = pos

    l1 = lrn("classif.log_reg")
    l2 = lrn("classif.cv_glmnet")
    l1$train(task)
    l2$train(task)

    expect_equal(sign(as.numeric(coef(l1$model))), sign(as.numeric(coef(l2$model, s = 0))),
      info = sprintf("positive label = %s", pos))
  }
})


test_that("selected_features", {
  task = tsk("iris")
  learner = lrn("classif.cv_glmnet")
  learner$train(task)

  expect_equal(
    learner$selected_features(0),
    task$feature_names
  )

  expect_equal(
    learner$selected_features(Inf),
    character()
  )
})

test_that("seed param works", {
  library(data.table)
  task.obj <- mlr3::tsk("sonar")
  task.obj$col_roles$feature <- paste0("V", 1:9)#simplify result
  kfoldcv <- mlr3::rsmp("cv")
  kfoldcv$param_set$values$folds <- 2
  set.seed(1)
  kfoldcv$instantiate(task.obj)
  seed.list <- list(null=NULL, one=1L)
  w_dt_list <- list()
  for(seed.name in names(seed.list)){
    lrn_cvg <- mlr3learners::LearnerClassifCVGlmnet$new()
    lrn_cvg$param_set$values$seed <- seed.list[[seed.name]]
    for(iteration in paste0("run",1:2)){
      bgrid <- mlr3::benchmark_grid(task.obj, lrn_cvg, kfoldcv)
      bmr <- mlr3::benchmark(bgrid, store_models=TRUE)
      score_dt <- bmr$score(mlr3::msr("classif.acc"))
      for(test.fold in 1:nrow(score_dt)){
        L <- score_dt$learner[[test.fold]]
        w <- coef(L$model)
        nz <- as.logical(w!=0)
        w_dt_list[[paste(
          seed.name, iteration, test.fold
        )]] <- data.table(
          seed.name, iteration, test.fold,
          name=rownames(w)[nz], coef=w[nz]
        )
      }
    }
  }
  w_dt <- rbindlist(w_dt_list)
  w_wide <- dcast(
    w_dt,
    seed.name + test.fold + name ~ iteration,
    value.var="coef")
  w_wide[seed.name=="null", expect_false(identical(run1, run2))]
  w_wide[seed.name=="one", expect_identical(run1, run2)]
})

test_that("error for invalid seed param", {
  task.obj <- mlr3::tsk("sonar")
  kfoldcv <- mlr3::rsmp("cv")
  lrn_cvg <- mlr3learners::LearnerClassifCVGlmnet$new()
  lrn_cvg$param_set$values$seed <- "foo"
  bgrid <- mlr3::benchmark_grid(task.obj, lrn_cvg, kfoldcv)
  expect_error({
    mlr3::benchmark(bgrid, store_models=TRUE)
  }, "cv_glmnet seed param must be integer or NULL")
})
