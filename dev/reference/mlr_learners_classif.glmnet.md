# GLM with Elastic Net Regularization Classification Learner

Generalized linear models with elastic net regularization. Calls
[`glmnet::glmnet()`](https://glmnet.stanford.edu/reference/glmnet.html)
from package [glmnet](https://CRAN.R-project.org/package=glmnet).

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

    mlr_learners$get("classif.glmnet")
    lrn("classif.glmnet")

## Meta Information

- Task type: “classif”

- Predict Types: “response”, “prob”

- Feature Types: “logical”, “integer”, “numeric”

- Required Packages: [mlr3](https://CRAN.R-project.org/package=mlr3),
  [mlr3learners](https://CRAN.R-project.org/package=mlr3learners),
  [glmnet](https://CRAN.R-project.org/package=glmnet)

## Parameters

|                      |           |         |                         |                       |
|----------------------|-----------|---------|-------------------------|-----------------------|
| Id                   | Type      | Default | Levels                  | Range                 |
| alpha                | numeric   | 1       |                         | \\\[0, 1\]\\          |
| big                  | numeric   | 9.9e+35 |                         | \\(-\infty, \infty)\\ |
| devmax               | numeric   | 0.999   |                         | \\\[0, 1\]\\          |
| dfmax                | integer   | \-      |                         | \\\[0, \infty)\\      |
| eps                  | numeric   | 1e-06   |                         | \\\[0, 1\]\\          |
| epsnr                | numeric   | 1e-08   |                         | \\\[0, 1\]\\          |
| exact                | logical   | FALSE   | TRUE, FALSE             | \-                    |
| exclude              | integer   | \-      |                         | \\\[1, \infty)\\      |
| exmx                 | numeric   | 250     |                         | \\(-\infty, \infty)\\ |
| fdev                 | numeric   | 1e-05   |                         | \\\[0, 1\]\\          |
| gamma                | numeric   | 1       |                         | \\(-\infty, \infty)\\ |
| intercept            | logical   | TRUE    | TRUE, FALSE             | \-                    |
| lambda               | untyped   | \-      |                         | \-                    |
| lambda.min.ratio     | numeric   | \-      |                         | \\\[0, 1\]\\          |
| lower.limits         | untyped   | \-      |                         | \-                    |
| maxit                | integer   | 100000  |                         | \\\[1, \infty)\\      |
| mnlam                | integer   | 5       |                         | \\\[1, \infty)\\      |
| mxit                 | integer   | 100     |                         | \\\[1, \infty)\\      |
| mxitnr               | integer   | 25      |                         | \\\[1, \infty)\\      |
| nlambda              | integer   | 100     |                         | \\\[1, \infty)\\      |
| use_pred_offset      | logical   | \-      | TRUE, FALSE             | \-                    |
| penalty.factor       | untyped   | \-      |                         | \-                    |
| pmax                 | integer   | \-      |                         | \\\[0, \infty)\\      |
| pmin                 | numeric   | 1e-09   |                         | \\\[0, 1\]\\          |
| prec                 | numeric   | 1e-10   |                         | \\(-\infty, \infty)\\ |
| relax                | logical   | FALSE   | TRUE, FALSE             | \-                    |
| s                    | numeric   | 0.01    |                         | \\\[0, \infty)\\      |
| standardize          | logical   | TRUE    | TRUE, FALSE             | \-                    |
| standardize.response | logical   | FALSE   | TRUE, FALSE             | \-                    |
| thresh               | numeric   | 1e-07   |                         | \\\[0, \infty)\\      |
| trace.it             | integer   | 0       |                         | \\\[0, 1\]\\          |
| type.gaussian        | character | \-      | covariance, naive       | \-                    |
| type.logistic        | character | \-      | Newton, modified.Newton | \-                    |
| type.multinomial     | character | \-      | ungrouped, grouped      | \-                    |
| upper.limits         | untyped   | \-      |                         | \-                    |

## Internal Encoding

Starting with [mlr3](https://CRAN.R-project.org/package=mlr3) v0.5.0,
the order of class labels is reversed prior to model fitting to comply
to the [`stats::glm()`](https://rdrr.io/r/stats/glm.html) convention
that the negative class is provided as the first factor level.

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
[`mlr_learners_regr.glmnet`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.glmnet.md),
[`mlr_learners_regr.kknn`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.kknn.md),
[`mlr_learners_regr.km`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.km.md),
[`mlr_learners_regr.lm`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.lm.md),
[`mlr_learners_regr.nnet`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.nnet.md),
[`mlr_learners_regr.ranger`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.ranger.md),
[`mlr_learners_regr.svm`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.svm.md),
[`mlr_learners_regr.xgboost`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.xgboost.md)

## Super classes

[`mlr3::Learner`](https://mlr3.mlr-org.com/reference/Learner.html) -\>
[`mlr3::LearnerClassif`](https://mlr3.mlr-org.com/reference/LearnerClassif.html)
-\> `LearnerClassifGlmnet`

## Methods

### Public methods

- [`LearnerClassifGlmnet$new()`](#method-LearnerClassifGlmnet-new)

- [`LearnerClassifGlmnet$selected_features()`](#method-LearnerClassifGlmnet-selected_features)

- [`LearnerClassifGlmnet$clone()`](#method-LearnerClassifGlmnet-clone)

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
- [`mlr3::LearnerClassif$predict_newdata_fast()`](https://mlr3.mlr-org.com/reference/LearnerClassif.html#method-predict_newdata_fast)

------------------------------------------------------------------------

### Method `new()`

Creates a new instance of this
[R6](https://r6.r-lib.org/reference/R6Class.html) class.

#### Usage

    LearnerClassifGlmnet$new()

------------------------------------------------------------------------

### Method `selected_features()`

Returns the set of selected features as reported by
[`glmnet::predict.glmnet()`](https://glmnet.stanford.edu/reference/predict.glmnet.html)
with `type` set to `"nonzero"`.

#### Usage

    LearnerClassifGlmnet$selected_features(lambda = NULL)

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

    LearnerClassifGlmnet$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
# Define the Learner and set parameter values
learner = lrn("classif.glmnet")
print(learner)
#> 
#> ── <LearnerClassifGlmnet> (classif.glmnet): GLM with Elastic Net Regularization 
#> • Model: -
#> • Parameters: use_pred_offset=TRUE
#> • Packages: mlr3, mlr3learners, and glmnet
#> • Predict Types: [response] and prob
#> • Feature Types: logical, integer, and numeric
#> • Encapsulation: none (fallback: -)
#> • Properties: multiclass, offset, twoclass, and weights
#> • Other settings: use_weights = 'use'

# Define a Task
task = tsk("sonar")

# Create train and test set
ids = partition(task)

# Train the learner on the training ids
learner$train(task, row_ids = ids$train)

# Print the model
print(learner$model)
#> 
#> Call:  (if (cv) glmnet::cv.glmnet else glmnet::glmnet)(x = data, y = target,      family = "binomial") 
#> 
#>     Df  %Dev   Lambda
#> 1    0  0.00 0.220000
#> 2    2  2.84 0.200500
#> 3    2  6.12 0.182700
#> 4    2  8.92 0.166400
#> 5    2 11.34 0.151700
#> 6    3 13.57 0.138200
#> 7    4 16.23 0.125900
#> 8    4 18.66 0.114700
#> 9    4 20.79 0.104500
#> 10   6 22.87 0.095250
#> 11   7 24.99 0.086780
#> 12   8 27.05 0.079080
#> 13   8 28.98 0.072050
#> 14   8 30.71 0.065650
#> 15   9 32.81 0.059820
#> 16   9 34.73 0.054500
#> 17   9 36.45 0.049660
#> 18  11 38.18 0.045250
#> 19  13 40.12 0.041230
#> 20  13 41.90 0.037570
#> 21  15 43.69 0.034230
#> 22  15 45.40 0.031190
#> 23  16 46.95 0.028420
#> 24  18 48.54 0.025890
#> 25  20 50.10 0.023590
#> 26  21 51.66 0.021500
#> 27  21 53.09 0.019590
#> 28  22 54.50 0.017850
#> 29  23 55.88 0.016260
#> 30  24 57.15 0.014820
#> 31  26 58.42 0.013500
#> 32  25 59.69 0.012300
#> 33  28 60.88 0.011210
#> 34  31 62.42 0.010210
#> 35  31 64.03 0.009306
#> 36  32 65.54 0.008479
#> 37  33 67.00 0.007726
#> 38  36 68.46 0.007039
#> 39  38 70.09 0.006414
#> 40  39 71.65 0.005844
#> 41  40 73.21 0.005325
#> 42  39 74.71 0.004852
#> 43  40 76.07 0.004421
#> 44  41 77.39 0.004028
#> 45  42 78.67 0.003670
#> 46  42 80.06 0.003344
#> 47  40 81.23 0.003047
#> 48  43 82.42 0.002776
#> 49  43 83.59 0.002530
#> 50  43 84.74 0.002305
#> 51  46 85.87 0.002100
#> 52  46 86.99 0.001914
#> 53  47 88.05 0.001744
#> 54  47 89.05 0.001589
#> 55  48 90.00 0.001448
#> 56  48 90.87 0.001319
#> 57  48 91.68 0.001202
#> 58  48 92.42 0.001095
#> 59  48 93.10 0.000998
#> 60  48 93.72 0.000909
#> 61  48 94.28 0.000828
#> 62  47 94.79 0.000755
#> 63  47 95.25 0.000688
#> 64  47 95.67 0.000627
#> 65  47 96.05 0.000571
#> 66  47 96.40 0.000520
#> 67  47 96.71 0.000474
#> 68  47 97.00 0.000432
#> 69  47 97.27 0.000394
#> 70  48 97.51 0.000359
#> 71  48 97.73 0.000327
#> 72  48 97.93 0.000298
#> 73  48 98.11 0.000271
#> 74  48 98.28 0.000247
#> 75  48 98.43 0.000225
#> 76  48 98.57 0.000205
#> 77  48 98.69 0.000187
#> 78  48 98.81 0.000170
#> 79  48 98.91 0.000155
#> 80  48 99.01 0.000141
#> 81  48 99.10 0.000129
#> 82  48 99.17 0.000117
#> 83  48 99.25 0.000107
#> 84  48 99.31 0.000097
#> 85  48 99.37 0.000089
#> 86  48 99.43 0.000081
#> 87  48 99.48 0.000074
#> 88  48 99.52 0.000067
#> 89  48 99.57 0.000061
#> 90  48 99.60 0.000056
#> 91  48 99.64 0.000051
#> 92  48 99.67 0.000046
#> 93  48 99.70 0.000042
#> 94  48 99.72 0.000038
#> 95  48 99.75 0.000035
#> 96  48 99.77 0.000032
#> 97  49 99.79 0.000029
#> 98  49 99.81 0.000027
#> 99  49 99.82 0.000024
#> 100 49 99.84 0.000022

# Importance method
if ("importance" %in% learner$properties) print(learner$importance)

# Make predictions for the test rows
predictions = learner$predict(task, row_ids = ids$test)
#> Warning: Multiple lambdas have been fit. Lambda will be set to 0.01 (see parameter 's').

# Score the predictions
predictions$score()
#> classif.ce 
#>  0.3333333 
```
