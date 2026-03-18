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
#> • Other settings: use_weights = 'error', predict_raw = 'FALSE'

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
#>   - parameters upper bounds :  2 14 8 737.8 4.34 4 566 16.8 2 7.664 
#>   - best initial criterion value(s) :  -60.35636 
#> 
#> N = 10, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       60.356  |proj g|=       1.0441
#> At iterate     1  f =       59.578  |proj g|=       0.61557
#> At iterate     2  f =       59.551  |proj g|=       0.43639
#> At iterate     3  f =       59.508  |proj g|=        0.1072
#> At iterate     4  f =       59.501  |proj g|=      0.045916
#> At iterate     5  f =       59.498  |proj g|=      0.035272
#> At iterate     6  f =       59.486  |proj g|=      0.049029
#> At iterate     7  f =       59.458  |proj g|=       0.13826
#> At iterate     8  f =       59.437  |proj g|=       0.16631
#> At iterate     9  f =       59.397  |proj g|=      0.062371
#> At iterate    10  f =        59.39  |proj g|=       0.12121
#> At iterate    11  f =       59.385  |proj g|=      0.040085
#> At iterate    12  f =        59.38  |proj g|=      0.044928
#> At iterate    13  f =       59.351  |proj g|=      0.076988
#> At iterate    14  f =       59.317  |proj g|=       0.11096
#> At iterate    15  f =       59.278  |proj g|=       0.03651
#> At iterate    16  f =       59.276  |proj g|=       0.10888
#> At iterate    17  f =       59.272  |proj g|=      0.028216
#> At iterate    18  f =       59.271  |proj g|=       0.02276
#> At iterate    19  f =       59.269  |proj g|=      0.028528
#> At iterate    20  f =       59.267  |proj g|=      0.024534
#> At iterate    21  f =       59.264  |proj g|=       0.01321
#> At iterate    22  f =       59.259  |proj g|=      0.020469
#> At iterate    23  f =       59.258  |proj g|=       0.03941
#> At iterate    24  f =       59.256  |proj g|=      0.034892
#> At iterate    25  f =       59.252  |proj g|=      0.019909
#> At iterate    26  f =       59.246  |proj g|=      0.021398
#> At iterate    27  f =       59.207  |proj g|=       0.17622
#> At iterate    28  f =       59.155  |proj g|=       0.26612
#> At iterate    29  f =       59.075  |proj g|=      0.088692
#> At iterate    30  f =       59.044  |proj g|=      0.085756
#> At iterate    31  f =       58.896  |proj g|=       0.16094
#> At iterate    32  f =       58.655  |proj g|=       0.31974
#> At iterate    33  f =       58.588  |proj g|=       0.12902
#> At iterate    34  f =       58.543  |proj g|=       0.12928
#> At iterate    35  f =       58.431  |proj g|=       0.21067
#> At iterate    36  f =       58.393  |proj g|=       0.23517
#> At iterate    37  f =       58.346  |proj g|=      0.079539
#> At iterate    38  f =       58.299  |proj g|=      0.028819
#> At iterate    39  f =       58.299  |proj g|=      0.018978
#> At iterate    40  f =       58.299  |proj g|=     0.0014728
#> At iterate    41  f =       58.298  |proj g|=     0.0014731
#> At iterate    42  f =       58.298  |proj g|=     0.0016648
#> At iterate    43  f =       58.298  |proj g|=     0.0043607
#> At iterate    44  f =       58.298  |proj g|=     0.0070433
#> At iterate    45  f =       58.298  |proj g|=      0.012799
#> At iterate    46  f =       58.298  |proj g|=      0.024266
#> At iterate    47  f =       58.297  |proj g|=       0.03984
#> At iterate    48  f =       58.295  |proj g|=       0.06895
#> At iterate    49  f =       58.289  |proj g|=       0.11864
#> At iterate    50  f =       58.274  |proj g|=       0.18326
#> At iterate    51  f =       58.242  |proj g|=       0.21753
#> At iterate    52  f =       58.148  |proj g|=       0.28914
#> At iterate    53  f =       58.039  |proj g|=       0.11486
#> At iterate    54  f =       58.014  |proj g|=       0.12402
#> At iterate    55  f =       57.995  |proj g|=      0.042404
#> At iterate    56  f =       57.994  |proj g|=       0.02408
#> At iterate    57  f =       57.994  |proj g|=     0.0087769
#> At iterate    58  f =       57.994  |proj g|=     0.0051443
#> At iterate    59  f =       57.994  |proj g|=    0.00014381
#> At iterate    60  f =       57.994  |proj g|=    9.8036e-05
#> 
#> iterations 60
#> function evaluations 66
#> segments explored during Cauchy searches 60
#> BFGS updates skipped 0
#> active bounds at final generalized Cauchy point 6
#> norm of the final projected gradient 9.80364e-05
#> final function value 57.9936
#> 
#> F = 57.9936
#> final  value 57.993584 
#> converged

# Print the model
print(learner$model)
#> 
#> Call:
#> DiceKriging::km(design = data, response = truth, control = pv$control)
#> 
#> Trend  coeff.:
#>                Estimate
#>  (Intercept)    20.6909
#> 
#> Covar. type  : matern5_2 
#> Covar. coeff.:
#>                Estimate
#>    theta(am)     1.0794
#>  theta(carb)    14.0000
#>   theta(cyl)     8.0000
#>  theta(disp)   737.8000
#>  theta(drat)     1.3933
#>  theta(gear)     4.0000
#>    theta(hp)   566.0000
#>  theta(qsec)     1.4621
#>    theta(vs)     0.0000
#>    theta(wt)     2.1558
#> 
#> Variance estimate: 36.67326

# Importance method
if ("importance" %in% learner$properties) print(learner$importance())

# Make predictions for the test rows
predictions = learner$predict(task, row_ids = ids$test)

# Score the predictions
predictions$score()
#> regr.mse 
#> 9.673668 
```
