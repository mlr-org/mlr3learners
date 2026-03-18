# Linear Discriminant Analysis Classification Learner

Linear discriminant analysis. Calls
[`MASS::lda()`](https://rdrr.io/pkg/MASS/man/lda.html) from package
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

    mlr_learners$get("classif.lda")
    lrn("classif.lda")

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
| dimen          | untyped   | \-      |                               | \-                    |
| method         | character | moment  | moment, mle, mve, t           | \-                    |
| nu             | integer   | \-      |                               | \\(-\infty, \infty)\\ |
| predict.method | character | plug-in | plug-in, predictive, debiased | \-                    |
| predict.prior  | untyped   | \-      |                               | \-                    |
| prior          | untyped   | \-      |                               | \-                    |
| tol            | numeric   | \-      |                               | \\(-\infty, \infty)\\ |

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
-\> `LearnerClassifLDA`

## Methods

### Public methods

- [`LearnerClassifLDA$new()`](#method-LearnerClassifLDA-new)

- [`LearnerClassifLDA$clone()`](#method-LearnerClassifLDA-clone)

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

    LearnerClassifLDA$new()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    LearnerClassifLDA$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
# Define the Learner and set parameter values
learner = lrn("classif.lda")
print(learner)
#> 
#> ── <LearnerClassifLDA> (classif.lda): Linear Discriminant Analysis ─────────────
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
#> lda(formula, data = task$data())
#> 
#> Prior probabilities of groups:
#>         M         R 
#> 0.5683453 0.4316547 
#> 
#> Group means:
#>           V1       V10       V11       V12       V13       V14       V15
#> M 0.03387089 0.2486405 0.2880025 0.3046646 0.3143266 0.3174886 0.3314139
#> R 0.02065167 0.1648700 0.1721000 0.1821167 0.2243267 0.2694383 0.3158467
#>         V16       V17       V18       V19         V2       V20      V21
#> M 0.3748975 0.4073241 0.4465785 0.5287114 0.04548354 0.6104582 0.661338
#> R 0.3869433 0.4177817 0.4338317 0.4461183 0.02706833 0.4904283 0.535965
#>         V22       V23       V24       V25       V26       V27       V28
#> M 0.6721506 0.6796076 0.6860405 0.6726772 0.6929759 0.7067924 0.7055861
#> R 0.5579800 0.6087700 0.6588733 0.6833000 0.7198517 0.7283800 0.7105317
#>         V29         V3       V30       V31       V32       V33       V34
#> M 0.6483861 0.05192152 0.5793152 0.4838316 0.4265329 0.3948797 0.3683468
#> R 0.6364433 0.03492667 0.5693350 0.5229700 0.4431833 0.4200067 0.4202883
#>         V35       V36       V37       V38       V39         V4       V40
#> M 0.3358608 0.3231620 0.3276228 0.3381759 0.3392000 0.06547595 0.3089684
#> R 0.4294083 0.4437883 0.4022517 0.3317000 0.3111667 0.04111333 0.3048633
#>         V41       V42     V43       V44       V45       V46        V47
#> M 0.2939873 0.3012519 0.27480 0.2480342 0.2474772 0.1998646 0.14533797
#> R 0.2680083 0.2279450 0.20125 0.1569350 0.1258133 0.1014250 0.08515167
#>          V48        V49         V5        V50        V51        V52         V53
#> M 0.11052278 0.06424177 0.08434937 0.02154051 0.01876076 0.01663797 0.011339241
#> R 0.06455667 0.03679833 0.06127500 0.01776500 0.01260667 0.01087167 0.009756667
#>           V54         V55         V56         V57         V58         V59
#> M 0.011962025 0.009921519 0.008825316 0.007694937 0.008582278 0.008159494
#> R 0.009526667 0.008200000 0.007326667 0.008295000 0.006646667 0.007186667
#>          V6         V60        V7        V8        V9
#> M 0.1105354 0.006540506 0.1204152 0.1432835 0.2111861
#> R 0.1023283 0.005896667 0.1169283 0.1232300 0.1442900
#> 
#> Coefficients of linear discriminants:
#>               LD1
#> V1   -8.890268985
#> V10   7.190173153
#> V11  -3.005999765
#> V12  -7.159285118
#> V13  -1.282358245
#> V14  -0.594399772
#> V15  -2.257851991
#> V16   1.643638951
#> V17   2.569629806
#> V18  -2.448963129
#> V19  -0.809302980
#> V2  -18.853474750
#> V20   1.068533111
#> V21   1.340858876
#> V22   0.008558469
#> V23  -0.644421437
#> V24  -4.738474369
#> V25   4.526107822
#> V26  -2.823098170
#> V27   2.536264503
#> V28  -1.488666624
#> V29   4.496251278
#> V3   18.839238037
#> V30  -9.378375784
#> V31  11.144500732
#> V32  -6.527262030
#> V33   1.126100349
#> V34   3.859403756
#> V35  -7.051394494
#> V36   7.081602914
#> V37  -0.150712186
#> V38  -0.702596705
#> V39  -5.004491795
#> V4  -10.803815415
#> V40   3.370774488
#> V41  -0.542808084
#> V42  -1.762399889
#> V43   5.772708966
#> V44  -7.576229914
#> V45   5.114554893
#> V46  -5.285887867
#> V47   4.375428979
#> V48 -13.774717313
#> V49 -14.951411997
#> V5    0.887670304
#> V50  27.613540005
#> V51  25.103058295
#> V52 -10.117630506
#> V53  25.876306471
#> V54 -48.992273961
#> V55 103.928819675
#> V56  23.432994415
#> V57  53.954079972
#> V58 -64.118064165
#> V59 -14.470917063
#> V6   -3.069784470
#> V60  71.067229702
#> V7   13.120029903
#> V8    0.819077708
#> V9   -4.212207660

# Importance method
if ("importance" %in% learner$properties) print(learner$importance())

# Make predictions for the test rows
predictions = learner$predict(task, row_ids = ids$test)

# Score the predictions
predictions$score()
#> classif.ce 
#>  0.3333333 
```
