# mlr3learners

[![Build Status](https://travis-ci.org/mlr-org/mlr3learners.svg?branch=master)](https://travis-ci.org/mlr-org/mlr3learners)
[![CRAN](https://www.r-pkg.org/badges/version/mlr3learners)](https://cran.r-project.org/package=mlr3learners)
[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![codecov](https://codecov.io/gh/mlr-org/mlr3learners/branch/master/graph/badge.svg)](https://codecov.io/gh/mlr-org/mlr3learners)

This packages includes all recommended learners for [mlr3](https://mlr3.mlr-org.com).
It's still work in progress.

### Planned/Implemented learners


| Learner                          | Package                                                       | Classification | Regression |
| :------------------------------- | :------------------------------------------------------------ | :------------  | :--------- |
| Linear / Logistic Regression     | stats                                                         | x              | x          |
| Penalized Regression             | [glmnet](https://cran.r-project.org/package=glmnet)           | x              | x          |
| kNN                              | [kknn](https://cran.r-project.org/package=kknn)               | x              | x          |
| Naive Bayes                      | [e1071](https://cran.r-project.org/package=e1071)             | x              | -          |
| SVM                              | [e1071](https://cran.r-project.org/package=e1071)             | x              | x          |
| Random Forest                    | [ranger](https://cran.r-project.org/package=ranger)           | x              | x          |
| Boosting                         | [xgboost](https://cran.r-project.org/package=xgboost)         | x              | x          |
| Kriging                          | [DiceKriging](https://cran.r-project.org/package=DiceKriging) | -              | x          |
| LDA                              | [MASS](https://cran.r-project.org/package=MASS)               | x              | -          |
| QDA                              | [MASS](https://cran.r-project.org/package=MASS)               | x              | x          |


How to add a learner: [Tutorial](https://mlr-org.github.io/mlr3learners/index.html)
