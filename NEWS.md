# mlr3learners 0.2.0.9003

- glmnet learners: `penalty.factor` is a vector param, not a `ParamDbl` (#141)
- add surv.xgboost (#135)
- add surv.ranger (#134)
- Require mlr3proba CRAN (#144)
- add mlr3learners.catboost (#143)


# mlr3learners 0.2.0.9002

- Add surv glmnet (#130)
- Increase mlr3 minimum version to v0.3.0
- Request mlr3proba >= 0.1.6 for survival learners


# mlr3learners 0.2.0.9001

- Glmnet: Add params `mxitnr` and `epsnr` from glmnet v4.0 update


# mlr3learners 0.2.0.9000

- Internal changes only.


# mlr3learners 0.2.0

- Split {glmnet} learner into `cv_glmnet` and `glmnet` (#99)
- {glmnet} learners: Add `predict.gamma` and `newoffset` arg (#98)
- We now test that all learners can be constructed without parameters.
- A new custom "Paramtest" which lives `inst/paramtest` was added. 
  This test checks against the arguments of the upstream train & predict functions and ensures that all parameters are implemented in the respective mlr3 learner. (#96)
- A lot missing parameters were added to learners. See #96 for a complete list.
- Add parameter `interaction_constraints` to {xgboost} learners (#97).
- There is now a vignette ["Additional Learners"](https://mlr3learners.mlr-org.com/dev/articles/learners/additional-learners.html) listing all external learners which live in the [mlr3learners](https://github.com/mlr3learners) organization.
  See [mlr3learners.drat](https://github.com/mlr3learners/mlr3learners.drat) for easy installation.

# mlr3learners 0.1.6.9000

- Added learner `classif.multinom` from package `nnet`.
- Learners `regr.lm` and `classif.log_reg` now ignore the global option
  `"contrasts"`.
- Add vignette `additional-learners.Rmd` listing all mlr3 custom learners
- Move Learner\*Glmnet to Learner\*CVGlmnet and add Learner\*Glmnet (without internal tuning) (#90)

## XGBoost

- Add parameter `"interaction_constraints" (#95)

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
