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
| use_pred_offset      | logical   | \-       | TRUE, FALSE             | \-                    |
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
#> 1   0  0.00 5.5110
#> 2   1 13.77 5.0210
#> 3   1 25.21 4.5750
#> 4   1 34.70 4.1690
#> 5   1 42.58 3.7990
#> 6   1 49.13 3.4610
#> 7   1 54.56 3.1540
#> 8   2 59.35 2.8730
#> 9   3 63.65 2.6180
#> 10  3 67.44 2.3860
#> 11  3 70.58 2.1740
#> 12  3 73.19 1.9810
#> 13  3 75.35 1.8050
#> 14  3 77.15 1.6440
#> 15  3 78.64 1.4980
#> 16  3 79.88 1.3650
#> 17  3 80.91 1.2440
#> 18  3 81.77 1.1330
#> 19  3 82.48 1.0330
#> 20  3 83.07 0.9409
#> 21  3 83.55 0.8573
#> 22  3 83.96 0.7812
#> 23  3 84.30 0.7118
#> 24  4 84.64 0.6485
#> 25  4 85.02 0.5909
#> 26  4 85.32 0.5384
#> 27  3 85.58 0.4906
#> 28  4 85.82 0.4470
#> 29  4 86.03 0.4073
#> 30  5 86.32 0.3711
#> 31  5 86.56 0.3382
#> 32  5 86.76 0.3081
#> 33  5 86.92 0.2807
#> 34  5 87.06 0.2558
#> 35  5 87.18 0.2331
#> 36  5 87.27 0.2124
#> 37  5 87.35 0.1935
#> 38  5 87.42 0.1763
#> 39  5 87.47 0.1607
#> 40  5 87.52 0.1464
#> 41  5 87.56 0.1334
#> 42  5 87.59 0.1215
#> 43  5 87.61 0.1107
#> 44  5 87.63 0.1009
#> 45  5 87.65 0.0919
#> 46  6 87.74 0.0838
#> 47  6 88.04 0.0763
#> 48  6 88.29 0.0695
#> 49  6 88.50 0.0634
#> 50  5 88.59 0.0577
#> 51  5 88.65 0.0526
#> 52  5 88.71 0.0479
#> 53  5 88.76 0.0437
#> 54  6 88.83 0.0398
#> 55  7 88.89 0.0363
#> 56  8 89.01 0.0330
#> 57  8 89.12 0.0301
#> 58  8 89.22 0.0274
#> 59  9 89.32 0.0250
#> 60  9 89.42 0.0228
#> 61  9 89.50 0.0208
#> 62  9 89.57 0.0189
#> 63  9 89.62 0.0172
#> 64  9 89.67 0.0157
#> 65  9 89.71 0.0143
#> 66  9 89.74 0.0130
#> 67  9 89.76 0.0119
#> 68  9 89.79 0.0108
#> 69  9 89.80 0.0099
#> 70  9 89.82 0.0090
#> 71  9 89.83 0.0082
#> 72  9 89.84 0.0075
#> 73  9 89.85 0.0068
#> 74  9 89.86 0.0062
#> 75  9 89.87 0.0056
#> 76  9 89.87 0.0051
#> 77  9 89.88 0.0047
#> 78  9 89.88 0.0043
#> 79  9 89.88 0.0039
#> 80  9 89.89 0.0035
#> 81  9 89.89 0.0032
#> 82  9 89.89 0.0029
#> 83  9 89.89 0.0027
#> 84  9 89.89 0.0024
#> 85  9 89.89 0.0022

# Importance method
if ("importance" %in% learner$properties) print(learner$importance())

# Make predictions for the test rows
predictions = learner$predict(task, row_ids = ids$test)
#> Warning: Multiple lambdas have been fit. Lambda will be set to 0.01 (see parameter 's').

# Score the predictions
predictions$score()
#> regr.mse 
#> 9.376749 
```
