# mlr3learners 0.4.3.9000

- Added `survival:aft` objective to `surv.xgboost`
- Removed hyperparameter `predict.all` from ranger learners (#172).

# mlr3learners 0.4.3

- Fixed stochastic test failures on solaris.
- Fixed `surv.ranger`, c.f. https://github.com/mlr-org/mlr3proba/issues/165.
- Added `classif.nnet` learner (moved from mlr3extralearners).

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
