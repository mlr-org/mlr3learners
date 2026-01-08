# k-Nearest-Neighbor Regression Learner

k-Nearest-Neighbor regression. Calls
[`kknn::kknn()`](https://rdrr.io/pkg/kknn/man/kknn.html) from package
[kknn](https://CRAN.R-project.org/package=kknn).

## Note

There is no training step for k-NN models, just storing the training
data to process it during the predict step. Therefore, `$model` returns
a list with the following elements:

- `formula`: Formula for calling
  [`kknn::kknn()`](https://rdrr.io/pkg/kknn/man/kknn.html) during
  `$predict()`.

- `data`: Training data for calling
  [`kknn::kknn()`](https://rdrr.io/pkg/kknn/man/kknn.html) during
  `$predict()`.

- `pv`: Training parameters for calling
  [`kknn::kknn()`](https://rdrr.io/pkg/kknn/man/kknn.html) during
  `$predict()`.

- `kknn`: Model as returned by
  [`kknn::kknn()`](https://rdrr.io/pkg/kknn/man/kknn.html), only
  available **after** `$predict()` has been called. This is not stored
  by default, you must set hyperparameter `store_model` to `TRUE`.

## Initial parameter values

- `store_model`:

  - See note.

## Dictionary

This [mlr3::Learner](https://mlr3.mlr-org.com/reference/Learner.html)
can be instantiated via the
[dictionary](https://mlr3misc.mlr-org.com/reference/Dictionary.html)
[mlr3::mlr_learners](https://mlr3.mlr-org.com/reference/mlr_learners.html)
or with the associated sugar function
[`mlr3::lrn()`](https://mlr3.mlr-org.com/reference/mlr_sugar.html):

    mlr_learners$get("regr.kknn")
    lrn("regr.kknn")

## Meta Information

- Task type: “regr”

- Predict Types: “response”

- Feature Types: “logical”, “integer”, “numeric”, “factor”, “ordered”

- Required Packages: [mlr3](https://CRAN.R-project.org/package=mlr3),
  [mlr3learners](https://CRAN.R-project.org/package=mlr3learners),
  [kknn](https://CRAN.R-project.org/package=kknn)

## Parameters

|             |           |         |                                                                                               |                  |
|-------------|-----------|---------|-----------------------------------------------------------------------------------------------|------------------|
| Id          | Type      | Default | Levels                                                                                        | Range            |
| k           | integer   | 7       |                                                                                               | \\\[1, \infty)\\ |
| distance    | numeric   | 2       |                                                                                               | \\\[0, \infty)\\ |
| kernel      | character | optimal | rectangular, triangular, epanechnikov, biweight, triweight, cos, inv, gaussian, rank, optimal | \-               |
| scale       | logical   | TRUE    | TRUE, FALSE                                                                                   | \-               |
| ykernel     | untyped   | NULL    |                                                                                               | \-               |
| store_model | logical   | FALSE   | TRUE, FALSE                                                                                   | \-               |

## References

Hechenbichler, Klaus, Schliep, Klaus (2004). “Weighted
k-nearest-neighbor techniques and ordinal classification.” Technical
Report Discussion Paper 399, SFB 386, Ludwig-Maximilians University
Munich.
[doi:10.5282/ubm/epub.1769](https://doi.org/10.5282/ubm/epub.1769) .

Samworth, J R (2012). “Optimal weighted nearest neighbour classifiers.”
*The Annals of Statistics*, **40**(5), 2733–2763.
[doi:10.1214/12-AOS1049](https://doi.org/10.1214/12-AOS1049) .

Cover, Thomas, Hart, Peter (1967). “Nearest neighbor pattern
classification.” *IEEE transactions on information theory*, **13**(1),
21–27.
[doi:10.1109/TIT.1967.1053964](https://doi.org/10.1109/TIT.1967.1053964)
.

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
[`mlr_learners_regr.glmnet`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.glmnet.md),
[`mlr_learners_regr.km`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.km.md),
[`mlr_learners_regr.lm`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.lm.md),
[`mlr_learners_regr.nnet`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.nnet.md),
[`mlr_learners_regr.ranger`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.ranger.md),
[`mlr_learners_regr.svm`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.svm.md),
[`mlr_learners_regr.xgboost`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.xgboost.md)

## Super classes

[`mlr3::Learner`](https://mlr3.mlr-org.com/reference/Learner.html) -\>
[`mlr3::LearnerRegr`](https://mlr3.mlr-org.com/reference/LearnerRegr.html)
-\> `LearnerRegrKKNN`

## Methods

### Public methods

- [`LearnerRegrKKNN$new()`](#method-LearnerRegrKKNN-new)

- [`LearnerRegrKKNN$clone()`](#method-LearnerRegrKKNN-clone)

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
- [`mlr3::Learner$selected_features()`](https://mlr3.mlr-org.com/reference/Learner.html#method-selected_features)
- [`mlr3::Learner$train()`](https://mlr3.mlr-org.com/reference/Learner.html#method-train)
- [`mlr3::LearnerRegr$predict_newdata_fast()`](https://mlr3.mlr-org.com/reference/LearnerRegr.html#method-predict_newdata_fast)

------------------------------------------------------------------------

### Method `new()`

Creates a new instance of this
[R6](https://r6.r-lib.org/reference/R6Class.html) class.

#### Usage

    LearnerRegrKKNN$new()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    LearnerRegrKKNN$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
# Define the Learner and set parameter values
learner = lrn("regr.kknn")
print(learner)
#> 
#> ── <LearnerRegrKKNN> (regr.kknn): k-Nearest-Neighbor ───────────────────────────
#> • Model: -
#> • Parameters: k=7
#> • Packages: mlr3, mlr3learners, and kknn
#> • Predict Types: [response]
#> • Feature Types: logical, integer, numeric, factor, and ordered
#> • Encapsulation: none (fallback: -)
#> • Properties:
#> • Other settings: use_weights = 'error'

# Define a Task
task = tsk("mtcars")

# Create train and test set
ids = partition(task)

# Train the learner on the training ids
learner$train(task, row_ids = ids$train)

# Print the model
print(learner$model)
#> $formula
#> mpg ~ .
#> NULL
#> 
#> $data
#>       mpg    am  carb   cyl  disp  drat  gear    hp  qsec    vs    wt
#>     <num> <num> <num> <num> <num> <num> <num> <num> <num> <num> <num>
#>  1:  21.0     1     4     6 160.0  3.90     4   110 16.46     0 2.620
#>  2:  22.8     1     1     4 108.0  3.85     4    93 18.61     1 2.320
#>  3:  18.7     0     2     8 360.0  3.15     3   175 17.02     0 3.440
#>  4:  18.1     0     1     6 225.0  2.76     3   105 20.22     1 3.460
#>  5:  14.3     0     4     8 360.0  3.21     3   245 15.84     0 3.570
#>  6:  19.2     0     4     6 167.6  3.92     4   123 18.30     1 3.440
#>  7:  16.4     0     3     8 275.8  3.07     3   180 17.40     0 4.070
#>  8:  15.2     0     3     8 275.8  3.07     3   180 18.00     0 3.780
#>  9:  10.4     0     4     8 472.0  2.93     3   205 17.98     0 5.250
#> 10:  10.4     0     4     8 460.0  3.00     3   215 17.82     0 5.424
#> 11:  14.7     0     4     8 440.0  3.23     3   230 17.42     0 5.345
#> 12:  32.4     1     1     4  78.7  4.08     4    66 19.47     1 2.200
#> 13:  15.5     0     2     8 318.0  2.76     3   150 16.87     0 3.520
#> 14:  15.2     0     2     8 304.0  3.15     3   150 17.30     0 3.435
#> 15:  19.2     0     2     8 400.0  3.08     3   175 17.05     0 3.845
#> 16:  27.3     1     1     4  79.0  4.08     4    66 18.90     1 1.935
#> 17:  26.0     1     2     4 120.3  4.43     5    91 16.70     0 2.140
#> 18:  30.4     1     2     4  95.1  3.77     5   113 16.90     1 1.513
#> 19:  15.8     1     4     8 351.0  4.22     5   264 14.50     0 3.170
#> 20:  19.7     1     6     6 145.0  3.62     5   175 15.50     0 2.770
#> 21:  15.0     1     8     8 301.0  3.54     5   335 14.60     0 3.570
#>       mpg    am  carb   cyl  disp  drat  gear    hp  qsec    vs    wt
#>     <num> <num> <num> <num> <num> <num> <num> <num> <num> <num> <num>
#> 
#> $pv
#> $pv$k
#> [1] 7
#> 
#> 
#> $kknn
#> NULL
#> 

# Importance method
if ("importance" %in% learner$properties) print(learner$importance)

# Make predictions for the test rows
predictions = learner$predict(task, row_ids = ids$test)

# Score the predictions
predictions$score()
#> regr.mse 
#> 10.70219 
```
