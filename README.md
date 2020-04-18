# mlr3learners

Package website: [release](https://mlr3learners.mlr-org.com/) | [dev](https://mlr3learners.mlr-org.com/dev)

<!-- badges: start -->

[![R CMD Check via {tic}](https://github.com/mlr-org/mlr3learners/workflows/R%20CMD%20Check%20via%20{tic}/badge.svg?branch=master)](https://github.com/mlr-org/mlr3learners/actions)
[![Parameter Check](https://github.com/mlr-org/mlr3learners/workflows/Parameter%20Check/badge.svg?branch=master)](https://github.com/mlr-org/mlr3learners/actions)
[![CRAN Status Badge](https://www.r-pkg.org/badges/version-ago/mlr3learners)](https://cran.r-project.org/package=mlr3learners)
[![Cran Checks](https://cranchecks.info/badges/worst/mlr3learners)](https://cran.r-project.org/web/checks/check_results_mlr3learners.html)
[![Codecov](https://codecov.io/gh/mlr-org/mlr3learners/branch/master/graph/badge.svg)](https://codecov.io/gh/mlr-org/mlr3learners)
[![StackOverflow](https://img.shields.io/badge/stackoverflow-mlr3-orange.svg)](https://stackoverflow.com/questions/tagged/mlr3)

<!-- badges: end -->

This packages provides essential learners for [mlr3](https://mlr3.mlr-org.com), maintained by the mlr-org team.
We will most likely not add new learners to this package.
See section ["More Learners"](#more-learners) below for more information.

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
| [regr.ranger](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.ranger.html)       | Random Forest               | [ranger](https://cran.r-project.org/package=ranger)           |
| [regr.svm](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.svm.html)             | SVM                         | [e1071](https://cran.r-project.org/package=e1071)             |
| [regr.xgboost](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.xgboost.html)     | Gradient Boosting           | [xgboost](https://cran.r-project.org/package=xgboost)         |

## More Learners

Learners from other packages live in the [mlr3learners](https://github.com/mlr3learners) organization and are possibly maintained by people _outside_ the mlr-org team.

:point_right: [Table of all additional learners](https://mlr3learners.mlr-org.com/dev/articles/learners/additional-learners.html)

## Requesting/Adding Additional Learners

Follow these steps to add/request a new learner.

1. Open an issue in [mlr3learners](https://github.com/mlr-org/mlr3learners/issues) following the issue template.
   (If you don't want to add the learner yourself, you are done here.
   We might take your vote into consideration but can't promise when your requested learner will be available.)
1. Fork the [mlr3learners.template](https://github.com/mlr-org/mlr3learners.template) repo and adjust the template to match your learner.
   Essentially, replace the placeholders like `<package>` with the respective terms for your learner.
   More detailed instructions including FAQ are given in section ["Adding new Learners"](https://mlr3book.mlr-org.com/extending-learners.html) of the mlr3book.
1. When you are done, request a review for the learner.
   Make sure that you have checked on all points of [this checklist](https://github.com/mlr-org/mlr3learners.template/issues/5) before requesting a review.
1. After approval, transfer the learner to the [mlr3learners](https://github.com/mlr3learners) organization.
   To do so, please first request an invitation from [@pat-s](https://github.com/pat-s) / [@be-marc](https://github.com/be-marc) to be added to the [mlr3learners](https://github.com/mlr3learners) organization.
   Once transferred, you will get access rights to the learner repository to finalize and maintain it.
1. Congrats! Your learner has been successfully added to the mlr3 ecosystem.
   Now the last step is to add the learner to [{mlr3learners.drat}](https://github.com/mlr3learners/mlr3learners.drat).
   This makes is possible to install the learner via `install.packages()` without the need to submit the learner to CRAN (none of the custom learners live on CRAN).

**Resources for adding a new learner (summary)**

- [mlr3learners.template](https://github.com/mlr-org/mlr3learners.template)
- [mlr3book section "Adding new learners" including FAQ](https://mlr3book.mlr-org.com/extending-learners.html)
- [Checklist prior to requesting a review](https://github.com/mlr-org/mlr3learners.template/issues/5)

Last, thanks for contributing to the mlr3 ecosystem! We would be very happy if you keep maintaining the learner against upstream changes :)
