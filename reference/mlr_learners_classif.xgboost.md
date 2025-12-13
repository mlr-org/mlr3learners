# Extreme Gradient Boosting Classification Learner

eXtreme Gradient Boosting classification. Calls
[`xgboost::xgb.train()`](https://rdrr.io/pkg/xgboost/man/xgb.train.html)
from package [xgboost](https://CRAN.R-project.org/package=xgboost).

Note that using the `evals` parameter directly will lead to problems
when wrapping this
[mlr3::Learner](https://mlr3.mlr-org.com/reference/Learner.html) in a
`mlr3pipelines` `GraphLearner` as the preprocessing steps will not be
applied to the data in `evals`. See the section *Early Stopping and
Validation* on how to do this.

## Note

To compute on GPUs, you first need to compile
[xgboost](https://CRAN.R-project.org/package=xgboost) yourself and link
against CUDA. See
<https://xgboost.readthedocs.io/en/stable/build.html#building-with-gpu-support>.

The `outputmargin`, `predcontrib`, `predinteraction`, and `predleaf`
parameters are not supported. You can still call e.g.
`predict(learner$model, newdata = newdata, outputmargin = TRUE)` to get
these predictions.

## Initial parameter values

- `nrounds`:

  - Actual default: no default.

  - Adjusted default: 1000.

  - Reason for change: Without a default construction of the learner
    would error. The lightgbm learner has a default of 1000, so we use
    the same here.

- `nthread`:

  - Actual value: Undefined, triggering auto-detection of the number of
    CPUs.

  - Adjusted value: 1.

  - Reason for change: Conflicting with parallelization via
    [future](https://CRAN.R-project.org/package=future).

- `verbose`:

  - Actual default: 1.

  - Adjusted default: 0.

  - Reason for change: Reduce verbosity.

- `verbosity`:

  - Actual default: 1.

  - Adjusted default: 0.

  - Reason for change: Reduce verbosity.

## Early Stopping and Validation

In order to monitor the validation performance during the training, you
can set the `$validate` field of the Learner. For information on how to
configure the validation set, see the *Validation* section of
[mlr3::Learner](https://mlr3.mlr-org.com/reference/Learner.html). This
validation data can also be used for early stopping, which can be
enabled by setting the `early_stopping_rounds` parameter. The final (or
in the case of early stopping best) validation scores can be accessed
via `$internal_valid_scores`, and the optimal `nrounds` via
`$internal_tuned_values`. The internal validation measure can be set via
the `custom_metric` parameter that can be a
[mlr3::Measure](https://mlr3.mlr-org.com/reference/Measure.html), a
function, or a character string for the internal xgboost measures. Using
an [mlr3::Measure](https://mlr3.mlr-org.com/reference/Measure.html) is
slower than the internal xgboost measures, but allows to use the same
measure for tuning and validation.

## Dictionary

This [mlr3::Learner](https://mlr3.mlr-org.com/reference/Learner.html)
can be instantiated via the
[dictionary](https://mlr3misc.mlr-org.com/reference/Dictionary.html)
[mlr3::mlr_learners](https://mlr3.mlr-org.com/reference/mlr_learners.html)
or with the associated sugar function
[`mlr3::lrn()`](https://mlr3.mlr-org.com/reference/mlr_sugar.html):

    mlr_learners$get("classif.xgboost")
    lrn("classif.xgboost")

## Meta Information

- Task type: “classif”

- Predict Types: “response”, “prob”

- Feature Types: “logical”, “integer”, “numeric”

- Required Packages: [mlr3](https://CRAN.R-project.org/package=mlr3),
  [mlr3learners](https://CRAN.R-project.org/package=mlr3learners),
  [xgboost](https://CRAN.R-project.org/package=xgboost)

## Parameters

|                             |           |                   |                                          |                       |
|-----------------------------|-----------|-------------------|------------------------------------------|-----------------------|
| Id                          | Type      | Default           | Levels                                   | Range                 |
| alpha                       | numeric   | 0                 |                                          | \\\[0, \infty)\\      |
| approxcontrib               | logical   | FALSE             | TRUE, FALSE                              | \-                    |
| base_score                  | numeric   | 0.5               |                                          | \\(-\infty, \infty)\\ |
| booster                     | character | gbtree            | gbtree, gblinear, dart                   | \-                    |
| callbacks                   | untyped   | list()            |                                          | \-                    |
| colsample_bylevel           | numeric   | 1                 |                                          | \\\[0, 1\]\\          |
| colsample_bynode            | numeric   | 1                 |                                          | \\\[0, 1\]\\          |
| colsample_bytree            | numeric   | 1                 |                                          | \\\[0, 1\]\\          |
| device                      | untyped   | "cpu"             |                                          | \-                    |
| disable_default_eval_metric | logical   | FALSE             | TRUE, FALSE                              | \-                    |
| early_stopping_rounds       | integer   | NULL              |                                          | \\\[1, \infty)\\      |
| eta                         | numeric   | 0.3               |                                          | \\\[0, 1\]\\          |
| evals                       | untyped   | NULL              |                                          | \-                    |
| eval_metric                 | untyped   | \-                |                                          | \-                    |
| custom_metric               | untyped   | \-                |                                          | \-                    |
| extmem_single_page          | logical   | FALSE             | TRUE, FALSE                              | \-                    |
| feature_selector            | character | cyclic            | cyclic, shuffle, random, greedy, thrifty | \-                    |
| gamma                       | numeric   | 0                 |                                          | \\\[0, \infty)\\      |
| grow_policy                 | character | depthwise         | depthwise, lossguide                     | \-                    |
| interaction_constraints     | untyped   | \-                |                                          | \-                    |
| iterationrange              | untyped   | \-                |                                          | \-                    |
| lambda                      | numeric   | 1                 |                                          | \\\[0, \infty)\\      |
| max_bin                     | integer   | 256               |                                          | \\\[2, \infty)\\      |
| max_cached_hist_node        | integer   | 65536             |                                          | \\(-\infty, \infty)\\ |
| max_cat_to_onehot           | integer   | \-                |                                          | \\(-\infty, \infty)\\ |
| max_cat_threshold           | numeric   | \-                |                                          | \\(-\infty, \infty)\\ |
| max_delta_step              | numeric   | 0                 |                                          | \\\[0, \infty)\\      |
| max_depth                   | integer   | 6                 |                                          | \\\[0, \infty)\\      |
| max_leaves                  | integer   | 0                 |                                          | \\\[0, \infty)\\      |
| maximize                    | logical   | NULL              | TRUE, FALSE                              | \-                    |
| min_child_weight            | numeric   | 1                 |                                          | \\\[0, \infty)\\      |
| missing                     | numeric   | NA                |                                          | \\(-\infty, \infty)\\ |
| monotone_constraints        | untyped   | 0                 |                                          | \-                    |
| nrounds                     | integer   | \-                |                                          | \\\[1, \infty)\\      |
| normalize_type              | character | tree              | tree, forest                             | \-                    |
| nthread                     | integer   | \-                |                                          | \\\[1, \infty)\\      |
| num_parallel_tree           | integer   | 1                 |                                          | \\\[1, \infty)\\      |
| objective                   | untyped   | "binary:logistic" |                                          | \-                    |
| one_drop                    | logical   | FALSE             | TRUE, FALSE                              | \-                    |
| print_every_n               | integer   | 1                 |                                          | \\\[1, \infty)\\      |
| rate_drop                   | numeric   | 0                 |                                          | \\\[0, 1\]\\          |
| refresh_leaf                | logical   | TRUE              | TRUE, FALSE                              | \-                    |
| seed                        | integer   | \-                |                                          | \\(-\infty, \infty)\\ |
| seed_per_iteration          | logical   | FALSE             | TRUE, FALSE                              | \-                    |
| sampling_method             | character | uniform           | uniform, gradient_based                  | \-                    |
| sample_type                 | character | uniform           | uniform, weighted                        | \-                    |
| save_name                   | untyped   | NULL              |                                          | \-                    |
| save_period                 | integer   | NULL              |                                          | \\\[0, \infty)\\      |
| scale_pos_weight            | numeric   | 1                 |                                          | \\(-\infty, \infty)\\ |
| skip_drop                   | numeric   | 0                 |                                          | \\\[0, 1\]\\          |
| subsample                   | numeric   | 1                 |                                          | \\\[0, 1\]\\          |
| top_k                       | integer   | 0                 |                                          | \\\[0, \infty)\\      |
| training                    | logical   | FALSE             | TRUE, FALSE                              | \-                    |
| tree_method                 | character | auto              | auto, exact, approx, hist, gpu_hist      | \-                    |
| tweedie_variance_power      | numeric   | 1.5               |                                          | \\\[1, 2\]\\          |
| updater                     | untyped   | \-                |                                          | \-                    |
| use_rmm                     | logical   | \-                | TRUE, FALSE                              | \-                    |
| validate_features           | logical   | TRUE              | TRUE, FALSE                              | \-                    |
| verbose                     | integer   | \-                |                                          | \\\[0, 2\]\\          |
| verbosity                   | integer   | \-                |                                          | \\\[0, 2\]\\          |
| xgb_model                   | untyped   | NULL              |                                          | \-                    |

## Offset

If a `Task` has a column with the role `offset`, it will automatically
be used during training. The offset is incorporated through the
[xgboost::xgb.DMatrix](https://rdrr.io/pkg/xgboost/man/xgb.DMatrix.html)
interface, using the `base_margin` field. No offset is applied during
prediction for this learner.

## References

Chen, Tianqi, Guestrin, Carlos (2016). “Xgboost: A scalable tree
boosting system.” In *Proceedings of the 22nd ACM SIGKDD Conference on
Knowledge Discovery and Data Mining*, 785–794. ACM.
[doi:10.1145/2939672.2939785](https://doi.org/10.1145/2939672.2939785) .

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
[`mlr_learners_regr.cv_glmnet`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.cv_glmnet.md),
[`mlr_learners_regr.glmnet`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.glmnet.md),
[`mlr_learners_regr.kknn`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.kknn.md),
[`mlr_learners_regr.km`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.km.md),
[`mlr_learners_regr.lm`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.lm.md),
[`mlr_learners_regr.nnet`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.nnet.md),
[`mlr_learners_regr.ranger`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.ranger.md),
[`mlr_learners_regr.svm`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.svm.md),
[`mlr_learners_regr.xgboost`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.xgboost.md)

## Super classes

[`mlr3::Learner`](https://mlr3.mlr-org.com/reference/Learner.html) -\>
[`mlr3::LearnerClassif`](https://mlr3.mlr-org.com/reference/LearnerClassif.html)
-\> `LearnerClassifXgboost`

## Active bindings

- `internal_valid_scores`:

  (named [`list()`](https://rdrr.io/r/base/list.html) or `NULL`) The
  validation scores extracted from `model$evaluation_log`. If early
  stopping is activated, this contains the validation scores of the
  model for the optimal `nrounds`, otherwise the `nrounds` for the final
  model.

- `internal_tuned_values`:

  (named [`list()`](https://rdrr.io/r/base/list.html) or `NULL`) If
  early stopping is activated, this returns a list with `nrounds`, which
  is extracted from `$best_iteration` of the model and otherwise `NULL`.

- `validate`:

  (`numeric(1)` or `character(1)` or `NULL`) How to construct the
  internal validation data. This parameter can be either `NULL`, a
  ratio, `"test"`, or `"predefined"`.

- `model`:

  (any)  
  The fitted model. Only available after `$train()` has been called.

## Methods

### Public methods

- [`LearnerClassifXgboost$new()`](#method-LearnerClassifXgboost-new)

- [`LearnerClassifXgboost$importance()`](#method-LearnerClassifXgboost-importance)

- [`LearnerClassifXgboost$clone()`](#method-LearnerClassifXgboost-clone)

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

    LearnerClassifXgboost$new()

------------------------------------------------------------------------

### Method `importance()`

The importance scores are calculated with
[`xgboost::xgb.importance()`](https://rdrr.io/pkg/xgboost/man/xgb.importance.html).

#### Usage

    LearnerClassifXgboost$importance()

#### Returns

Named [`numeric()`](https://rdrr.io/r/base/numeric.html).

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    LearnerClassifXgboost$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
if (FALSE) { # \dontrun{
if (requireNamespace("xgboost", quietly = TRUE)) {
# Define the Learner and set parameter values
learner = lrn("classif.xgboost")
print(learner)

# Define a Task
task = tsk("sonar")

# Create train and test set
ids = partition(task)

# Train the learner on the training ids
learner$train(task, row_ids = ids$train)

# print the model
print(learner$model)

# importance method
if("importance" %in% learner$properties) print(learner$importance)

# Make predictions for the test rows
predictions = learner$predict(task, row_ids = ids$test)

# Score the predictions
predictions$score()
}
} # }

if (FALSE) { # \dontrun{
# Train learner with early stopping on spam data set
task = tsk("spam")

# use 30 percent for validation
# Set early stopping parameter
learner = lrn("classif.xgboost",
  nrounds = 100,
  early_stopping_rounds = 10,
  validate = 0.3
)

# Train learner with early stopping
learner$train(task)

# Inspect optimal nrounds and validation performance
learner$internal_tuned_values
learner$internal_valid_scores
} # }
```
