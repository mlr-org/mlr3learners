# mlr3learners

Package website: [release](https://mlr3learners.mlr-org.com/) | [dev](https://mlr3learners.mlr-org.com/dev/)

<!-- badges: start -->

[![r-cmd-check](https://github.com/mlr-org/mlr3learners/actions/workflows/r-cmd-check.yml/badge.svg)](https://github.com/mlr-org/mlr3learners/actions/workflows/r-cmd-check.yml)
[![Parameter Check](https://github.com/mlr-org/mlr3learners/workflows/Parameter%20Check/badge.svg?branch=main)](https://github.com/mlr-org/mlr3learners/actions)
[![CRAN Status](https://www.r-pkg.org/badges/version-ago/mlr3learners)](https://cran.r-project.org/package=mlr3learners)
[![Mattermost](https://img.shields.io/badge/chat-mattermost-orange.svg)](https://lmmisld-lmu-stats-slds.srv.mwn.de/mlr_invite/)

<!-- badges: end -->

This packages provides essential learners for [mlr3](https://mlr3.mlr-org.com), maintained by the mlr-org team.
Additional learners can be found in the [mlr3extralearners](https://github.com/mlr-org/mlr3extralearners) package on GitHub.
Request additional learners over there.

:point_right: [Table of all learners](https://mlr-org.com/learners.html)

## Installation

```r
# CRAN version:
install.packages("mlr3learners")

# Development version:
remotes::install_github("mlr-org/mlr3learners")
```

If you also want to install all packages of the connected learners, set `dependencies = TRUE`:

```r
# CRAN version:
install.packages("mlr3learners", dependencies = TRUE)

# Development version:
remotes::install_github("mlr-org/mlr3learners", dependencies = TRUE)
```

## Classification Learners

| ID                                                                                                      | Learner                       | Package                                               |
| :------------------------------------------------------------------------------------------------------ | :---------------------------- | :---------------------------------------------------- |
| [classif.cv_glmnet](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.cv_glmnet.html)     | Penalized Logistic Regression | [glmnet](https://cran.r-project.org/package=glmnet)   |
| [classif.glmnet](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.glmnet.html)           | Penalized Logistic Regression | [glmnet](https://cran.r-project.org/package=glmnet)   |
| [classif.kknn](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.kknn.html)               | k-Nearest Neighbors           | [kknn](https://cran.r-project.org/package=kknn)       |
| [classif.lda](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.lda.html)                 | LDA                           | [MASS](https://cran.r-project.org/package=MASS)       |
| [classif.log_reg](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.log_reg.html)         | Logistic Regression           | stats                                                 |
| [classif.multinom](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.multinom.html)       | Multinomial log-linear model  | [nnet](https://cran.r-project.org/package=nnet)       |
| [classif.naive_bayes](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.naive_bayes.html) | Naive Bayes                   | [e1071](https://cran.r-project.org/package=e1071)     |
| [classif.nnet](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.nnet.html)               | Single Layer Neural Network   | [nnet](https://cran.r-project.org/package=nnet)       |
| [classif.qda](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.qda.html)                 | QDA                           | [MASS](https://cran.r-project.org/package=MASS)       |
| [classif.ranger](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.ranger.html)           | Random Forest                 | [ranger](https://cran.r-project.org/package=ranger)   |
| [classif.svm](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.svm.html)                 | SVM                           | [e1071](https://cran.r-project.org/package=e1071)     |
| [classif.xgboost](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.xgboost.html)         | Gradient Boosting             | [xgboost](https://cran.r-project.org/package=xgboost) |

## Regression Learners

| ID                                                                                            | Learner                     | Package                                                       |
| :-------------------------------------------------------------------------------------------- | :-------------------------- | :------------------------------------------------------------ |
| [regr.cv_glmnet](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.cv_glmnet.html) | Penalized Linear Regression | [glmnet](https://cran.r-project.org/package=glmnet)           |
| [regr.glmnet](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.glmnet.html)       | Penalized Linear Regression | [glmnet](https://cran.r-project.org/package=glmnet)           |
| [regr.kknn](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.kknn.html)           | k-Nearest Neighbors         | [kknn](https://cran.r-project.org/package=kknn)               |
| [regr.km](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.km.html)               | Kriging                     | [DiceKriging](https://cran.r-project.org/package=DiceKriging) |
| [regr.lm](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.lm.html)               | Linear Regression           | stats                                                         |
| [regr.nnet](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.nnet.html)           | Single Layer Neural Network | nnet                                                          |
| [regr.ranger](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.ranger.html)       | Random Forest               | [ranger](https://cran.r-project.org/package=ranger)           |
| [regr.svm](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.svm.html)             | SVM                         | [e1071](https://cran.r-project.org/package=e1071)             |
| [regr.xgboost](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.xgboost.html)     | Gradient Boosting           | [xgboost](https://cran.r-project.org/package=xgboost)         |
