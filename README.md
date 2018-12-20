# mlr3learners

[![Build Status](https://travis-ci.org/mlr-org/mlr3learners.svg?branch=master)](https://travis-ci.org/mlr-org/mlr3learners)
[![CRAN](https://www.r-pkg.org/badges/version/mlr3learners)](https://cran.r-project.org/package=mlr3learners)
[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![codecov](https://codecov.io/gh/mlr-org/mlr3learners/branch/master/graph/badge.svg)](https://codecov.io/gh/mlr-org/mlr3learners)

This packages includes all recommended learners for [mlr3](https://mlr3.mlr-org.com).
It's still work in progress.

### Planned/Implemented learners

 
| Name													| package 				 | Classification	| Regression	|
|:------------------------------|:-----------------| :-------------:|:-----------:|
| Linear / Logistic Regression	| stats 					 | x							| 						|
| Penalized Regression					| glmnet 					 | x							| 						|
| kNN														| kknn 						 | 								| 						|
| Naive Bayes										| e1071 					 | 								| 						|
| SVM														| e1071 					 | 								| 						|
| Random Forest									| ranger 					 | x							| x						|
| Boosting											| xgboost 				 | x							| 						|
| Kriging												| DiceKriging 		 | 								| 						|
| Neural Network								| keras 					 | 								| 						|


How to add a learner: [Tutorial](https://mlr-org.github.io/mlr3learners/index.html)
