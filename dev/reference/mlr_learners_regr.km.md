# Kriging Regression Learner

Kriging regression. Calls
[`DiceKriging::km()`](https://rdrr.io/pkg/DiceKriging/man/km.html) from
package [DiceKriging](https://CRAN.R-project.org/package=DiceKriging).

- The predict type hyperparameter "type" defaults to "SK" (simple
  kriging).

- The additional hyperparameter `nugget.stability` is used to overwrite
  the hyperparameter `nugget` with `nugget.stability * var(y)` before
  training to improve the numerical stability. We recommend a value of
  `1e-8`.

- The additional hyperparameter `jitter` can be set to add
  `N(0, [jitter])`-distributed noise to the data before prediction to
  avoid perfect interpolation. We recommend a value of `1e-12`.

## Dictionary

This [mlr3::Learner](https://mlr3.mlr-org.com/reference/Learner.html)
can be instantiated via the
[dictionary](https://mlr3misc.mlr-org.com/reference/Dictionary.html)
[mlr3::mlr_learners](https://mlr3.mlr-org.com/reference/mlr_learners.html)
or with the associated sugar function
[`mlr3::lrn()`](https://mlr3.mlr-org.com/reference/mlr_sugar.html):

    mlr_learners$get("regr.km")
    lrn("regr.km")

## Meta Information

- Task type: “regr”

- Predict Types: “response”, “se”

- Feature Types: “logical”, “integer”, “numeric”

- Required Packages: [mlr3](https://CRAN.R-project.org/package=mlr3),
  [mlr3learners](https://CRAN.R-project.org/package=mlr3learners),
  [DiceKriging](https://CRAN.R-project.org/package=DiceKriging)

## Parameters

|                  |           |           |                                          |                       |
|------------------|-----------|-----------|------------------------------------------|-----------------------|
| Id               | Type      | Default   | Levels                                   | Range                 |
| bias.correct     | logical   | FALSE     | TRUE, FALSE                              | \-                    |
| checkNames       | logical   | TRUE      | TRUE, FALSE                              | \-                    |
| coef.cov         | untyped   | NULL      |                                          | \-                    |
| coef.trend       | untyped   | NULL      |                                          | \-                    |
| coef.var         | untyped   | NULL      |                                          | \-                    |
| control          | untyped   | NULL      |                                          | \-                    |
| cov.compute      | logical   | TRUE      | TRUE, FALSE                              | \-                    |
| covtype          | character | matern5_2 | gauss, matern5_2, matern3_2, exp, powexp | \-                    |
| estim.method     | character | MLE       | MLE, LOO                                 | \-                    |
| gr               | logical   | TRUE      | TRUE, FALSE                              | \-                    |
| iso              | logical   | FALSE     | TRUE, FALSE                              | \-                    |
| jitter           | numeric   | 0         |                                          | \\\[0, \infty)\\      |
| kernel           | untyped   | NULL      |                                          | \-                    |
| knots            | untyped   | NULL      |                                          | \-                    |
| light.return     | logical   | FALSE     | TRUE, FALSE                              | \-                    |
| lower            | untyped   | NULL      |                                          | \-                    |
| multistart       | integer   | 1         |                                          | \\(-\infty, \infty)\\ |
| noise.var        | untyped   | NULL      |                                          | \-                    |
| nugget           | numeric   | \-        |                                          | \\(-\infty, \infty)\\ |
| nugget.estim     | logical   | FALSE     | TRUE, FALSE                              | \-                    |
| nugget.stability | numeric   | 0         |                                          | \\\[0, \infty)\\      |
| optim.method     | character | BFGS      | BFGS, gen                                | \-                    |
| parinit          | untyped   | NULL      |                                          | \-                    |
| penalty          | untyped   | NULL      |                                          | \-                    |
| scaling          | logical   | FALSE     | TRUE, FALSE                              | \-                    |
| se.compute       | logical   | TRUE      | TRUE, FALSE                              | \-                    |
| type             | character | SK        | SK, UK                                   | \-                    |
| upper            | untyped   | NULL      |                                          | \-                    |

## References

Roustant O, Ginsbourger D, Deville Y (2012). “DiceKriging, DiceOptim:
Two R Packages for the Analysis of Computer Experiments by Kriging-Based
Metamodeling and Optimization.” *Journal of Statistical Software*,
**51**(1), 1–55.
[doi:10.18637/jss.v051.i01](https://doi.org/10.18637/jss.v051.i01) .

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
[`mlr_learners_classif.ranger`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_classif.ranger.md),
[`mlr_learners_classif.svm`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_classif.svm.md),
[`mlr_learners_classif.xgboost`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_classif.xgboost.md),
[`mlr_learners_regr.cv_glmnet`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.cv_glmnet.md),
[`mlr_learners_regr.glmnet`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.glmnet.md),
[`mlr_learners_regr.kknn`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.kknn.md),
[`mlr_learners_regr.lm`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.lm.md),
[`mlr_learners_regr.nnet`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.nnet.md),
[`mlr_learners_regr.ranger`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.ranger.md),
[`mlr_learners_regr.svm`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.svm.md),
[`mlr_learners_regr.xgboost`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.xgboost.md)

## Super classes

[`mlr3::Learner`](https://mlr3.mlr-org.com/reference/Learner.html) -\>
[`mlr3::LearnerRegr`](https://mlr3.mlr-org.com/reference/LearnerRegr.html)
-\> `LearnerRegrKM`

## Methods

### Public methods

- [`LearnerRegrKM$new()`](#method-LearnerRegrKM-new)

- [`LearnerRegrKM$clone()`](#method-LearnerRegrKM-clone)

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

    LearnerRegrKM$new()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    LearnerRegrKM$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
# Define the Learner and set parameter values
learner = lrn("regr.km")
print(learner)
#> 
#> ── <LearnerRegrKM> (regr.km): Kriging ──────────────────────────────────────────
#> • Model: -
#> • Parameters: list()
#> • Packages: mlr3, mlr3learners, and DiceKriging
#> • Predict Types: [response] and se
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
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern5_2 
#>   - nugget : NO
#>   - parameters lower bounds :  1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 
#>   - parameters upper bounds :  2 14 8 801.8 4 4 566 16.8 2 7.822 
#>   - best initial criterion value(s) :  -59.9162 
#> 
#> N = 10, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       59.916  |proj g|=      0.95668
#> At iterate     1  f =       59.505  |proj g|=        1.4334
#> At iterate     2  f =       58.793  |proj g|=        1.0213
#> At iterate     3  f =       58.578  |proj g|=        1.6463
#> At iterate     4  f =       58.481  |proj g|=       0.75148
#> At iterate     5  f =       58.268  |proj g|=       0.41674
#> At iterate     6  f =       58.075  |proj g|=        0.2204
#> At iterate     7  f =       58.002  |proj g|=       0.11193
#> At iterate     8  f =       57.985  |proj g|=      0.057232
#> At iterate     9  f =       57.953  |proj g|=      0.043051
#> At iterate    10  f =       57.942  |proj g|=      0.040194
#> At iterate    11  f =       57.876  |proj g|=       0.20848
#> At iterate    12  f =       57.842  |proj g|=       0.28907
#> At iterate    13  f =       57.801  |proj g|=       0.27715
#> At iterate    14  f =       57.761  |proj g|=       0.16308
#> At iterate    15  f =       57.736  |proj g|=      0.031602
#> At iterate    16  f =       57.733  |proj g|=       0.02224
#> At iterate    17  f =        57.73  |proj g|=       0.01521
#> At iterate    18  f =       57.728  |proj g|=      0.011744
#> At iterate    19  f =       57.728  |proj g|=     0.0042265
#> At iterate    20  f =       57.728  |proj g|=      0.024901
#> At iterate    21  f =       57.728  |proj g|=      0.010714
#> At iterate    22  f =       57.728  |proj g|=     0.0020135
#> At iterate    23  f =       57.728  |proj g|=     0.0016093
#> At iterate    24  f =       57.728  |proj g|=     0.0012447
#> At iterate    25  f =       57.728  |proj g|=     0.0012442
#> At iterate    26  f =       57.728  |proj g|=     0.0028344
#> At iterate    27  f =       57.728  |proj g|=     0.0054748
#> At iterate    28  f =       57.728  |proj g|=       0.03389
#> At iterate    29  f =       57.728  |proj g|=      0.014418
#> At iterate    30  f =       57.727  |proj g|=      0.021228
#> At iterate    31  f =       57.725  |proj g|=      0.072795
#> At iterate    32  f =       57.721  |proj g|=       0.14126
#> At iterate    33  f =       57.713  |proj g|=          0.22
#> At iterate    34  f =       57.696  |proj g|=        0.2928
#> At iterate    35  f =       57.668  |proj g|=       0.24473
#> At iterate    36  f =       57.645  |proj g|=       0.47784
#> At iterate    37  f =       57.568  |proj g|=       0.17836
#> At iterate    38  f =       57.536  |proj g|=      0.057029
#> At iterate    39  f =       57.527  |proj g|=      0.020982
#> At iterate    40  f =       57.527  |proj g|=      0.032198
#> At iterate    41  f =       57.527  |proj g|=     0.0015031
#> At iterate    42  f =       57.527  |proj g|=     0.0002306
#> At iterate    43  f =       57.527  |proj g|=    0.00010318
#> 
#> iterations 43
#> function evaluations 46
#> segments explored during Cauchy searches 43
#> BFGS updates skipped 0
#> active bounds at final generalized Cauchy point 5
#> norm of the final projected gradient 0.000103179
#> final function value 57.5268
#> 
#> F = 57.5268
#> final  value 57.526779 
#> converged

# Print the model
print(learner$model)
#> 
#> Call:
#> DiceKriging::km(design = data, response = truth, control = pv$control)
#> 
#> Trend  coeff.:
#>                Estimate
#>  (Intercept)    21.4124
#> 
#> Covar. type  : matern5_2 
#> Covar. coeff.:
#>                Estimate
#>    theta(am)     2.0000
#>  theta(carb)    14.0000
#>   theta(cyl)     8.0000
#>  theta(disp)   801.8000
#>  theta(drat)     1.0159
#>  theta(gear)     2.3302
#>    theta(hp)   472.6205
#>  theta(qsec)     1.4230
#>    theta(vs)     2.0000
#>    theta(wt)     2.6510
#> 
#> Variance estimate: 42.09598

# Importance method
if ("importance" %in% learner$properties) print(learner$importance)

# Make predictions for the test rows
predictions = learner$predict(task, row_ids = ids$test)

# Score the predictions
predictions$score()
#> regr.mse 
#> 8.151569 
```
