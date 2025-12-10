# GLM with Elastic Net Regularization Regression Learner

Generalized linear models with elastic net regularization. Calls
[`glmnet::glmnet()`](https://glmnet.stanford.edu/reference/glmnet.html)
from package [glmnet](https://CRAN.R-project.org/package=glmnet).

The default for hyperparameter `family` is set to `"gaussian"`.

## Details

Caution: This learner is different to learners calling
[`glmnet::cv.glmnet()`](https://glmnet.stanford.edu/reference/cv.glmnet.html)
in that it does not use the internal optimization of parameter `lambda`.
Instead, `lambda` needs to be tuned by the user (e.g., via
[mlr3tuning](https://CRAN.R-project.org/package=mlr3tuning)). When
`lambda` is tuned, the `glmnet` will be trained for each tuning
iteration. While fitting the whole path of `lambda`s would be more
efficient, as is done by default in
[`glmnet::glmnet()`](https://glmnet.stanford.edu/reference/glmnet.html),
tuning/selecting the parameter at prediction time (using parameter `s`)
is currently not supported in
[mlr3](https://CRAN.R-project.org/package=mlr3) (at least not in
efficient manner). Tuning the `s` parameter is, therefore, currently
discouraged.

When the data are i.i.d. and efficiency is key, we recommend using the
respective auto-tuning counterparts in
[`mlr_learners_classif.cv_glmnet()`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_classif.cv_glmnet.md)
or
[`mlr_learners_regr.cv_glmnet()`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.cv_glmnet.md).
However, in some situations this is not applicable, usually when data
are imbalanced or not i.i.d. (longitudinal, time-series) and tuning
requires custom resampling strategies (blocked design, stratification).

## Dictionary

This [mlr3::Learner](https://mlr3.mlr-org.com/reference/Learner.html)
can be instantiated via the
[dictionary](https://mlr3misc.mlr-org.com/reference/Dictionary.html)
[mlr3::mlr_learners](https://mlr3.mlr-org.com/reference/mlr_learners.html)
or with the associated sugar function
[`mlr3::lrn()`](https://mlr3.mlr-org.com/reference/mlr_sugar.html):

    mlr_learners$get("regr.glmnet")
    lrn("regr.glmnet")

## Meta Information

- Task type: “regr”

- Predict Types: “response”

- Feature Types: “logical”, “integer”, “numeric”

- Required Packages: [mlr3](https://CRAN.R-project.org/package=mlr3),
  [mlr3learners](https://CRAN.R-project.org/package=mlr3learners),
  [glmnet](https://CRAN.R-project.org/package=glmnet)

## Parameters

|                      |           |          |                         |                       |
|----------------------|-----------|----------|-------------------------|-----------------------|
| Id                   | Type      | Default  | Levels                  | Range                 |
| alignment            | character | lambda   | lambda, fraction        | \-                    |
| alpha                | numeric   | 1        |                         | \\\[0, 1\]\\          |
| big                  | numeric   | 9.9e+35  |                         | \\(-\infty, \infty)\\ |
| devmax               | numeric   | 0.999    |                         | \\\[0, 1\]\\          |
| dfmax                | integer   | \-       |                         | \\\[0, \infty)\\      |
| eps                  | numeric   | 1e-06    |                         | \\\[0, 1\]\\          |
| epsnr                | numeric   | 1e-08    |                         | \\\[0, 1\]\\          |
| exact                | logical   | FALSE    | TRUE, FALSE             | \-                    |
| exclude              | integer   | \-       |                         | \\\[1, \infty)\\      |
| exmx                 | numeric   | 250      |                         | \\(-\infty, \infty)\\ |
| family               | character | gaussian | gaussian, poisson       | \-                    |
| fdev                 | numeric   | 1e-05    |                         | \\\[0, 1\]\\          |
| gamma                | numeric   | 1        |                         | \\(-\infty, \infty)\\ |
| grouped              | logical   | TRUE     | TRUE, FALSE             | \-                    |
| intercept            | logical   | TRUE     | TRUE, FALSE             | \-                    |
| keep                 | logical   | FALSE    | TRUE, FALSE             | \-                    |
| lambda               | untyped   | \-       |                         | \-                    |
| lambda.min.ratio     | numeric   | \-       |                         | \\\[0, 1\]\\          |
| lower.limits         | untyped   | \-       |                         | \-                    |
| maxit                | integer   | 100000   |                         | \\\[1, \infty)\\      |
| mnlam                | integer   | 5        |                         | \\\[1, \infty)\\      |
| mxit                 | integer   | 100      |                         | \\\[1, \infty)\\      |
| mxitnr               | integer   | 25       |                         | \\\[1, \infty)\\      |
| use_pred_offset      | logical   | TRUE     | TRUE, FALSE             | \-                    |
| nlambda              | integer   | 100      |                         | \\\[1, \infty)\\      |
| parallel             | logical   | FALSE    | TRUE, FALSE             | \-                    |
| penalty.factor       | untyped   | \-       |                         | \-                    |
| pmax                 | integer   | \-       |                         | \\\[0, \infty)\\      |
| pmin                 | numeric   | 1e-09    |                         | \\\[0, 1\]\\          |
| prec                 | numeric   | 1e-10    |                         | \\(-\infty, \infty)\\ |
| relax                | logical   | FALSE    | TRUE, FALSE             | \-                    |
| s                    | numeric   | 0.01     |                         | \\\[0, \infty)\\      |
| standardize          | logical   | TRUE     | TRUE, FALSE             | \-                    |
| standardize.response | logical   | FALSE    | TRUE, FALSE             | \-                    |
| thresh               | numeric   | 1e-07    |                         | \\\[0, \infty)\\      |
| trace.it             | integer   | 0        |                         | \\\[0, 1\]\\          |
| type.gaussian        | character | \-       | covariance, naive       | \-                    |
| type.logistic        | character | \-       | Newton, modified.Newton | \-                    |
| type.multinomial     | character | \-       | ungrouped, grouped      | \-                    |
| upper.limits         | untyped   | \-       |                         | \-                    |

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
[`mlr_learners_classif.cv_glmnet`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_classif.cv_glmnet.md),
[`mlr_learners_classif.glmnet`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_classif.glmnet.md),
[`mlr_learners_classif.kknn`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_classif.kknn.md),
[`mlr_learners_classif.lda`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_classif.lda.md),
[`mlr_learners_classif.log_reg`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_classif.log_reg.md),
[`mlr_learners_classif.multinom`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_classif.multinom.md),
[`mlr_learners_classif.naive_bayes`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_classif.naive_bayes.md),
[`mlr_learners_classif.nnet`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_classif.nnet.md),
[`mlr_learners_classif.qda`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_classif.qda.md),
[`mlr_learners_classif.ranger`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_classif.ranger.md),
[`mlr_learners_classif.svm`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_classif.svm.md),
[`mlr_learners_classif.xgboost`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_classif.xgboost.md),
[`mlr_learners_regr.cv_glmnet`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.cv_glmnet.md),
[`mlr_learners_regr.kknn`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.kknn.md),
[`mlr_learners_regr.km`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.km.md),
[`mlr_learners_regr.lm`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.lm.md),
[`mlr_learners_regr.nnet`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.nnet.md),
[`mlr_learners_regr.ranger`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.ranger.md),
[`mlr_learners_regr.svm`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.svm.md),
[`mlr_learners_regr.xgboost`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.xgboost.md)

## Super classes

[`mlr3::Learner`](https://mlr3.mlr-org.com/reference/Learner.html) -\>
[`mlr3::LearnerRegr`](https://mlr3.mlr-org.com/reference/LearnerRegr.html)
-\> `LearnerRegrGlmnet`

## Methods

### Public methods

- [`LearnerRegrGlmnet$new()`](#method-LearnerRegrGlmnet-new)

- [`LearnerRegrGlmnet$selected_features()`](#method-LearnerRegrGlmnet-selected_features)

- [`LearnerRegrGlmnet$clone()`](#method-LearnerRegrGlmnet-clone)

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

    LearnerRegrGlmnet$new()

------------------------------------------------------------------------

### Method `selected_features()`

Returns the set of selected features as reported by
[`glmnet::predict.glmnet()`](https://glmnet.stanford.edu/reference/predict.glmnet.html)
with `type` set to `"nonzero"`.

#### Usage

    LearnerRegrGlmnet$selected_features(lambda = NULL)

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

    LearnerRegrGlmnet$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
# Define the Learner and set parameter values
learner = lrn("regr.glmnet")
print(learner)
#> 
#> ── <LearnerRegrGlmnet> (regr.glmnet): GLM with Elastic Net Regularization ──────
#> • Model: -
#> • Parameters: family=gaussian, use_pred_offset=TRUE
#> • Packages: mlr3, mlr3learners, and glmnet
#> • Predict Types: [response]
#> • Feature Types: logical, integer, and numeric
#> • Encapsulation: none (fallback: -)
#> • Properties: offset and weights
#> • Other settings: use_weights = 'use'

# Define a Task
task = tsk("mtcars")

# Create train and test set
ids = partition(task)

# Train the learner on the training ids
learner$train(task, row_ids = ids$train)

# Print the model
print(learner$model)
#> 
#> Call:  (if (cv) glmnet::cv.glmnet else glmnet::glmnet)(x = data, y = target,      family = "gaussian") 
#> 
#>    Df  %Dev Lambda
#> 1   0  0.00 5.4050
#> 2   1 13.45 4.9250
#> 3   2 25.47 4.4880
#> 4   2 35.75 4.0890
#> 5   2 44.29 3.7260
#> 6   2 51.38 3.3950
#> 7   2 57.26 3.0930
#> 8   2 62.15 2.8180
#> 9   2 66.21 2.5680
#> 10  2 69.58 2.3400
#> 11  2 72.37 2.1320
#> 12  2 74.69 1.9430
#> 13  3 76.63 1.7700
#> 14  3 78.26 1.6130
#> 15  4 79.84 1.4700
#> 16  4 81.14 1.3390
#> 17  4 82.23 1.2200
#> 18  4 83.13 1.1120
#> 19  4 83.87 1.0130
#> 20  5 84.55 0.9229
#> 21  5 85.16 0.8409
#> 22  5 85.66 0.7662
#> 23  5 86.08 0.6981
#> 24  5 86.42 0.6361
#> 25  4 86.70 0.5796
#> 26  4 86.94 0.5281
#> 27  4 87.14 0.4812
#> 28  4 87.30 0.4385
#> 29  4 87.44 0.3995
#> 30  6 87.57 0.3640
#> 31  8 87.81 0.3317
#> 32  8 88.25 0.3022
#> 33  8 88.61 0.2754
#> 34  8 88.91 0.2509
#> 35  7 89.06 0.2286
#> 36  7 89.11 0.2083
#> 37  7 89.15 0.1898
#> 38  7 89.19 0.1729
#> 39  7 89.22 0.1576
#> 40  7 89.24 0.1436
#> 41  7 89.26 0.1308
#> 42  7 89.28 0.1192
#> 43  7 89.29 0.1086
#> 44  7 89.31 0.0990
#> 45  7 89.31 0.0902
#> 46  7 89.32 0.0822
#> 47  7 89.33 0.0749
#> 48  7 89.34 0.0682
#> 49  8 89.47 0.0621
#> 50  9 89.71 0.0566
#> 51  9 89.91 0.0516
#> 52  9 90.08 0.0470
#> 53  9 90.22 0.0428
#> 54  9 90.34 0.0390
#> 55 10 90.65 0.0356
#> 56 10 91.06 0.0324
#> 57 10 91.37 0.0295
#> 58 10 91.64 0.0269
#> 59 10 91.86 0.0245
#> 60 10 92.04 0.0223
#> 61 10 92.19 0.0204
#> 62 10 92.31 0.0185
#> 63 10 92.42 0.0169
#> 64 10 92.50 0.0154
#> 65 10 92.58 0.0140
#> 66 10 92.64 0.0128
#> 67 10 92.69 0.0117
#> 68 10 92.73 0.0106
#> 69 10 92.76 0.0097
#> 70 10 92.79 0.0088
#> 71 10 92.81 0.0080
#> 72 10 92.83 0.0073
#> 73 10 92.85 0.0067
#> 74 10 92.86 0.0061
#> 75 10 92.88 0.0055
#> 76 10 92.88 0.0050
#> 77 10 92.90 0.0046
#> 78 10 92.90 0.0042

# Importance method
if ("importance" %in% learner$properties) print(learner$importance)

# Make predictions for the test rows
predictions = learner$predict(task, row_ids = ids$test)
#> Warning: Multiple lambdas have been fit. Lambda will be set to 0.01 (see parameter 's').

# Score the predictions
predictions$score()
#> regr.mse 
#> 49.58993 
```
