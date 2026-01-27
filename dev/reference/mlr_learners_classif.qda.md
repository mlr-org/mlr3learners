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
#> • Other settings: use_weights = 'error'

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
#> 0.5611511 0.4388489 
#> 
#> Group means:
#>           V1       V10       V11       V12       V13       V14       V15
#> M 0.03698077 0.2423141 0.2795538 0.2919692 0.3048179 0.3145115 0.3251295
#> R 0.02057869 0.1588607 0.1645246 0.1762426 0.2188066 0.2503852 0.2843836
#>         V16       V17       V18       V19         V2       V20       V21
#> M 0.3757256 0.4194551 0.4714192 0.5470051 0.04580897 0.6141897 0.6614308
#> R 0.3470279 0.3821098 0.4168590 0.4390836 0.02969508 0.4822852 0.5403377
#>         V22       V23       V24       V25       V26       V27       V28
#> M 0.6827449 0.7042692 0.7182256 0.7068974 0.7232359 0.7297705 0.7310013
#> R 0.5625852 0.6162557 0.6655016 0.6845820 0.7152115 0.6967131 0.6703295
#>         V29         V3       V30       V31       V32       V33       V34
#> M 0.6740397 0.05103718 0.5959692 0.4918372 0.4294154 0.3879038 0.3600064
#> R 0.6331377 0.03657377 0.5737639 0.5010525 0.4203951 0.4455754 0.4670410
#>         V35       V36       V37       V38       V39         V4       V40
#> M 0.3432526 0.3318167 0.3253474 0.3371859 0.3433359 0.06575641 0.3081987
#> R 0.4745607 0.4643787 0.4062246 0.3448180 0.3088787 0.04226885 0.3224230
#>         V41       V42       V43       V44       V45       V46        V47
#> M 0.2916872 0.3009192 0.2763551 0.2475897 0.2375449 0.1963564 0.14834231
#> R 0.2998770 0.2661279 0.2173197 0.1650623 0.1372754 0.1146787 0.08747705
#>          V48        V49         V5        V50        V51        V52        V53
#> M 0.11016282 0.06427692 0.08979615 0.02267051 0.01840513 0.01547051 0.01106410
#> R 0.06692459 0.03653279 0.06482623 0.01734754 0.01243115 0.01012623 0.00904918
#>           V54         V55         V56         V57         V58         V59
#> M 0.012025641 0.009779487 0.009173077 0.007882051 0.008783333 0.009057692
#> R 0.009836066 0.008377049 0.007121311 0.007224590 0.006080328 0.006544262
#>           V6         V60        V7        V8        V9
#> M 0.11195897 0.007244872 0.1263192 0.1444910 0.2001846
#> R 0.09835246 0.005824590 0.1108443 0.1068672 0.1329164

# Importance method
if ("importance" %in% learner$properties) print(learner$importance())

# Make predictions for the test rows
predictions = learner$predict(task, row_ids = ids$test)

# Score the predictions
predictions$score()
#> classif.ce 
#>  0.5217391 
```
