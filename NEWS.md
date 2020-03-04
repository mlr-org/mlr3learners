# mlr3learners 0.1.7

* Added learner `classif.multinom` from package `nnet`.
* Learners `regr.lm` and `classif.log_reg` now ignore the global option
  `"contrasts"`.

# mlr3learners 0.1.6

* Added missing feature type `logical()` to multiple learners.

# mlr3learners 0.1.5

* Added parameter and parameter dependencies to `regr.glmnet`, `regr.km`,
  `regr.ranger`, `regr.svm`, `regr.xgboost`, `classif.glmnet`, `classif.lda`,
  `classif.naivebayes`, `classif.qda`, `classif.ranger` and `classif.svm`.
* `glmnet`: Added `relax` parameter (v3.0)
* `xgboost`: Updated parameters for v0.90.0.2

# mlr3learners 0.1.4

* Fixed a bug in `*.xgboost` and `*.svm` which was triggered if columns
  were reordered between `$train()` and `$predict()`.

# mlr3learners 0.1.3

* Changes to work with new `mlr3::Learner` API.
* Improved documentation.
* Added references.

* add new parameters of xgboost version 0.90.2
* add parameter dependencies for xgboost

# mlr3learners 0.1.2

* Maintenance release.

# mlr3learners 0.1.1

* Initial upload to CRAN.
