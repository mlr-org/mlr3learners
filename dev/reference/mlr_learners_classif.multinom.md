# Multinomial log-linear learner via neural networks

Multinomial log-linear models via neural networks. Calls
[`nnet::multinom()`](https://rdrr.io/pkg/nnet/man/multinom.html) from
package [nnet](https://CRAN.R-project.org/package=nnet).

## Dictionary

This [mlr3::Learner](https://mlr3.mlr-org.com/reference/Learner.html)
can be instantiated via the
[dictionary](https://mlr3misc.mlr-org.com/reference/Dictionary.html)
[mlr3::mlr_learners](https://mlr3.mlr-org.com/reference/mlr_learners.html)
or with the associated sugar function
[`mlr3::lrn()`](https://mlr3.mlr-org.com/reference/mlr_sugar.html):

    mlr_learners$get("classif.multinom")
    lrn("classif.multinom")

## Meta Information

- Task type: “classif”

- Predict Types: “response”, “prob”

- Feature Types: “logical”, “integer”, “numeric”, “factor”

- Required Packages: [mlr3](https://CRAN.R-project.org/package=mlr3),
  [mlr3learners](https://CRAN.R-project.org/package=mlr3learners),
  [nnet](https://CRAN.R-project.org/package=nnet)

## Parameters

|          |           |         |             |                       |
|----------|-----------|---------|-------------|-----------------------|
| Id       | Type      | Default | Levels      | Range                 |
| Hess     | logical   | FALSE   | TRUE, FALSE | \-                    |
| abstol   | numeric   | 1e-04   |             | \\(-\infty, \infty)\\ |
| censored | logical   | FALSE   | TRUE, FALSE | \-                    |
| decay    | numeric   | 0       |             | \\(-\infty, \infty)\\ |
| entropy  | logical   | FALSE   | TRUE, FALSE | \-                    |
| mask     | untyped   | \-      |             | \-                    |
| maxit    | integer   | 100     |             | \\\[1, \infty)\\      |
| MaxNWts  | integer   | 1000    |             | \\\[1, \infty)\\      |
| model    | logical   | FALSE   | TRUE, FALSE | \-                    |
| linout   | logical   | FALSE   | TRUE, FALSE | \-                    |
| rang     | numeric   | 0.7     |             | \\(-\infty, \infty)\\ |
| reltol   | numeric   | 1e-08   |             | \\(-\infty, \infty)\\ |
| size     | integer   | \-      |             | \\\[1, \infty)\\      |
| skip     | logical   | FALSE   | TRUE, FALSE | \-                    |
| softmax  | logical   | FALSE   | TRUE, FALSE | \-                    |
| summ     | character | 0       | 0, 1, 2, 3  | \-                    |
| trace    | logical   | TRUE    | TRUE, FALSE | \-                    |
| Wts      | untyped   | \-      |             | \-                    |

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
-\> `LearnerClassifMultinom`

## Methods

### Public methods

- [`LearnerClassifMultinom$new()`](#method-LearnerClassifMultinom-new)

- [`LearnerClassifMultinom$clone()`](#method-LearnerClassifMultinom-clone)

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

    LearnerClassifMultinom$new()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    LearnerClassifMultinom$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
# Define the Learner and set parameter values
learner = lrn("classif.multinom")
print(learner)
#> 
#> ── <LearnerClassifMultinom> (classif.multinom): Multinomial Log-Linear Model ───
#> • Model: -
#> • Parameters: list()
#> • Packages: mlr3, mlr3learners, and nnet
#> • Predict Types: [response] and prob
#> • Feature Types: logical, integer, numeric, and factor
#> • Encapsulation: none (fallback: -)
#> • Properties: multiclass, twoclass, and weights
#> • Other settings: use_weights = 'use', predict_raw = 'FALSE'

# Define a Task
task = tsk("sonar")

# Create train and test set
ids = partition(task)

# Train the learner on the training ids
learner$train(task, row_ids = ids$train)
#> # weights:  62 (61 variable)
#> initial  value 96.347458 
#> iter  10 value 28.060727
#> iter  20 value 1.899489
#> iter  30 value 0.003516
#> final  value 0.000058 
#> converged

# Print the model
print(learner$model)
#> Call:
#> nnet::multinom(formula = Class ~ ., data = task$data())
#> 
#> Coefficients:
#> (Intercept)          V1         V10         V11         V12         V13 
#>   606.48499  -292.62216  -142.11791  -588.13233   -88.06081  -314.66330 
#>         V14         V15         V16         V17         V18         V19 
#>  -134.59359   380.41387   -93.35268   203.69452    83.21463    30.36906 
#>          V2         V20         V21         V22         V23         V24 
#>  -208.73362  -213.45852  -335.38329   104.26954   -54.17037  -522.82205 
#>         V25         V26         V27         V28         V29          V3 
#>   700.21783  -201.29489  -279.93755   276.00581  -122.70963   -55.82210 
#>         V30         V31         V32         V33         V34         V35 
#>    39.08240    57.62629   -86.84656  -265.38407   345.24797  -149.54434 
#>         V36         V37         V38         V39          V4         V40 
#>   165.80103   677.99313  -323.04585  -410.21814  -506.70203   468.79101 
#>         V41         V42         V43         V44         V45         V46 
#>   -74.72936  -118.46404  -278.18165  -225.21560  -453.56885  -472.40222 
#>         V47         V48         V49          V5         V50         V51 
#>    29.90197  -336.13828  -343.42369  -451.68864   137.03675  -117.66505 
#>         V52         V53         V54         V55         V56         V57 
#>   -92.13127   -31.72623   -40.72676    44.68332    46.71611    53.03701 
#>         V58         V59          V6         V60          V7          V8 
#>   -34.35565   -51.57852  -168.28882    10.24126   163.11532   640.56455 
#>          V9 
#>   -57.59101 
#> 
#> Residual Deviance: 0.0001159859 
#> AIC: 122.0001 

# Importance method
if ("importance" %in% learner$properties) print(learner$importance())

# Make predictions for the test rows
predictions = learner$predict(task, row_ids = ids$test)

# Score the predictions
predictions$score()
#> classif.ce 
#>  0.2463768 
```
