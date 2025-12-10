# Changelog

## mlr3learners (development version)

## mlr3learners 0.13.0

CRAN release: 2025-10-02

- feat: Add new uncertainty estimation methods
  `ensemble_standard_deviation` and `law_of_total_variance` to
  `regr.ranger` learner.
- fix: Default `nrounds` for xgboost learners.
- feat: Store ranger oob error without storing models.
- fix: Only allow simple measures as internal measures for xgboost
  learners.

## mlr3learners 0.12.0

CRAN release: 2025-05-23

- feat: Add `classif.kknn` and `regr.kknn` learners.

## mlr3learners 0.11.0

CRAN release: 2025-05-17

- BREAKING CHANGE: The `kknn` package was removed from CRAN. The
  `classif.kknn` and `regr.kknn` learners are now removed from
  mlr3learners.
- compatibility: mlr3 1.0.0

## mlr3learners 0.10.0

CRAN release: 2025-03-19

- feat: Support offset during training and prediction in `xgboost`,
  `glmnet`, `lm` and `glm` learners.
- feat: Add `$selected_features()` method to `classif.ranger` and
  `regr.ranger` learners.

## mlr3learners 0.9.0

CRAN release: 2024-11-23

- BREAKING CHANGE: Remove `$loglik()` method from all learners.
- feat: Update hyperparameter set of `lrn("classif.ranger")` and
  `lrn("regr.ranger")` for 0.17.0, adding `na.action` parameter and
  `"missings"` property, and `poisson` splitrule for regression with a
  new `poisson.tau` parameter.
- compatibility: mlr3 0.22.0.

## mlr3learners 0.8.0

CRAN release: 2024-10-25

- fix: Hyperparameter set of `lrn("classif.ranger")` and
  `lrn("regr.ranger")`. Remove `alpha` and `minprop` hyperparameter.
  Remove default of `respect.unordered.factors`. Change lower bound of
  `max_depth` from 0 to 1. Remove `se.method` from
  `lrn("classif.ranger")`.
- feat: use `base_margin` in xgboost learners
  ([\#205](https://github.com/mlr-org/mlr3learners/issues/205)).
- fix: validation for learner `lrn("regr.xgboost")` now works properly.
  Previously the training data was used.
- feat: add weights for logistic regression again, which were
  incorrectly removed in a previous release
  ([\#265](https://github.com/mlr-org/mlr3learners/issues/265)).
- BREAKING CHANGE: When using internal tuning for xgboost learners, the
  `eval_metric` must now be set. This achieves that one needs to make
  the conscious decision which performance metric to use for early
  stopping.
- BREAKING CHANGE: Change xgboost default nrounds from 1 to 1000.

## mlr3learners 0.7.0

CRAN release: 2024-06-28

- feat: `LearnerClassifXgboost` and `LearnerRegrXgboost` now support
  internal tuning and validation. This now also works in conjunction
  with `mlr3pipelines`.

## mlr3learners 0.6.0

CRAN release: 2024-03-13

- Adaption to new paradox version 1.0.0.

## mlr3learners 0.5.8

CRAN release: 2023-12-21

- Adaption to memory optimization in mlr3 0.17.1.

## mlr3learners 0.5.7

CRAN release: 2023-11-21

- Added labels to learners.
- Added formula argument to `nnet` learner and support feature type
  `"integer"`.
- Added `min.bucket` parameter to `classif.ranger` and `regr.ranger`.

## mlr3learners 0.5.6

CRAN release: 2023-01-06

- Enable new early stopping mechanism for xgboost.
- Improved documentation.
- fix: unloading `mlr3learners` removes learners from dictionary.

## mlr3learners 0.5.4

CRAN release: 2022-08-15

- Added `regr.nnet` learner.
- Removed the option to use weights in `classif.log_reg`.
- Added `default_values()` function for ranger and svm learners.
- Improved documentation.

## mlr3learners 0.5.3

CRAN release: 2022-05-25

- Survival learners have been moved to mlr3extralearners (maintained on
  Github): <https://github.com/mlr-org/mlr3extralearners>

## mlr3learners 0.5.2

CRAN release: 2022-01-22

- Most learners now reorder the columns in the predict task according to
  the order of columns in the training task.
- Removed workaround for old mlr3 versions.

## mlr3learners 0.5.1

CRAN release: 2021-11-19

- `eval_metric()` is now explicitly set for xgboost learners to silence
  a deprecation warning.
- Improved how the added hyperparameter `mtry.ratio` is converted to
  `mtry` to simplify tuning.
- Multiple updates to hyperparameter sets.

## mlr3learners 0.5.0

CRAN release: 2021-08-17

- Fixed the internal encoding of the positive class for classification
  learners based on `glm` and `glmnet`
  ([\#199](https://github.com/mlr-org/mlr3learners/issues/199)). While
  predictions in previous versions were correct, the estimated
  coefficients had the wrong sign.
- Reworked handling of `lambda` and `s` for `glmnet` learners
  ([\#197](https://github.com/mlr-org/mlr3learners/issues/197)).
- Learners based on `glmnet` now support to extract selected features
  ([\#200](https://github.com/mlr-org/mlr3learners/issues/200)).
- Learners based on `kknn` now raise an exception if `k >= n`
  ([\#191](https://github.com/mlr-org/mlr3learners/issues/191)).
- Learners based on `ranger` now come with the virtual hyperparameter
  `mtry.ratio` to set the hyperparameter `mtry` based on the proportion
  of features to use.
- Multiple learners now support the extraction of the log-likelihood
  (via method `$loglik()`), allowing to calculate measures like AIC or
  BIC in `mlr3`
  ([\#182](https://github.com/mlr-org/mlr3learners/issues/182)).

## mlr3learners 0.4.5

CRAN release: 2021-03-18

- Fixed SVM learners for new release of package `e1071`.

## mlr3learners 0.4.4

CRAN release: 2021-03-15

- Changed hyperparameters of all learners to make them run sequentially
  in their defaults. The new function `set_threads()` in mlr3 provides a
  generic way to set the respective hyperparameter to the desired number
  of parallel threads.
- Added `survival:aft` objective to `surv.xgboost`
- Removed hyperparameter `predict.all` from ranger learners
  ([\#172](https://github.com/mlr-org/mlr3learners/issues/172)).

## mlr3learners 0.4.3

CRAN release: 2020-12-08

- Fixed stochastic test failures on solaris.
- Fixed `surv.ranger`, c.f.
  <https://github.com/mlr-org/mlr3proba/issues/165>.
- Added `classif.nnet` learner (moved from `mlr3extralearners`).

## mlr3learners 0.4.2

CRAN release: 2020-11-11

- Fixed a bug in the survival random forest `LearnerSurvRanger`.

## mlr3learners 0.4.1

CRAN release: 2020-10-07

- Disabled some `glmnet` tests on solaris.
- Removed dependency on orphaned package `bibtex`.

## mlr3learners 0.4.0

CRAN release: 2020-09-25

- Fixed a potential label switch in `classif.glmnet` and
  `classif.cv_glmnet` with `predict_type` set to `"prob"`
  ([\#155](https://github.com/mlr-org/mlr3learners/issues/155)).
- Fixed learners from package `glmnet` to be more robust if the order of
  features has changed between train and predict.

## mlr3learners 0.3.0

CRAN release: 2020-08-29

- The `$model` slot of the {kknn} learner now returns a list containing
  some information which is being used during the predict step. Before,
  the slot was empty because there is no training step for kknn.
- Compact in-memory representation of R6 objects to save space when
  saving mlr3 objects via
  [`saveRDS()`](https://rdrr.io/r/base/readRDS.html),
  [`serialize()`](https://rdrr.io/r/base/serialize.html) etc.
- glmnet learners: `penalty.factor` is a vector param, not a `ParamDbl`
  ([\#141](https://github.com/mlr-org/mlr3learners/issues/141))
- glmnet: Add params `mxitnr` and `epsnr` from glmnet v4.0 update
- Add learner `surv.glmnet`
  ([\#130](https://github.com/mlr-org/mlr3learners/issues/130))
- Suggest package `mlr3proba`
  ([\#144](https://github.com/mlr-org/mlr3learners/issues/144))
- Add learner `surv.xgboost`
  ([\#135](https://github.com/mlr-org/mlr3learners/issues/135))
- Add learner `surv.ranger`
  ([\#134](https://github.com/mlr-org/mlr3learners/issues/134))

## mlr3learners 0.2.0

CRAN release: 2020-04-22

- Split glmnet learner into `cv_glmnet` and `glmnet`
  ([\#99](https://github.com/mlr-org/mlr3learners/issues/99))
- glmnet learners: Add `predict.gamma` and `newoffset` arg
  ([\#98](https://github.com/mlr-org/mlr3learners/issues/98))
- We now test that all learners can be constructed without parameters.
- A new custom “Paramtest” which lives `inst/paramtest` was added. This
  test checks against the arguments of the upstream train & predict
  functions and ensures that all parameters are implemented in the
  respective mlr3 learner
  ([\#96](https://github.com/mlr-org/mlr3learners/issues/96)).
- A lot missing parameters were added to learners. See
  [\#96](https://github.com/mlr-org/mlr3learners/issues/96) for a
  complete list.
- Add parameter `interaction_constraints` to {xgboost} learners
  ([\#97](https://github.com/mlr-org/mlr3learners/issues/97)).

## mlr3learners 0.1.6.9000

- Added learner `classif.multinom` from package `nnet`.
- Learners `regr.lm` and `classif.log_reg` now ignore the global option
  `"contrasts"`.
- Add vignette `additional-learners.Rmd` listing all mlr3 custom
  learners
- Move Learner\*Glmnet to Learner\*CVGlmnet and add Learner\*Glmnet
  (without internal tuning)
  ([\#90](https://github.com/mlr-org/mlr3learners/issues/90))

### XGBoost

- Add parameter `interaction_constraints`
  ([\#95](https://github.com/mlr-org/mlr3learners/issues/95))

## mlr3learners 0.1.6

CRAN release: 2020-02-10

- Added missing feature type
  [`logical()`](https://rdrr.io/r/base/logical.html) to multiple
  learners.

## mlr3learners 0.1.5

CRAN release: 2019-11-25

- Added parameter and parameter dependencies to `regr.glmnet`,
  `regr.km`, `regr.ranger`, `regr.svm`, `regr.xgboost`,
  `classif.glmnet`, `classif.lda`, `classif.naivebayes`, `classif.qda`,
  `classif.ranger` and `classif.svm`.
- `glmnet`: Added `relax` parameter (v3.0)
- `xgboost`: Updated parameters for v0.90.0.2

## mlr3learners 0.1.4

CRAN release: 2019-10-29

- Fixed a bug in `*.xgboost` and `*.svm` which was triggered if columns
  were reordered between `$train()` and `$predict()`.

## mlr3learners 0.1.3

CRAN release: 2019-09-17

- Changes to work with new
  [`mlr3::Learner`](https://mlr3.mlr-org.com/reference/Learner.html)
  API.

- Improved documentation.

- Added references.

- add new parameters of xgboost version 0.90.2

- add parameter dependencies for xgboost

## mlr3learners 0.1.2

CRAN release: 2019-08-26

- Maintenance release.

## mlr3learners 0.1.1

CRAN release: 2019-08-05

- Initial upload to CRAN.
