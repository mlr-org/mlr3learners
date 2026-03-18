# Quadratic Discriminant Analysis Classification Learner

Quadratic discriminant analysis. Calls
[`MASS::qda()`](https://rdrr.io/pkg/MASS/man/qda.html) from package
[MASS](https://CRAN.R-project.org/package=MASS).

## Details

Parameters `method` and `prior` exist for training and prediction but
accept different values for each. Therefore, arguments for the predict
stage have been renamed to `predict.method` and `predict.prior`,
respectively.

## Dictionary

This [mlr3::Learner](https://mlr3.mlr-org.com/reference/Learner.html)
can be instantiated via the
[dictionary](https://mlr3misc.mlr-org.com/reference/Dictionary.html)
[mlr3::mlr_learners](https://mlr3.mlr-org.com/reference/mlr_learners.html)
or with the associated sugar function
[`mlr3::lrn()`](https://mlr3.mlr-org.com/reference/mlr_sugar.html):

    mlr_learners$get("classif.qda")
    lrn("classif.qda")

## Meta Information

- Task type: “classif”

- Predict Types: “response”, “prob”

- Feature Types: “logical”, “integer”, “numeric”, “factor”, “ordered”

- Required Packages: [mlr3](https://CRAN.R-project.org/package=mlr3),
  [mlr3learners](https://CRAN.R-project.org/package=mlr3learners),
  [MASS](https://CRAN.R-project.org/package=MASS)

## Parameters

|                |           |         |                               |                       |
|----------------|-----------|---------|-------------------------------|-----------------------|
| Id             | Type      | Default | Levels                        | Range                 |
| method         | character | moment  | moment, mle, mve, t           | \-                    |
| nu             | integer   | \-      |                               | \\(-\infty, \infty)\\ |
| predict.method | character | plug-in | plug-in, predictive, debiased | \-                    |
| predict.prior  | untyped   | \-      |                               | \-                    |
| prior          | untyped   | \-      |                               | \-                    |

## References

Venables WN, Ripley BD (2002). *Modern Applied Statistics with S*,
Fourth edition. Springer, New York. ISBN 0-387-95457-0,
<http://www.stats.ox.ac.uk/pub/MASS4/>.

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
-\> `LearnerClassifQDA`

## Methods

### Public methods

- [`LearnerClassifQDA$new()`](#method-LearnerClassifQDA-new)

- [`LearnerClassifQDA$clone()`](#method-LearnerClassifQDA-clone)

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
- [`mlr3::LearnerClassif$predict_newdata_fast()`](https://mlr3.mlr-org.com/reference/LearnerClassif.html#method-predict_newdata_fast)

------------------------------------------------------------------------

### Method `new()`

Creates a new instance of this
[R6](https://r6.r-lib.org/reference/R6Class.html) class.

#### Usage

    LearnerClassifQDA$new()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    LearnerClassifQDA$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
# Define the Learner and set parameter values
learner = lrn("classif.qda")
print(learner)
#> 
#> ── <LearnerClassifQDA> (classif.qda): Quadratic Discriminant Analysis ──────────
#> • Model: -
#> • Parameters: list()
#> • Packages: mlr3, mlr3learners, and MASS
#> • Predict Types: [response] and prob
#> • Feature Types: logical, integer, numeric, factor, and ordered
#> • Encapsulation: none (fallback: -)
#> • Properties: multiclass and twoclass
#> • Other settings: use_weights = 'error', predict_raw = 'FALSE'

# Define a Task
task = tsk("sonar")

# Create train and test set
ids = partition(task)

# Train the learner on the training ids
learner$train(task, row_ids = ids$train)

# Print the model
print(learner$model)
#> Call:
#> qda(task$formula(), data = task$data())
#> 
#> Prior probabilities of groups:
#>         M         R 
#> 0.5467626 0.4532374 
#> 
#> Group means:
#>           V1       V10       V11       V12       V13       V14       V15
#> M 0.03695789 0.2530645 0.2926500 0.2950513 0.3143513 0.3260289 0.3438368
#> R 0.02142857 0.1508635 0.1662968 0.1801683 0.2220095 0.2510492 0.2852016
#>         V16       V17       V18       V19         V2       V20       V21
#> M 0.3880829 0.4216592 0.4541868 0.5251434 0.04836053 0.6101474 0.6707592
#> R 0.3511127 0.3870873 0.4263571 0.4429921 0.02782857 0.4890063 0.5484762
#>         V22       V23       V24       V25       V26       V27       V28
#> M 0.6607947 0.6540829 0.6697421 0.6653105 0.6938342 0.6941026 0.7033684
#> R 0.5660730 0.6081571 0.6668333 0.6860429 0.7030937 0.7018079 0.6975873
#>         V29         V3       V30       V31       V32       V33       V34
#> M 0.6515776 0.05545526 0.5902329 0.4798132 0.4287382 0.3997329 0.3712829
#> R 0.6587063 0.03294603 0.5855429 0.5102556 0.4251968 0.4389365 0.4470968
#>         V35       V36       V37       V38       V39         V4       V40
#> M 0.3550553 0.3400329 0.3254553 0.3410303 0.3417224 0.07388158 0.3035711
#> R 0.4568794 0.4538587 0.3979254 0.3297492 0.2964762 0.04109206 0.3129460
#>         V41       V42       V43       V44       V45       V46       V47
#> M 0.2886816 0.2940092 0.2646237 0.2408276 0.2472868 0.1962053 0.1417316
#> R 0.2892429 0.2552270 0.2103667 0.1648810 0.1346921 0.1118000 0.0875000
#>          V48        V49         V5        V50        V51        V52         V53
#> M 0.10839079 0.06232237 0.09072763 0.02162895 0.02020395 0.01690921 0.012292105
#> R 0.06727619 0.03707778 0.06094127 0.01745238 0.01138254 0.00967619 0.009249206
#>          V54         V55         V56         V57         V58         V59
#> M 0.01222368 0.010247368 0.009053947 0.008336842 0.009419737 0.009213158
#> R 0.00987619 0.008638095 0.007193651 0.007939683 0.006093651 0.006473016
#>          V6         V60        V7        V8        V9
#> M 0.1185855 0.007480263 0.1344053 0.1589842 0.2191711
#> R 0.0971746 0.005744444 0.1140365 0.1131921 0.1324000

# Importance method
if ("importance" %in% learner$properties) print(learner$importance())

# Make predictions for the test rows
predictions = learner$predict(task, row_ids = ids$test)

# Score the predictions
predictions$score()
#> classif.ce 
#>  0.4202899 
```
