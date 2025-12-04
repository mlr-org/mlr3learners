library(mlr3learners)

test_that("classif.xgboost", {
  learner = lrn("classif.xgboost", nrounds = 1L)
  fun = list(xgboost::xgb.train, xgboost::xgb.params)
  exclude = c(
    "data", # handled by mlr3
    "params", # handled by mlr3
    "custom_metric", # handled by eval_metric parameter
    "learning_rate", # handled by eta parameter
    "min_split_loss", # handled by gamma parameter
    "reg_alpha", # handled by alpha parameter
    "reg_lambda", # handled by lambda parameter
    "multi_strategy", # not supported
    "num_class", # handled by mlr3
    "huber_slope", # regression only
    "quantile_alpha", # regression only
    "aft_loss_distribution", # survival only
    "lambdarank_pair_method", # rank only
    "lambdarank_num_pair_per_sample", # rank only
    "lambdarank_normalization", # rank only
    "lambdarank_score_normalization", # rank only
    "lambdarank_unbiased", # rank only
    "lambdarank_bias_norm", # rank only
    "ndcg_exp_gain" # rank only
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "train")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or param defined in additional control function not included in list of function definitions:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
  )
})

test_that("predict classif.xgboost", {
  learner = lrn("classif.xgboost")
  fun = xgboost:::predict.xgb.Booster
  exclude = c(
    "object", # handled by mlr3
    "newdata", # handled by mlr3o
    "outputmargin", # not supported
    "predcontrib", # not supported
    "predinteraction", # not supported
    "predleaf", # not supported
    "avoid_transpose", # not supported
    "base_margin", # not supported
    "objective" # use by mlr3 not xgboost
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "predict")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or param defined in additional control function not included in list of function definitions:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
  )
})

