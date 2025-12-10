# Classification Neural Network Learner

Single Layer Neural Network. Calls
[`nnet::nnet.formula()`](https://rdrr.io/pkg/nnet/man/nnet.html) from
package [nnet](https://CRAN.R-project.org/package=nnet).

Note that modern neural networks with multiple layers are connected via
package [mlr3torch](https://github.com/mlr-org/mlr3torch).

## Dictionary

This [mlr3::Learner](https://mlr3.mlr-org.com/reference/Learner.html)
can be instantiated via the
[dictionary](https://mlr3misc.mlr-org.com/reference/Dictionary.html)
[mlr3::mlr_learners](https://mlr3.mlr-org.com/reference/mlr_learners.html)
or with the associated sugar function
[`mlr3::lrn()`](https://mlr3.mlr-org.com/reference/mlr_sugar.html):

    mlr_learners$get("classif.nnet")
    lrn("classif.nnet")

## Meta Information

- Task type: “classif”

- Predict Types: “response”, “prob”

- Feature Types: “logical”, “integer”, “numeric”, “factor”, “ordered”

- Required Packages: [mlr3](https://CRAN.R-project.org/package=mlr3),
  [mlr3learners](https://CRAN.R-project.org/package=mlr3learners),
  [nnet](https://CRAN.R-project.org/package=nnet)

## Parameters

|           |         |         |             |                       |
|-----------|---------|---------|-------------|-----------------------|
| Id        | Type    | Default | Levels      | Range                 |
| Hess      | logical | FALSE   | TRUE, FALSE | \-                    |
| MaxNWts   | integer | 1000    |             | \\\[1, \infty)\\      |
| Wts       | untyped | \-      |             | \-                    |
| abstol    | numeric | 1e-04   |             | \\(-\infty, \infty)\\ |
| censored  | logical | FALSE   | TRUE, FALSE | \-                    |
| contrasts | untyped | NULL    |             | \-                    |
| decay     | numeric | 0       |             | \\(-\infty, \infty)\\ |
| mask      | untyped | \-      |             | \-                    |
| maxit     | integer | 100     |             | \\\[1, \infty)\\      |
| na.action | untyped | \-      |             | \-                    |
| rang      | numeric | 0.7     |             | \\(-\infty, \infty)\\ |
| reltol    | numeric | 1e-08   |             | \\(-\infty, \infty)\\ |
| size      | integer | 3       |             | \\\[0, \infty)\\      |
| skip      | logical | FALSE   | TRUE, FALSE | \-                    |
| subset    | untyped | \-      |             | \-                    |
| trace     | logical | TRUE    | TRUE, FALSE | \-                    |
| formula   | untyped | \-      |             | \-                    |

## Initial parameter values

- `size`:

  - Adjusted default: 3L.

  - Reason for change: no default in `nnet()`.

## Custom mlr3 parameters

- `formula`: if not provided, the formula is set to `task$formula()`.

## References

Ripley BD (1996). *Pattern Recognition and Neural Networks*. Cambridge
University Press.
[doi:10.1017/cbo9780511812651](https://doi.org/10.1017/cbo9780511812651)
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
-\> `LearnerClassifNnet`

## Methods

### Public methods

- [`LearnerClassifNnet$new()`](#method-LearnerClassifNnet-new)

- [`LearnerClassifNnet$clone()`](#method-LearnerClassifNnet-clone)

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

    LearnerClassifNnet$new()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    LearnerClassifNnet$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
# Define the Learner and set parameter values
learner = lrn("classif.nnet")
print(learner)
#> 
#> ── <LearnerClassifNnet> (classif.nnet): Single Layer Neural Network ────────────
#> • Model: -
#> • Parameters: size=3
#> • Packages: mlr3, mlr3learners, and nnet
#> • Predict Types: response and [prob]
#> • Feature Types: logical, integer, numeric, factor, and ordered
#> • Encapsulation: none (fallback: -)
#> • Properties: multiclass, twoclass, and weights
#> • Other settings: use_weights = 'use'

# Define a Task
task = tsk("sonar")

# Create train and test set
ids = partition(task)

# Train the learner on the training ids
learner$train(task, row_ids = ids$train)
#> # weights:  187
#> initial  value 120.824794 
#> iter  10 value 71.033272
#> iter  20 value 31.614906
#> iter  30 value 26.888788
#> iter  40 value 26.793799
#> iter  50 value 26.792747
#> final  value 26.792675 
#> converged

# Print the model
print(learner$model)
#> a 60-3-1 network with 187 weights
#> inputs: V1 V10 V11 V12 V13 V14 V15 V16 V17 V18 V19 V2 V20 V21 V22 V23 V24 V25 V26 V27 V28 V29 V3 V30 V31 V32 V33 V34 V35 V36 V37 V38 V39 V4 V40 V41 V42 V43 V44 V45 V46 V47 V48 V49 V5 V50 V51 V52 V53 V54 V55 V56 V57 V58 V59 V6 V60 V7 V8 V9 
#> output(s): Class 
#> options were - entropy fitting 

# Importance method
if ("importance" %in% learner$properties) print(learner$importance)

# Make predictions for the test rows
predictions = learner$predict(task, row_ids = ids$test)

# Score the predictions
predictions$score()
#> classif.ce 
#>   0.115942 
```
