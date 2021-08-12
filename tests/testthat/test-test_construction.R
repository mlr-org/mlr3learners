test_that("all learners can be constructed without custom args", {
  expect_silent(lrns(c(
    "classif.cv_glmnet",
    "classif.glmnet",
    "classif.kknn",
    "classif.lda",
    "classif.log_reg",
    "classif.naive_bayes",
    "classif.qda",
    "classif.ranger",
    "classif.svm",
    "classif.xgboost",
    "classif.multinom",

    "regr.cv_glmnet",
    "regr.glmnet",
    "regr.kknn",
    "regr.km",
    "regr.lm",
    "regr.ranger",
    "regr.svm",
    "regr.xgboost")))
})
