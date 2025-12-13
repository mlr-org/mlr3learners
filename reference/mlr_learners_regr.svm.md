# Support Vector Machine

Support vector machine for regression. Calls
[`e1071::svm()`](https://rdrr.io/pkg/e1071/man/svm.html) from package
[e1071](https://CRAN.R-project.org/package=e1071).

## Dictionary

This [mlr3::Learner](https://mlr3.mlr-org.com/reference/Learner.html)
can be instantiated via the
[dictionary](https://mlr3misc.mlr-org.com/reference/Dictionary.html)
[mlr3::mlr_learners](https://mlr3.mlr-org.com/reference/mlr_learners.html)
or with the associated sugar function
[`mlr3::lrn()`](https://mlr3.mlr-org.com/reference/mlr_sugar.html):

    mlr_learners$get("regr.svm")
    lrn("regr.svm")

## Meta Information

- Task type: “regr”

- Predict Types: “response”

- Feature Types: “logical”, “integer”, “numeric”

- Required Packages: [mlr3](https://CRAN.R-project.org/package=mlr3),
  [mlr3learners](https://CRAN.R-project.org/package=mlr3learners),
  [e1071](https://CRAN.R-project.org/package=e1071)

## Parameters

|           |           |                |                                     |                       |
|-----------|-----------|----------------|-------------------------------------|-----------------------|
| Id        | Type      | Default        | Levels                              | Range                 |
| cachesize | numeric   | 40             |                                     | \\(-\infty, \infty)\\ |
| coef0     | numeric   | 0              |                                     | \\(-\infty, \infty)\\ |
| cost      | numeric   | 1              |                                     | \\\[0, \infty)\\      |
| cross     | integer   | 0              |                                     | \\\[0, \infty)\\      |
| degree    | integer   | 3              |                                     | \\\[1, \infty)\\      |
| epsilon   | numeric   | 0.1            |                                     | \\\[0, \infty)\\      |
| fitted    | logical   | TRUE           | TRUE, FALSE                         | \-                    |
| gamma     | numeric   | \-             |                                     | \\\[0, \infty)\\      |
| kernel    | character | radial         | linear, polynomial, radial, sigmoid | \-                    |
| nu        | numeric   | 0.5            |                                     | \\(-\infty, \infty)\\ |
| scale     | untyped   | TRUE           |                                     | \-                    |
| shrinking | logical   | TRUE           | TRUE, FALSE                         | \-                    |
| tolerance | numeric   | 0.001          |                                     | \\\[0, \infty)\\      |
| type      | character | eps-regression | eps-regression, nu-regression       | \-                    |

## References

Cortes, Corinna, Vapnik, Vladimir (1995). “Support-vector networks.”
*Machine Learning*, **20**(3), 273–297.
[doi:10.1007/BF00994018](https://doi.org/10.1007/BF00994018) .

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
[`mlr_learners_regr.nnet`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.nnet.md),
[`mlr_learners_regr.ranger`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.ranger.md),
[`mlr_learners_regr.xgboost`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.xgboost.md)

## Super classes

[`mlr3::Learner`](https://mlr3.mlr-org.com/reference/Learner.html) -\>
[`mlr3::LearnerRegr`](https://mlr3.mlr-org.com/reference/LearnerRegr.html)
-\> `LearnerRegrSVM`

## Methods

### Public methods

- [`LearnerRegrSVM$new()`](#method-LearnerRegrSVM-new)

- [`LearnerRegrSVM$clone()`](#method-LearnerRegrSVM-clone)

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

    LearnerRegrSVM$new()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    LearnerRegrSVM$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
# Define the Learner and set parameter values
learner = lrn("regr.svm")
print(learner)
#> 
#> ── <LearnerRegrSVM> (regr.svm): Support Vector Machine ─────────────────────────
#> • Model: -
#> • Parameters: list()
#> • Packages: mlr3, mlr3learners, and e1071
#> • Predict Types: [response]
#> • Feature Types: logical, integer, and numeric
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
#> 
#> Call:
#> svm.default(x = data, y = task$truth())
#> 
#> 
#> Parameters:
#>    SVM-Type:  eps-regression 
#>  SVM-Kernel:  radial 
#>        cost:  1 
#>       gamma:  0.1 
#>     epsilon:  0.1 
#> 
#> 
#> Number of Support Vectors:  20
#> 

# Importance method
if ("importance" %in% learner$properties) print(learner$importance)

# Make predictions for the test rows
predictions = learner$predict(task, row_ids = ids$test)

# Score the predictions
predictions$score()
#> regr.mse 
#> 11.54447 
```
