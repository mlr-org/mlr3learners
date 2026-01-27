# Ranger Classification Learner

Random classification forest. Calls
[`ranger::ranger()`](http://imbs-hl.github.io/ranger/reference/ranger.md)
from package [ranger](https://CRAN.R-project.org/package=ranger).

## Custom mlr3 parameters

- `mtry`:

  - This hyperparameter can alternatively be set via our hyperparameter
    `mtry.ratio` as `mtry = max(ceiling(mtry.ratio * n_features), 1)`.
    Note that `mtry` and `mtry.ratio` are mutually exclusive.

## Initial parameter values

- `num.threads`:

  - Actual default: `2`, using two threads, while also respecting
    environment variable `R_RANGER_NUM_THREADS`,
    `options(ranger.num.threads = N)`, or `options(Ncpus = N)`, with
    precedence in that order.

  - Adjusted value: 1.

  - Reason for change: Conflicting with parallelization via
    [future](https://CRAN.R-project.org/package=future).

## Dictionary

This [mlr3::Learner](https://mlr3.mlr-org.com/reference/Learner.html)
can be instantiated via the
[dictionary](https://mlr3misc.mlr-org.com/reference/Dictionary.html)
[mlr3::mlr_learners](https://mlr3.mlr-org.com/reference/mlr_learners.html)
or with the associated sugar function
[`mlr3::lrn()`](https://mlr3.mlr-org.com/reference/mlr_sugar.html):

    mlr_learners$get("classif.ranger")
    lrn("classif.ranger")

## Meta Information

- Task type: “classif”

- Predict Types: “response”, “prob”

- Feature Types: “logical”, “integer”, “numeric”, “character”, “factor”,
  “ordered”

- Required Packages: [mlr3](https://CRAN.R-project.org/package=mlr3),
  [mlr3learners](https://CRAN.R-project.org/package=mlr3learners),
  [ranger](https://CRAN.R-project.org/package=ranger)

## Parameters

|                              |           |          |                                                 |                       |
|------------------------------|-----------|----------|-------------------------------------------------|-----------------------|
| Id                           | Type      | Default  | Levels                                          | Range                 |
| always.split.variables       | untyped   | \-       |                                                 | \-                    |
| class.weights                | untyped   | NULL     |                                                 | \-                    |
| holdout                      | logical   | FALSE    | TRUE, FALSE                                     | \-                    |
| importance                   | character | \-       | none, impurity, impurity_corrected, permutation | \-                    |
| keep.inbag                   | logical   | FALSE    | TRUE, FALSE                                     | \-                    |
| max.depth                    | integer   | NULL     |                                                 | \\\[1, \infty)\\      |
| min.bucket                   | untyped   | 1L       |                                                 | \-                    |
| min.node.size                | untyped   | NULL     |                                                 | \-                    |
| mtry                         | integer   | \-       |                                                 | \\\[1, \infty)\\      |
| mtry.ratio                   | numeric   | \-       |                                                 | \\\[0, 1\]\\          |
| na.action                    | character | na.learn | na.learn, na.omit, na.fail                      | \-                    |
| num.random.splits            | integer   | 1        |                                                 | \\\[1, \infty)\\      |
| node.stats                   | logical   | FALSE    | TRUE, FALSE                                     | \-                    |
| num.threads                  | integer   | 1        |                                                 | \\\[1, \infty)\\      |
| num.trees                    | integer   | 500      |                                                 | \\\[1, \infty)\\      |
| oob.error                    | logical   | TRUE     | TRUE, FALSE                                     | \-                    |
| regularization.factor        | untyped   | 1        |                                                 | \-                    |
| regularization.usedepth      | logical   | FALSE    | TRUE, FALSE                                     | \-                    |
| replace                      | logical   | TRUE     | TRUE, FALSE                                     | \-                    |
| respect.unordered.factors    | character | \-       | ignore, order, partition                        | \-                    |
| sample.fraction              | numeric   | \-       |                                                 | \\\[0, 1\]\\          |
| save.memory                  | logical   | FALSE    | TRUE, FALSE                                     | \-                    |
| scale.permutation.importance | logical   | FALSE    | TRUE, FALSE                                     | \-                    |
| seed                         | integer   | NULL     |                                                 | \\(-\infty, \infty)\\ |
| split.select.weights         | untyped   | NULL     |                                                 | \-                    |
| splitrule                    | character | gini     | gini, extratrees, hellinger                     | \-                    |
| verbose                      | logical   | TRUE     | TRUE, FALSE                                     | \-                    |
| write.forest                 | logical   | TRUE     | TRUE, FALSE                                     | \-                    |

## References

Wright, N. M, Ziegler, Andreas (2017). “ranger: A Fast Implementation of
Random Forests for High Dimensional Data in C++ and R.” *Journal of
Statistical Software*, **77**(1), 1–17.
[doi:10.18637/jss.v077.i01](https://doi.org/10.18637/jss.v077.i01) .

Breiman, Leo (2001). “Random Forests.” *Machine Learning*, **45**(1),
5–32. ISSN 1573-0565,
[doi:10.1023/A:1010933404324](https://doi.org/10.1023/A%3A1010933404324)
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
-\> `LearnerClassifRanger`

## Methods

### Public methods

- [`LearnerClassifRanger$new()`](#method-LearnerClassifRanger-new)

- [`LearnerClassifRanger$importance()`](#method-LearnerClassifRanger-importance)

- [`LearnerClassifRanger$oob_error()`](#method-LearnerClassifRanger-oob_error)

- [`LearnerClassifRanger$selected_features()`](#method-LearnerClassifRanger-selected_features)

- [`LearnerClassifRanger$clone()`](#method-LearnerClassifRanger-clone)

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

    LearnerClassifRanger$new()

------------------------------------------------------------------------

### Method `importance()`

The importance scores are extracted from the model slot
`variable.importance`. Parameter `importance.mode` must be set to
`"impurity"`, `"impurity_corrected"`, or `"permutation"`

#### Usage

    LearnerClassifRanger$importance()

#### Returns

Named [`numeric()`](https://rdrr.io/r/base/numeric.html).

------------------------------------------------------------------------

### Method `oob_error()`

The out-of-bag error, extracted from model slot `prediction.error`.

#### Usage

    LearnerClassifRanger$oob_error()

#### Returns

`numeric(1)`.

------------------------------------------------------------------------

### Method `selected_features()`

The set of features used for node splitting in the forest.

#### Usage

    LearnerClassifRanger$selected_features()

#### Returns

[`character()`](https://rdrr.io/r/base/character.html).

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    LearnerClassifRanger$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
# Define the Learner and set parameter values
learner = lrn("classif.ranger")
print(learner)
#> 
#> ── <LearnerClassifRanger> (classif.ranger): Random Forest ──────────────────────
#> • Model: -
#> • Parameters: num.threads=1
#> • Packages: mlr3, mlr3learners, and ranger
#> • Predict Types: [response] and prob
#> • Feature Types: logical, integer, numeric, character, factor, and ordered
#> • Encapsulation: none (fallback: -)
#> • Properties: hotstart_backward, importance, missings, multiclass, oob_error,
#> selected_features, twoclass, and weights
#> • Other settings: use_weights = 'use'

# Define a Task
task = tsk("sonar")

# Create train and test set
ids = partition(task)

# Train the learner on the training ids
learner$train(task, row_ids = ids$train)

# Print the model
print(learner$model)
#> Ranger result
#> 
#> Call:
#>  ranger::ranger(dependent.variable.name = task$target_names, data = task$data(),      probability = self$predict_type == "prob", num.threads = 1L) 
#> 
#> Type:                             Classification 
#> Number of trees:                  500 
#> Sample size:                      139 
#> Number of independent variables:  60 
#> Mtry:                             7 
#> Target node size:                 1 
#> Variable importance mode:         none 
#> Splitrule:                        gini 
#> OOB prediction error:             18.71 % 

# Importance method
if ("importance" %in% learner$properties) print(learner$importance)
#> function () 
#> .__LearnerClassifRanger__importance(self = self, private = private, 
#>     super = super)
#> <environment: 0x5566c877ba38>

# Make predictions for the test rows
predictions = learner$predict(task, row_ids = ids$test)

# Score the predictions
predictions$score()
#> classif.ce 
#>  0.1594203 
```
