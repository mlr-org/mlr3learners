# Neural Network Regression Learner

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

    mlr_learners$get("regr.nnet")
    lrn("regr.nnet")

## Meta Information

- Task type: “regr”

- Predict Types: “response”

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
[`mlr_learners_classif.cv_glmnet`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.cv_glmnet.md),
[`mlr_learners_classif.glmnet`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.glmnet.md),
[`mlr_learners_classif.kknn`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.kknn.md),
[`mlr_learners_classif.lda`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.lda.md),
[`mlr_learners_classif.log_reg`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.log_reg.md),
[`mlr_learners_classif.multinom`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.multinom.md),
[`mlr_learners_classif.naive_bayes`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.naive_bayes.md),
[`mlr_learners_classif.nnet`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.nnet.md),
[`mlr_learners_classif.qda`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.qda.md),
[`mlr_learners_classif.ranger`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.ranger.md),
[`mlr_learners_classif.svm`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.svm.md),
[`mlr_learners_classif.xgboost`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.xgboost.md),
[`mlr_learners_regr.cv_glmnet`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.cv_glmnet.md),
[`mlr_learners_regr.glmnet`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.glmnet.md),
[`mlr_learners_regr.kknn`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.kknn.md),
[`mlr_learners_regr.km`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.km.md),
[`mlr_learners_regr.lm`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.lm.md),
[`mlr_learners_regr.ranger`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.ranger.md),
[`mlr_learners_regr.svm`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.svm.md),
[`mlr_learners_regr.xgboost`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.xgboost.md)

## Super classes

[`mlr3::Learner`](https://mlr3.mlr-org.com/reference/Learner.html) -\>
[`mlr3::LearnerRegr`](https://mlr3.mlr-org.com/reference/LearnerRegr.html)
-\> `LearnerRegrNnet`

## Methods

### Public methods

- [`LearnerRegrNnet$new()`](#method-LearnerRegrNnet-new)

- [`LearnerRegrNnet$clone()`](#method-LearnerRegrNnet-clone)

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

    LearnerRegrNnet$new()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    LearnerRegrNnet$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
# Define the Learner and set parameter values
learner = lrn("regr.nnet")
print(learner)
#> 
#> ── <LearnerRegrNnet> (regr.nnet): Single Layer Neural Network ──────────────────
#> • Model: -
#> • Parameters: size=3
#> • Packages: mlr3, mlr3learners, and nnet
#> • Predict Types: [response]
#> • Feature Types: logical, integer, numeric, factor, and ordered
#> • Encapsulation: none (fallback: -)
#> • Properties: weights
#> • Other settings: use_weights = 'use'

# Define a Task
task = tsk("mtcars")

# Create train and test set
ids = partition(task)

# Train the learner on the training ids
learner$train(task, row_ids = ids$train)
#> # weights:  37
#> initial  value 9370.049674 
#> final  value 735.418095 
#> converged

# Print the model
print(learner$model)
#> a 10-3-1 network with 37 weights
#> inputs: am carb cyl disp drat gear hp qsec vs wt 
#> output(s): mpg 
#> options were - linear output units 

# Importance method
if ("importance" %in% learner$properties) print(learner$importance)

# Make predictions for the test rows
predictions = learner$predict(task, row_ids = ids$test)

# Score the predictions
predictions$score()
#> regr.mse 
#> 36.19762 
```
