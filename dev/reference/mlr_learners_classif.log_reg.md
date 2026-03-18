# Logistic Regression Classification Learner

Classification via logistic regression. Calls
[`stats::glm()`](https://rdrr.io/r/stats/glm.html) with `family` set to
`binomial(link = <link>)` with `link` either as `"logit"` (default) or
`"probit"`.

## Internal Encoding

Starting with [mlr3](https://CRAN.R-project.org/package=mlr3) v0.5.0,
the order of class labels is reversed prior to model fitting to comply
to the [`stats::glm()`](https://rdrr.io/r/stats/glm.html) convention
that the negative class is provided as the first factor level.

## Initial parameter values

- `model`:

  - Actual default: `TRUE`.

  - Adjusted default: `FALSE`.

  - Reason for change: Save some memory.

## Offset

If a `Task` has a column with the role `offset`, it will automatically
be used during training. The offset is incorporated through the formula
interface to ensure compatibility with
[`stats::glm()`](https://rdrr.io/r/stats/glm.html). We add it to the
model formula as `offset(<column_name>)` and also include it in the
training data. During prediction, the default behavior is to use the
offset column from the test set (enabled by `use_pred_offset = TRUE`).
Otherwise, if the user sets `use_pred_offset = FALSE`, a zero offset is
applied, effectively disabling the offset adjustment during prediction.

## Dictionary

This [mlr3::Learner](https://mlr3.mlr-org.com/reference/Learner.html)
can be instantiated via the
[dictionary](https://mlr3misc.mlr-org.com/reference/Dictionary.html)
[mlr3::mlr_learners](https://mlr3.mlr-org.com/reference/mlr_learners.html)
or with the associated sugar function
[`mlr3::lrn()`](https://mlr3.mlr-org.com/reference/mlr_sugar.html):

    mlr_learners$get("classif.log_reg")
    lrn("classif.log_reg")

## Meta Information

- Task type: “classif”

- Predict Types: “response”, “prob”

- Feature Types: “logical”, “integer”, “numeric”, “character”, “factor”,
  “ordered”

- Required Packages: [mlr3](https://CRAN.R-project.org/package=mlr3),
  [mlr3learners](https://CRAN.R-project.org/package=mlr3learners),
  'stats'

## Parameters

|                 |           |         |               |                       |
|-----------------|-----------|---------|---------------|-----------------------|
| Id              | Type      | Default | Levels        | Range                 |
| dispersion      | untyped   | NULL    |               | \-                    |
| epsilon         | numeric   | 1e-08   |               | \\(-\infty, \infty)\\ |
| etastart        | untyped   | \-      |               | \-                    |
| link            | character | \-      | logit, probit | \-                    |
| maxit           | numeric   | 25      |               | \\(-\infty, \infty)\\ |
| model           | logical   | TRUE    | TRUE, FALSE   | \-                    |
| mustart         | untyped   | \-      |               | \-                    |
| singular.ok     | logical   | TRUE    | TRUE, FALSE   | \-                    |
| start           | untyped   | NULL    |               | \-                    |
| trace           | logical   | FALSE   | TRUE, FALSE   | \-                    |
| x               | logical   | FALSE   | TRUE, FALSE   | \-                    |
| y               | logical   | TRUE    | TRUE, FALSE   | \-                    |
| use_pred_offset | logical   | \-      | TRUE, FALSE   | \-                    |

## Contrasts

To ensure reproducibility, this learner always uses the default
contrasts:

- [`contr.treatment()`](https://rdrr.io/r/stats/contrast.html) for
  unordered factors, and

- [`contr.poly()`](https://rdrr.io/r/stats/contrast.html) for ordered
  factors.

Setting the option `"contrasts"` does not have any effect. Instead, set
the respective hyperparameter or use
[mlr3pipelines](https://CRAN.R-project.org/package=mlr3pipelines) to
create dummy features.

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
-\> `LearnerClassifLogReg`

## Methods

### Public methods

- [`LearnerClassifLogReg$new()`](#method-LearnerClassifLogReg-new)

- [`LearnerClassifLogReg$clone()`](#method-LearnerClassifLogReg-clone)

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

    LearnerClassifLogReg$new()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    LearnerClassifLogReg$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
# Define the Learner and set parameter values
learner = lrn("classif.log_reg")
print(learner)
#> 
#> ── <LearnerClassifLogReg> (classif.log_reg): Logistic Regression ───────────────
#> • Model: -
#> • Parameters: link=logit, use_pred_offset=TRUE
#> • Packages: mlr3, mlr3learners, and stats
#> • Predict Types: [response] and prob
#> • Feature Types: logical, integer, numeric, character, factor, and ordered
#> • Encapsulation: none (fallback: -)
#> • Properties: offset, twoclass, and weights
#> • Other settings: use_weights = 'use', predict_raw = 'FALSE'

# Define a Task
task = tsk("sonar")

# Create train and test set
ids = partition(task)

# Train the learner on the training ids
learner$train(task, row_ids = ids$train)
#> Warning: glm.fit: algorithm did not converge
#> Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

# Print the model
print(learner$model)
#> 
#> Call:  stats::glm(formula = form, family = stats::binomial(link = link), 
#>     data = data, model = FALSE)
#> 
#> Coefficients:
#> (Intercept)           V1          V10          V11          V12          V13  
#>    -218.269      447.294     -101.657       57.785      238.149       76.659  
#>         V14          V15          V16          V17          V18          V19  
#>    -147.612       73.619     -124.589       10.025       76.102      -20.279  
#>          V2          V20          V21          V22          V23          V24  
#>     -17.516      -89.098      136.322      -21.343       -9.840      204.983  
#>         V25          V26          V27          V28          V29           V3  
#>    -317.268      279.089     -173.946      168.871     -286.918     -819.898  
#>         V30          V31          V32          V33          V34          V35  
#>     464.489     -403.653      275.932     -227.678      183.149       25.895  
#>         V36          V37          V38          V39           V4          V40  
#>    -264.215       67.057      167.517       50.848      173.382     -143.493  
#>         V41          V42          V43          V44          V45          V46  
#>     -31.279       -6.487       16.469      260.527      -99.417     -363.118  
#>         V47          V48          V49           V5          V50          V51  
#>    1021.223     -328.349      307.948      428.923    -1749.079     -494.081  
#>         V52          V53          V54          V55          V56          V57  
#>    1741.766      946.441      152.633    -2309.507    -2846.633     -143.526  
#>         V58          V59           V6          V60           V7           V8  
#>    4298.927     1961.737     -190.439      706.957        4.573      323.417  
#>          V9  
#>      10.981  
#> 
#> Degrees of Freedom: 138 Total (i.e. Null);  78 Residual
#> Null Deviance:       190.1 
#> Residual Deviance: 5.789e-09     AIC: 122

# Importance method
if ("importance" %in% learner$properties) print(learner$importance())

# Make predictions for the test rows
predictions = learner$predict(task, row_ids = ids$test)

# Score the predictions
predictions$score()
#> classif.ce 
#>  0.2898551 
```
