# mlr3learners

[![Build Status](https://travis-ci.org/mlr-org/mlr3learners.svg?branch=master)](https://travis-ci.org/mlr-org/mlr3learners)
[![CRAN](https://www.r-pkg.org/badges/version/mlr3learners)](https://cran.r-project.org/package=mlr3learners)
[![codecov](https://codecov.io/gh/mlr-org/mlr3learners/branch/master/graph/badge.svg)](https://codecov.io/gh/mlr-org/mlr3learners)
[![StackOverflow](https://img.shields.io/badge/stackoverflow-mlr3-orange.svg)](https://stackoverflow.com/questions/tagged/mlr3)

This packages provides essential learners for [mlr3](https://mlr3.mlr-org.com).
Creating custom learners is covered in the [mlr3book](https://mlr3book.mlr-org.com).


### Classification Learners

| ID                                                                                              | Learner                          | Package                                                |
| :---------------------------------------------------------------------------------------------- | :------------------------------- | :----------------------------------------------------- |
| [classif.glmnet](https://mlr3learners.mlr-org.com/reference/LearnerClassifGlmnet.html)          | Penalized Logistic Regression    | [glmnet](https://cran.r-project.org/package=glmnet)    |
| [classif.kknn](https://mlr3learners.mlr-org.com/reference/LearnerClassifKKNN.html)              | kNN                              | [kknn](https://cran.r-project.org/package=kknn)        |
| [classif.lda](https://mlr3learners.mlr-org.com/reference/LearnerClassifLDA.html)                | LDA                              | [MASS](https://cran.r-project.org/package=MASS)        |
| [classif.log_reg](https://mlr3learners.mlr-org.com/reference/LearnerClassifLogReg.html)         | Logistic Regression              | stats                                                  |
| [classif.naive_bayes](https://mlr3learners.mlr-org.com/reference/LearnerClassifNaiveBayes.html) | Naive Bayes                      | [e1071](https://cran.r-project.org/package=e1071)      |
| [classif.qda](https://mlr3learners.mlr-org.com/reference/LearnerClassifQDA.html)                | QDA                              | [MASS](https://cran.r-project.org/package=MASS)        |
| [classif.ranger](https://mlr3learners.mlr-org.com/reference/LearnerClassifRanger.html)          | Random Forest                    | [ranger](https://cran.r-project.org/package=ranger)    |
| [classif.svm](https://mlr3learners.mlr-org.com/reference/LearnerClassifSVM.html)                | SVM                              | [e1071](https://cran.r-project.org/package=e1071)      |
| [classif.xgboost](https://mlr3learners.mlr-org.com/reference/LearnerClassifXgboost.html)        | Gradient Boosting                | [xgboost](https://cran.r-project.org/package=xgboost)  |

### Regression Learners

| ID                                                                                 | Learner                          | Package                                                       |
| :--------------------------------------------------------------------------------- | :------------------------------- | :------------------------------------------------------------ |
| [regr.glmnet](https://mlr3learners.mlr-org.com/reference/LearnerRegrGlmnet.html)   | Penalized Linear Regression      | [glmnet](https://cran.r-project.org/package=glmnet)           |
| [regr.kknn](https://mlr3learners.mlr-org.com/reference/LearnerRegrKKNN.html)       | kNN                              | [kknn](https://cran.r-project.org/package=kknn)               |
| [regr.km](https://mlr3learners.mlr-org.com/reference/LearnerRegrKM.html)           | Kriging                          | [DiceKriging](https://cran.r-project.org/package=DiceKriging) |
| [regr.lm](https://mlr3learners.mlr-org.com/reference/LearnerRegrLM.html)           | Linear Regression                | stats                                                         |
| [regr.ranger](https://mlr3learners.mlr-org.com/reference/LearnerRegrRanger.html)   | Random Forest                    | [ranger](https://cran.r-project.org/package=ranger)           |
| [regr.svm](https://mlr3learners.mlr-org.com/reference/LearnerRegrSVM.html)         | SVM                              | [e1071](https://cran.r-project.org/package=e1071)             |
| [regr.xgboost](https://mlr3learners.mlr-org.com/reference/LearnerRegrXgboost.html) | Gradient Boosting                | [xgboost](https://cran.r-project.org/package=xgboost)         |

