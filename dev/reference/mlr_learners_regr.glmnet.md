# GLM with Elastic Net Regularization Regression Learner

Generalized linear models with elastic net regularization. Calls
[`glmnet::glmnet()`](https://rdrr.io/pkg/glmnet/man/glmnet.html) from
package [glmnet](https://CRAN.R-project.org/package=glmnet).

The default for hyperparameter `family` is set to `"gaussian"`.

## Details

Caution: This learner is different to learners calling
[`glmnet::cv.glmnet()`](https://rdrr.io/pkg/glmnet/man/cv.glmnet.html)
in that it does not use the internal optimization of parameter `lambda`.
Instead, `lambda` needs to be tuned by the user (e.g., via
[mlr3tuning](https://CRAN.R-project.org/package=mlr3tuning)). When
`lambda` is tuned, the `glmnet` will be trained for each tuning
iteration. While fitting the whole path of `lambda`s would be more
efficient, as is done by default in
[`glmnet::glmnet()`](https://rdrr.io/pkg/glmnet/man/glmnet.html),
tuning/selecting the parameter at prediction time (using parameter `s`)
is currently not supported in
[mlr3](https://CRAN.R-project.org/package=mlr3) (at least not in an
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
[`glmnet::glmnet()`](https://rdrr.io/pkg/glmnet/man/glmnet.html). During
prediction, the offset column from the test set is used only if
`use_pred_offset = TRUE` (default), passed via the `newoffset` argument
in
[`glmnet::predict.glmnet()`](https://rdrr.io/pkg/glmnet/man/predict.glmnet.html).
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
[`glmnet::predict.glmnet()`](https://rdrr.io/pkg/glmnet/man/predict.glmnet.html)
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
#> • Other settings: use_weights = 'use', predict_raw = 'FALSE'

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
#> 1   0  0.00 5.0300
#> 2   1 12.24 4.5830
#> 3   3 23.28 4.1760
#> 4   3 32.86 3.8050
#> 5   3 40.82 3.4670
#> 6   3 47.43 3.1590
#> 7   3 52.91 2.8780
#> 8   3 57.46 2.6230
#> 9   3 61.24 2.3900
#> 10  3 64.38 2.1770
#> 11  3 66.99 1.9840
#> 12  3 69.15 1.8080
#> 13  4 71.03 1.6470
#> 14  4 72.84 1.5010
#> 15  4 74.34 1.3670
#> 16  4 75.60 1.2460
#> 17  4 76.63 1.1350
#> 18  5 77.63 1.0340
#> 19  5 79.12 0.9426
#> 20  5 80.36 0.8588
#> 21  4 81.20 0.7825
#> 22  5 81.91 0.7130
#> 23  5 82.50 0.6497
#> 24  5 83.00 0.5919
#> 25  5 83.40 0.5394
#> 26  5 83.75 0.4914
#> 27  6 84.03 0.4478
#> 28  6 84.36 0.4080
#> 29  6 84.62 0.3718
#> 30  6 84.83 0.3387
#> 31  6 85.01 0.3086
#> 32  6 85.16 0.2812
#> 33  6 85.28 0.2562
#> 34  6 85.38 0.2335
#> 35  6 85.47 0.2127
#> 36  6 85.54 0.1938
#> 37  6 85.59 0.1766
#> 38  6 85.64 0.1609
#> 39  6 85.68 0.1466
#> 40  7 85.73 0.1336
#> 41  7 86.06 0.1217
#> 42  8 86.50 0.1109
#> 43  8 87.11 0.1011
#> 44  9 87.62 0.0921
#> 45  9 88.24 0.0839
#> 46  9 88.77 0.0765
#> 47  9 89.22 0.0697
#> 48  9 89.58 0.0635
#> 49  8 89.89 0.0578
#> 50  8 90.13 0.0527
#> 51  8 90.34 0.0480
#> 52  9 90.52 0.0437
#> 53  9 90.70 0.0399
#> 54  9 90.84 0.0363
#> 55 10 90.97 0.0331
#> 56 10 91.08 0.0302
#> 57 10 91.18 0.0275
#> 58 10 91.26 0.0250
#> 59 10 91.33 0.0228
#> 60 10 91.38 0.0208
#> 61 10 91.43 0.0189
#> 62 10 91.47 0.0173
#> 63 10 91.50 0.0157
#> 64 10 91.53 0.0143
#> 65 10 91.55 0.0131
#> 66 10 91.57 0.0119
#> 67 10 91.58 0.0108
#> 68 10 91.60 0.0099
#> 69 10 91.61 0.0090
#> 70 10 91.61 0.0082
#> 71 10 91.62 0.0075
#> 72 10 91.63 0.0068
#> 73 10 91.63 0.0062
#> 74 10 91.64 0.0056
#> 75 10 91.64 0.0051
#> 76 10 91.64 0.0047
#> 77 10 91.65 0.0043
#> 78 10 91.65 0.0039
#> 79 10 91.65 0.0035
#> 80 10 91.65 0.0032
#> 81 10 91.65 0.0029
#> 82 10 91.65 0.0027
#> 83 10 91.65 0.0024

# Importance method
if ("importance" %in% learner$properties) print(learner$importance())

# Make predictions for the test rows
predictions = learner$predict(task, row_ids = ids$test)
#> Warning: Multiple lambdas have been fit. Lambda will be set to 0.01 (see parameter 's').

# Score the predictions
predictions$score()
#> regr.mse 
#> 62.40119 
```
