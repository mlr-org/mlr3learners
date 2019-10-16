# mlr3learners

[![Build Status](https://travis-ci.org/mlr-org/mlr3learners.svg?branch=master)](https://travis-ci.org/mlr-org/mlr3learners)
[![CRAN Status Badge](https://www.r-pkg.org/badges/version-ago/mlr3learners)](https://cran.r-project.org/package=mlr3learners)
[![Cran Checks](https://cranchecks.info/badges/worst/mlr3learners)](https://cran.r-project.org/web/checks/check_results_mlr3learners.html)
[![Codecov](https://codecov.io/gh/mlr-org/mlr3learners/branch/master/graph/badge.svg)](https://codecov.io/gh/mlr-org/mlr3learners)
[![StackOverflow](https://img.shields.io/badge/stackoverflow-mlr3-orange.svg)](https://stackoverflow.com/questions/tagged/mlr3)

This packages provides essential learners for [mlr3](https://mlr3.mlr-org.com), maintained by the mlr-org team.
We will most likely not add new learners to this package.

Other learners live in the [mlr3learners](https://github.com/mlr3learners) organization and are possibly maintained by people outside the mlr-org team.
There is a [wiki page](https://github.com/mlr-org/mlr3learners/wiki/Extra-Learners) listing all currently available custom learners.
A guide on how to create custom learners is covered in the [mlr3book](https://mlr3book.mlr-org.com).
Feel invited to contribute a missing learner to the mlr3 ecosystem :-)

### Classification Learners

| ID                                                                                              | Learner                          | Package                                                |
| :---------------------------------------------------------------------------------------------- | :------------------------------- | :----------------------------------------------------- |
| [classif.glmnet](https://mlr3learners.mlr-org.com/reference/LearnerClassifGlmnet.html)          | Penalized Logistic Regression    | [glmnet](https://cran.r-project.org/package=glmnet)    |
| [classif.kknn](https://mlr3learners.mlr-org.com/reference/LearnerClassifKKNN.html)              | k-Nearest Neighbors              | [kknn](https://cran.r-project.org/package=kknn)        |
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
| [regr.kknn](https://mlr3learners.mlr-org.com/reference/LearnerRegrKKNN.html)       | k-Nearest Neighbors              | [kknn](https://cran.r-project.org/package=kknn)               |
| [regr.km](https://mlr3learners.mlr-org.com/reference/LearnerRegrKM.html)           | Kriging                          | [DiceKriging](https://cran.r-project.org/package=DiceKriging) |
| [regr.lm](https://mlr3learners.mlr-org.com/reference/LearnerRegrLM.html)           | Linear Regression                | stats                                                         |
| [regr.ranger](https://mlr3learners.mlr-org.com/reference/LearnerRegrRanger.html)   | Random Forest                    | [ranger](https://cran.r-project.org/package=ranger)           |
| [regr.svm](https://mlr3learners.mlr-org.com/reference/LearnerRegrSVM.html)         | SVM                              | [e1071](https://cran.r-project.org/package=e1071)             |
| [regr.xgboost](https://mlr3learners.mlr-org.com/reference/LearnerRegrXgboost.html) | Gradient Boosting                | [xgboost](https://cran.r-project.org/package=xgboost)         |

