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
#>   - parameters upper bounds :  2 14 8 801.8 4 4 566 10.82 2 7.822 
#>   - best initial criterion value(s) :  -59.07016 
#> 
#> N = 10, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=        59.07  |proj g|=       1.5851
#> At iterate     1  f =        58.47  |proj g|=        1.4468
#> At iterate     2  f =       57.682  |proj g|=        1.1083
#> At iterate     3  f =        57.31  |proj g|=        1.4804
#> At iterate     4  f =       57.102  |proj g|=       0.22804
#> At iterate     5  f =       57.072  |proj g|=       0.12852
#> At iterate     6  f =       57.023  |proj g|=      0.092505
#> At iterate     7  f =       56.993  |proj g|=      0.082785
#> At iterate     8  f =       56.942  |proj g|=      0.078875
#> At iterate     9  f =       56.935  |proj g|=        0.3505
#> At iterate    10  f =       56.925  |proj g|=      0.075868
#> At iterate    11  f =       56.914  |proj g|=      0.071404
#> At iterate    12  f =       56.904  |proj g|=      0.065766
#> At iterate    13  f =       56.874  |proj g|=      0.056692
#> At iterate    14  f =       56.843  |proj g|=         0.183
#> At iterate    15  f =       56.834  |proj g|=      0.069327
#> At iterate    16  f =       56.816  |proj g|=      0.079876
#> At iterate    17  f =       56.791  |proj g|=       0.17252
#> At iterate    18  f =       56.741  |proj g|=       0.23101
#> At iterate    19  f =         56.7  |proj g|=      0.078292
#> At iterate    20  f =       56.699  |proj g|=       0.42973
#> At iterate    21  f =       56.692  |proj g|=           0.1
#> At iterate    22  f =       56.692  |proj g|=      0.020136
#> At iterate    23  f =       56.692  |proj g|=      0.019801
#> At iterate    24  f =       56.691  |proj g|=      0.016019
#> At iterate    25  f =       56.691  |proj g|=      0.012699
#> At iterate    26  f =        56.69  |proj g|=     0.0086906
#> At iterate    27  f =        56.69  |proj g|=      0.020358
#> At iterate    28  f =        56.69  |proj g|=     0.0095171
#> At iterate    29  f =        56.69  |proj g|=     0.0014117
#> At iterate    30  f =        56.69  |proj g|=     0.0011036
#> At iterate    31  f =        56.69  |proj g|=     0.0007854
#> At iterate    32  f =        56.69  |proj g|=    0.00059486
#> At iterate    33  f =        56.69  |proj g|=    0.00059486
#> At iterate    34  f =        56.69  |proj g|=     0.0041266
#> At iterate    35  f =        56.69  |proj g|=     0.0029411
#> At iterate    36  f =        56.69  |proj g|=     0.0039306
#> At iterate    37  f =        56.69  |proj g|=     0.0052101
#> At iterate    38  f =        56.69  |proj g|=      0.005922
#> At iterate    39  f =       56.689  |proj g|=      0.042845
#> At iterate    40  f =       56.689  |proj g|=      0.037171
#> At iterate    41  f =       56.688  |proj g|=       0.20109
#> At iterate    42  f =       56.685  |proj g|=      0.068051
#> At iterate    43  f =       56.682  |proj g|=      0.052802
#> At iterate    44  f =        56.68  |proj g|=      0.077905
#> At iterate    45  f =       56.674  |proj g|=       0.11328
#> At iterate    46  f =       56.662  |proj g|=        0.3624
#> At iterate    47  f =        56.64  |proj g|=       0.13956
#> At iterate    48  f =       56.631  |proj g|=       0.11137
#> At iterate    49  f =       56.623  |proj g|=      0.082252
#> At iterate    50  f =       56.619  |proj g|=       0.41233
#> At iterate    51  f =       56.611  |proj g|=      0.096519
#> At iterate    52  f =       56.609  |proj g|=      0.057431
#> At iterate    53  f =       56.609  |proj g|=      0.078522
#> At iterate    54  f =       56.607  |proj g|=       0.11328
#> At iterate    55  f =       56.606  |proj g|=      0.026921
#> At iterate    56  f =       56.606  |proj g|=     0.0044438
#> At iterate    57  f =       56.606  |proj g|=     0.0020148
#> At iterate    58  f =       56.606  |proj g|=     0.0021817
#> At iterate    59  f =       56.606  |proj g|=     0.0077769
#> At iterate    60  f =       56.606  |proj g|=     0.0017723
#> At iterate    61  f =       56.606  |proj g|=    0.00017898
#> At iterate    62  f =       56.606  |proj g|=    0.00018164
#> 
#> iterations 62
#> function evaluations 68
#> segments explored during Cauchy searches 63
#> BFGS updates skipped 0
#> active bounds at final generalized Cauchy point 4
#> norm of the final projected gradient 0.000181643
#> final function value 56.6056
#> 
#> F = 56.6056
#> final  value 56.605601 
#> converged

# Print the model
print(learner$model)
#> 
#> Call:
#> DiceKriging::km(design = data, response = truth, control = pv$control)
#> 
#> Trend  coeff.:
#>                Estimate
#>  (Intercept)    20.9518
#> 
#> Covar. type  : matern5_2 
#> Covar. coeff.:
#>                Estimate
#>    theta(am)     1.3090
#>  theta(carb)    14.0000
#>   theta(cyl)     8.0000
#>  theta(disp)   801.8000
#>  theta(drat)     2.3370
#>  theta(gear)     2.3296
#>    theta(hp)   565.1725
#>  theta(qsec)     1.1729
#>    theta(vs)     2.0000
#>    theta(wt)     2.4287
#> 
#> Variance estimate: 41.95229

# Importance method
if ("importance" %in% learner$properties) print(learner$importance())

# Make predictions for the test rows
predictions = learner$predict(task, row_ids = ids$test)

# Score the predictions
predictions$score()
#> regr.mse 
#> 4.053721 
```
