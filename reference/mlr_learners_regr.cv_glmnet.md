# GLM with Elastic Net Regularization Regression Learner

Generalized linear models with elastic net regularization. Calls
[`glmnet::cv.glmnet()`](https://glmnet.stanford.edu/reference/cv.glmnet.html)
from package [glmnet](https://CRAN.R-project.org/package=glmnet).

The default for hyperparameter `family` is set to `"gaussian"`.

## Dictionary

This [mlr3::Learner](https://mlr3.mlr-org.com/reference/Learner.html)
can be instantiated via the
[dictionary](https://mlr3misc.mlr-org.com/reference/Dictionary.html)
[mlr3::mlr_learners](https://mlr3.mlr-org.com/reference/mlr_learners.html)
or with the associated sugar function
[`mlr3::lrn()`](https://mlr3.mlr-org.com/reference/mlr_sugar.html):

    mlr_learners$get("regr.cv_glmnet")
    lrn("regr.cv_glmnet")

## Meta Information

- Task type: “regr”

- Predict Types: “response”

- Feature Types: “logical”, “integer”, “numeric”

- Required Packages: [mlr3](https://CRAN.R-project.org/package=mlr3),
  [mlr3learners](https://CRAN.R-project.org/package=mlr3learners),
  [glmnet](https://CRAN.R-project.org/package=glmnet)

## Parameters

|                      |           |            |                                |                       |
|----------------------|-----------|------------|--------------------------------|-----------------------|
| Id                   | Type      | Default    | Levels                         | Range                 |
| alignment            | character | lambda     | lambda, fraction               | \-                    |
| alpha                | numeric   | 1          |                                | \\\[0, 1\]\\          |
| big                  | numeric   | 9.9e+35    |                                | \\(-\infty, \infty)\\ |
| devmax               | numeric   | 0.999      |                                | \\\[0, 1\]\\          |
| dfmax                | integer   | \-         |                                | \\\[0, \infty)\\      |
| eps                  | numeric   | 1e-06      |                                | \\\[0, 1\]\\          |
| epsnr                | numeric   | 1e-08      |                                | \\\[0, 1\]\\          |
| exclude              | integer   | \-         |                                | \\\[1, \infty)\\      |
| exmx                 | numeric   | 250        |                                | \\(-\infty, \infty)\\ |
| family               | character | gaussian   | gaussian, poisson              | \-                    |
| fdev                 | numeric   | 1e-05      |                                | \\\[0, 1\]\\          |
| foldid               | untyped   | NULL       |                                | \-                    |
| gamma                | untyped   | \-         |                                | \-                    |
| grouped              | logical   | TRUE       | TRUE, FALSE                    | \-                    |
| intercept            | logical   | TRUE       | TRUE, FALSE                    | \-                    |
| keep                 | logical   | FALSE      | TRUE, FALSE                    | \-                    |
| lambda               | untyped   | \-         |                                | \-                    |
| lambda.min.ratio     | numeric   | \-         |                                | \\\[0, 1\]\\          |
| lower.limits         | untyped   | \-         |                                | \-                    |
| maxit                | integer   | 100000     |                                | \\\[1, \infty)\\      |
| mnlam                | integer   | 5          |                                | \\\[1, \infty)\\      |
| mxit                 | integer   | 100        |                                | \\\[1, \infty)\\      |
| mxitnr               | integer   | 25         |                                | \\\[1, \infty)\\      |
| nfolds               | integer   | 10         |                                | \\\[3, \infty)\\      |
| nlambda              | integer   | 100        |                                | \\\[1, \infty)\\      |
| use_pred_offset      | logical   | TRUE       | TRUE, FALSE                    | \-                    |
| parallel             | logical   | FALSE      | TRUE, FALSE                    | \-                    |
| penalty.factor       | untyped   | \-         |                                | \-                    |
| pmax                 | integer   | \-         |                                | \\\[0, \infty)\\      |
| pmin                 | numeric   | 1e-09      |                                | \\\[0, 1\]\\          |
| prec                 | numeric   | 1e-10      |                                | \\(-\infty, \infty)\\ |
| predict.gamma        | numeric   | gamma.1se  |                                | \\(-\infty, \infty)\\ |
| relax                | logical   | FALSE      | TRUE, FALSE                    | \-                    |
| s                    | numeric   | lambda.1se |                                | \\\[0, \infty)\\      |
| standardize          | logical   | TRUE       | TRUE, FALSE                    | \-                    |
| standardize.response | logical   | FALSE      | TRUE, FALSE                    | \-                    |
| thresh               | numeric   | 1e-07      |                                | \\\[0, \infty)\\      |
| trace.it             | integer   | 0          |                                | \\\[0, 1\]\\          |
| type.gaussian        | character | \-         | covariance, naive              | \-                    |
| type.logistic        | character | \-         | Newton, modified.Newton        | \-                    |
| type.measure         | character | deviance   | deviance, class, auc, mse, mae | \-                    |
| type.multinomial     | character | \-         | ungrouped, grouped             | \-                    |
| upper.limits         | untyped   | \-         |                                | \-                    |

## Offset

If a `Task` contains a column with the `offset` role, it is
automatically incorporated during training via the `offset` argument in
[`glmnet::glmnet()`](https://glmnet.stanford.edu/reference/glmnet.html).
During prediction, the offset column from the test set is used only if
`use_pred_offset = TRUE` (default), passed via the `newoffset` argument
in
[`glmnet::predict.glmnet()`](https://glmnet.stanford.edu/reference/predict.glmnet.html).
Otherwise, if the user sets `use_pred_offset = FALSE`, a zero offset is
applied, effectively disabling the offset adjustment during prediction.

## References

Friedman J, Hastie T, Tibshirani R (2010). “Regularization Paths for
Generalized Linear Models via Coordinate Descent.” *Journal of
Statistical Software*, **33**(1), 1–22.
[doi:10.18637/jss.v033.i01](https://doi.org/10.18637/jss.v033.i01) .

## See also

- Chapter in the [mlr3book](https://mlr3book.mlr-org.com/):
  <https://mlr3book.mlr-org.com/chapters/chapter2/data_and_basic_modeling.html#sec-learners>

- Package
  [mlr3extralearners](https://github.com/mlr-org/mlr3extralearners) for
  more learners.

- [Dictionary](https://mlr3misc.mlr-org.com/reference/Dictionary.html)
  of [Learners](https://mlr3.mlr-org.com/reference/Learner.html):
  [mlr3::mlr_learners](https://mlr3.mlr-org.com/reference/mlr_learners.html)

- `as.data.table(mlr_learners)` for a table of available
  [Learners](https://mlr3.mlr-org.com/reference/Learner.html) in the
  running session (depending on the loaded packages).

- [mlr3pipelines](https://CRAN.R-project.org/package=mlr3pipelines) to
  combine learners with pre- and postprocessing steps.

- Extension packages for additional task types:

  - [mlr3proba](https://CRAN.R-project.org/package=mlr3proba) for
    probabilistic supervised regression and survival analysis.

  - [mlr3cluster](https://CRAN.R-project.org/package=mlr3cluster) for
    unsupervised clustering.

- [mlr3tuning](https://CRAN.R-project.org/package=mlr3tuning) for tuning
  of hyperparameters,
  [mlr3tuningspaces](https://CRAN.R-project.org/package=mlr3tuningspaces)
  for established default tuning spaces.

Other Learner:
[`mlr_learners_classif.cv_glmnet`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.cv_glmnet.md),
[`mlr_learners_classif.glmnet`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.glmnet.md),
[`mlr_learners_classif.kknn`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.kknn.md),
[`mlr_learners_classif.lda`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.lda.md),
[`mlr_learners_classif.log_reg`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.log_reg.md),
[`mlr_learners_classif.multinom`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.multinom.md),
[`mlr_learners_classif.naive_bayes`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.naive_bayes.md),
[`mlr_learners_classif.nnet`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.nnet.md),
[`mlr_learners_classif.qda`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.qda.md),
[`mlr_learners_classif.ranger`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.ranger.md),
[`mlr_learners_classif.svm`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.svm.md),
[`mlr_learners_classif.xgboost`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.xgboost.md),
[`mlr_learners_regr.glmnet`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.glmnet.md),
[`mlr_learners_regr.kknn`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.kknn.md),
[`mlr_learners_regr.km`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.km.md),
[`mlr_learners_regr.lm`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.lm.md),
[`mlr_learners_regr.nnet`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.nnet.md),
[`mlr_learners_regr.ranger`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.ranger.md),
[`mlr_learners_regr.svm`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.svm.md),
[`mlr_learners_regr.xgboost`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.xgboost.md)

## Super classes

[`mlr3::Learner`](https://mlr3.mlr-org.com/reference/Learner.html) -\>
[`mlr3::LearnerRegr`](https://mlr3.mlr-org.com/reference/LearnerRegr.html)
-\> `LearnerRegrCVGlmnet`

## Methods

### Public methods

- [`LearnerRegrCVGlmnet$new()`](#method-LearnerRegrCVGlmnet-new)

- [`LearnerRegrCVGlmnet$selected_features()`](#method-LearnerRegrCVGlmnet-selected_features)

- [`LearnerRegrCVGlmnet$clone()`](#method-LearnerRegrCVGlmnet-clone)

Inherited methods

- [`mlr3::Learner$base_learner()`](https://mlr3.mlr-org.com/reference/Learner.html#method-base_learner)
- [`mlr3::Learner$configure()`](https://mlr3.mlr-org.com/reference/Learner.html#method-configure)
- [`mlr3::Learner$encapsulate()`](https://mlr3.mlr-org.com/reference/Learner.html#method-encapsulate)
- [`mlr3::Learner$format()`](https://mlr3.mlr-org.com/reference/Learner.html#method-format)
- [`mlr3::Learner$help()`](https://mlr3.mlr-org.com/reference/Learner.html#method-help)
- [`mlr3::Learner$predict()`](https://mlr3.mlr-org.com/reference/Learner.html#method-predict)
- [`mlr3::Learner$predict_newdata()`](https://mlr3.mlr-org.com/reference/Learner.html#method-predict_newdata)
- [`mlr3::Learner$print()`](https://mlr3.mlr-org.com/reference/Learner.html#method-print)
- [`mlr3::Learner$reset()`](https://mlr3.mlr-org.com/reference/Learner.html#method-reset)
- [`mlr3::Learner$train()`](https://mlr3.mlr-org.com/reference/Learner.html#method-train)
- [`mlr3::LearnerRegr$predict_newdata_fast()`](https://mlr3.mlr-org.com/reference/LearnerRegr.html#method-predict_newdata_fast)

------------------------------------------------------------------------

### Method `new()`

Creates a new instance of this
[R6](https://r6.r-lib.org/reference/R6Class.html) class.

#### Usage

    LearnerRegrCVGlmnet$new()

------------------------------------------------------------------------

### Method `selected_features()`

Returns the set of selected features as reported by
[`glmnet::predict.glmnet()`](https://glmnet.stanford.edu/reference/predict.glmnet.html)
with `type` set to `"nonzero"`.

#### Usage

    LearnerRegrCVGlmnet$selected_features(lambda = NULL)

#### Arguments

- `lambda`:

  (`numeric(1)`)  
  Custom `lambda`, defaults to the active lambda depending on parameter
  set.

#### Returns

([`character()`](https://rdrr.io/r/base/character.html)) of feature
names.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    LearnerRegrCVGlmnet$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
# Define the Learner and set parameter values
learner = lrn("regr.cv_glmnet")
print(learner)
#> 
#> ── <LearnerRegrCVGlmnet> (regr.cv_glmnet): GLM with Elastic Net Regularization ─
#> • Model: -
#> • Parameters: family=gaussian, use_pred_offset=TRUE
#> • Packages: mlr3, mlr3learners, and glmnet
#> • Predict Types: [response]
#> • Feature Types: logical, integer, and numeric
#> • Encapsulation: none (fallback: -)
#> • Properties: offset, selected_features, and weights
#> • Other settings: use_weights = 'use'

# Define a Task
task = tsk("mtcars")

# Create train and test set
ids = partition(task)

# Train the learner on the training ids
learner$train(task, row_ids = ids$train)
#> Warning: Option grouped=FALSE enforced in cv.glmnet, since < 3 observations per fold

# Print the model
print(learner$model)
#> 
#> Call:  (if (cv) glmnet::cv.glmnet else glmnet::glmnet)(x = data, y = target,      family = "gaussian") 
#> 
#> Measure: Mean-Squared Error 
#> 
#>     Lambda Index Measure    SE Nonzero
#> min 0.5715    26   8.141 2.396       5
#> 1se 1.7452    14  10.501 4.100       3

# Importance method
if ("importance" %in% learner$properties) print(learner$importance)

# Make predictions for the test rows
predictions = learner$predict(task, row_ids = ids$test)

# Score the predictions
predictions$score()
#> regr.mse 
#> 4.397693 
```
