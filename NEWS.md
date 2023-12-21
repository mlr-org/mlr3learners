# mlr3learners (development version)

# mlr3learners 0.5.8

* Adaption to memory optimization in mlr3 0.17.1.

# mlr3learners 0.5.7

* Added labels to learners.
* Added formula argument to `nnet` learner and support feature type `"integer"`.
* Added `min.bucket` parameter to `classif.ranger` and `regr.ranger`.

# mlr3learners 0.5.6

- Enable new early stopping mechanism for xgboost.
- Improved documentation.
- fix: unloading `mlr3learners` removes learners from dictionary.

# mlr3learners 0.5.4

- Added `regr.nnet` learner.
- Removed the option to use weights in `classif.log_reg`.
- Added `default_values()` function for ranger and svm learners.
- Improved documentation.

# mlr3learners 0.5.3

- Survival learners have been moved to mlr3extralearners (maintained on Github):
  https://github.com/mlr-org/mlr3extralearners


# mlr3learners 0.5.2

- Most learners now reorder the columns in the predict task according to the
  order of columns in the training task.
- Removed workaround for old mlr3 versions.

# mlr3learners 0.5.1

- `eval_metric()` is now explicitly set for xgboost learners to silence a
  deprecation warning.
- Improved how the added hyperparameter `mtry.ratio` is converted to `mtry` to
  simplify tuning.
- Multiple updates to hyperparameter sets.

# mlr3learners 0.5.0

- Fixed the internal encoding of the positive class for classification learners
  based on `glm` and `glmnet` (#199). While predictions in previous versions
  were correct, the estimated coefficients had the wrong sign.
- Reworked handling of `lambda` and `s` for `glmnet` learners (#197).
- Learners based on `glmnet` now support to extract selected features (#200).
- Learners based on `kknn` now raise an exception if `k >= n` (#191).
- Learners based on `ranger` now come with the virtual hyperparameter
  `mtry.ratio` to set the hyperparameter `mtry` based on the proportion of
  features to use.
- Multiple learners now support the extraction of the log-likelihood (via method
  `$loglik()`), allowing to calculate measures like AIC or BIC in `mlr3` (#182).

# mlr3learners 0.4.5

- Fixed SVM learners for new release of package `e1071`.

# mlr3learners 0.4.4

- Changed hyperparameters of all learners to make them run sequentially in their
  defaults.
  The new function `set_threads()` in mlr3 provides a generic way to set the
  respective hyperparameter to the desired number of parallel threads.
- Added `survival:aft` objective to `surv.xgboost`
- Removed hyperparameter `predict.all` from ranger learners (#172).

# mlr3learners 0.4.3

- Fixed stochastic test failures on solaris.
- Fixed `surv.ranger`, c.f. https://github.com/mlr-org/mlr3proba/issues/165.
- Added `classif.nnet` learner (moved from `mlr3extralearners`).

# mlr3learners 0.4.2

- Fixed a bug in the survival random forest `LearnerSurvRanger`.

# mlr3learners 0.4.1

- Disabled some `glmnet` tests on solaris.
- Removed dependency on orphaned package `bibtex`.

# mlr3learners 0.4.0

- Fixed a potential label switch in `classif.glmnet` and `classif.cv_glmnet`
  with `predict_type` set to `"prob"` (#155).
- Fixed learners from package `glmnet` to be more robust if the order of
  features has changed between train and predict.

# mlr3learners 0.3.0

- The `$model` slot of the {kknn} learner now returns a list containing some
  information which is being used during the predict step.
  Before, the slot was empty because there is no training step for kknn.
- Compact in-memory representation of R6 objects to save space when saving mlr3
  objects via `saveRDS()`, `serialize()` etc.
- glmnet learners: `penalty.factor` is a vector param, not a `ParamDbl` (#141)
- glmnet: Add params `mxitnr` and `epsnr` from glmnet v4.0 update
- Add learner `surv.glmnet` (#130)
- Suggest package `mlr3proba` (#144)
- Add learner `surv.xgboost` (#135)
- Add learner `surv.ranger` (#134)


# mlr3learners 0.2.0

- Split glmnet learner into `cv_glmnet` and `glmnet` (#99)
- glmnet learners: Add `predict.gamma` and `newoffset` arg (#98)
- We now test that all learners can be constructed without parameters.
- A new custom "Paramtest" which lives `inst/paramtest` was added.
  This test checks against the arguments of the upstream train & predict
  functions and ensures that all parameters are implemented in the respective
  mlr3 learner (#96).
- A lot missing parameters were added to learners. See #96 for a complete list.
- Add parameter `interaction_constraints` to {xgboost} learners (#97).

# mlr3learners 0.1.6.9000

- Added learner `classif.multinom` from package `nnet`.
- Learners `regr.lm` and `classif.log_reg` now ignore the global option
  `"contrasts"`.
- Add vignette `additional-learners.Rmd` listing all mlr3 custom learners
- Move Learner\*Glmnet to Learner\*CVGlmnet and add Learner\*Glmnet
  (without internal tuning) (#90)

## XGBoost

- Add parameter `interaction_constraints` (#95)

# mlr3learners 0.1.6

- Added missing feature type `logical()` to multiple learners.

# mlr3learners 0.1.5

- Added parameter and parameter dependencies to `regr.glmnet`, `regr.km`,
  `regr.ranger`, `regr.svm`, `regr.xgboost`, `classif.glmnet`, `classif.lda`,
  `classif.naivebayes`, `classif.qda`, `classif.ranger` and `classif.svm`.
- `glmnet`: Added `relax` parameter (v3.0)
- `xgboost`: Updated parameters for v0.90.0.2

# mlr3learners 0.1.4

- Fixed a bug in `*.xgboost` and `*.svm` which was triggered if columns
  were reordered between `$train()` and `$predict()`.

# mlr3learners 0.1.3

- Changes to work with new `mlr3::Learner` API.
- Improved documentation.
- Added references.

- add new parameters of xgboost version 0.90.2
- add parameter dependencies for xgboost

# mlr3learners 0.1.2

- Maintenance release.

# mlr3learners 0.1.1

- Initial upload to CRAN.
