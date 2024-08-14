library(mlr3learners)
library(magrittr, exclude = c("equals", "is_less_than", "not"))
library(rvest)

x = rvest::read_html("https://xgboost.readthedocs.io/en/latest/parameter.html")
xli = rvest::html_elements(x, "li")
xp = rvest::html_elements(x, "p")
x = c(rvest::html_text2(xli), rvest::html_text2(xp))

add_params_xgboost = x %>%
  grep("default=", ., value = TRUE) %>%
  strsplit(., split = " ", fixed = TRUE) %>%
  mlr3misc::map_chr(1L) %>%
  gsub(",", replacement = "", ., fixed = TRUE) %>%
  ## these are defined on the same line as colsample_bytree and cannot be scraped therefore
  append(values = c("colsample_bylevel", "colsample_bynode")) %>%
  # values which do not match regex
  append(values = c("interaction_constraints", "monotone_constraints", "base_score")) %>%
  # only defined in help page but not in signature or website
  append(values = "lambda_bias")

test_that("regr.xgboost", {
  learner = lrn("regr.xgboost", nrounds = 1L)
  fun = list(xgboost::xgb.train, xgboost::xgboost, add_params_xgboost)
  exclude = c(
    "x", # handled by mlr3
    "params", # handled by mlr3
    "data", # handled by mlr3
    "obj", # handled via type parameter
    "verbosity", # handled by mlr3
    "seed", # not available in R package
    "train", # handled by mlr3
    "task", # handled by mlr3
    "model_in", # handled by mlr3
    "model_out", # handled by mlr3
    "model_dir", # handled by mlr3
    "dump_format", # CLI parameter, not for R package
    "name_dump", # CLI parameter, not for R package
    "name_pred", # CLI parameter, not for R package
    "pred_margin", # CLI parameter, not for R package
    "eval_metric", # handled by mlr3
    "label", # handled by mlr3
    "weight", # handled by mlr3
    "nthread" # handled by mlr3
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "train")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or param defined in additional control function not included in list of function definitions:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})

test_that("predict regr.xgboost", {
  learner = lrn("regr.xgboost")
  fun = xgboost:::predict.xgb.Booster
  exclude = c(
    "object", # handled by mlr3
    "newdata", # handled by mlr3
    "objective" # defined in xgboost::xgboost and already in param set
  )

  ParamTest = run_paramtest(learner, fun, exclude, tag = "predict")
  expect_true(ParamTest, info = paste0(
    "\nMissing parameters in mlr3 param set:\n",
    paste0("- ", ParamTest$missing, "\n", collapse = ""),
    "\nOutdated param or param defined in additional control function not included in list of function definitions:\n",
    paste0("- ", ParamTest$extra, "\n", collapse = ""))
    )
})
