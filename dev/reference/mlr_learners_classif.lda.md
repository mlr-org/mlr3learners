# Linear Discriminant Analysis Classification Learner

Linear discriminant analysis. Calls
[`MASS::lda()`](https://rdrr.io/pkg/MASS/man/lda.html) from package
[MASS](https://CRAN.R-project.org/package=MASS).

## Details

Parameters `method` and `prior` exist for training and prediction but
accept different values for each. Therefore, arguments for the predict
stage have been renamed to `predict.method` and `predict.prior`,
respectively.

## Dictionary

This [mlr3::Learner](https://mlr3.mlr-org.com/reference/Learner.html)
can be instantiated via the
[dictionary](https://mlr3misc.mlr-org.com/reference/Dictionary.html)
[mlr3::mlr_learners](https://mlr3.mlr-org.com/reference/mlr_learners.html)
or with the associated sugar function
[`mlr3::lrn()`](https://mlr3.mlr-org.com/reference/mlr_sugar.html):

    mlr_learners$get("classif.lda")
    lrn("classif.lda")

## Meta Information

- Task type: “classif”

- Predict Types: “response”, “prob”

- Feature Types: “logical”, “integer”, “numeric”, “factor”, “ordered”

- Required Packages: [mlr3](https://CRAN.R-project.org/package=mlr3),
  [mlr3learners](https://CRAN.R-project.org/package=mlr3learners),
  [MASS](https://CRAN.R-project.org/package=MASS)

## Parameters

|                |           |         |                               |                       |
|----------------|-----------|---------|-------------------------------|-----------------------|
| Id             | Type      | Default | Levels                        | Range                 |
| dimen          | untyped   | \-      |                               | \-                    |
| method         | character | moment  | moment, mle, mve, t           | \-                    |
| nu             | integer   | \-      |                               | \\(-\infty, \infty)\\ |
| predict.method | character | plug-in | plug-in, predictive, debiased | \-                    |
| predict.prior  | untyped   | \-      |                               | \-                    |
| prior          | untyped   | \-      |                               | \-                    |
| tol            | numeric   | \-      |                               | \\(-\infty, \infty)\\ |

## References

Venables WN, Ripley BD (2002). *Modern Applied Statistics with S*,
Fourth edition. Springer, New York. ISBN 0-387-95457-0,
<http://www.stats.ox.ac.uk/pub/MASS4/>.

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
[`mlr_learners_regr.km`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.km.md),
[`mlr_learners_regr.lm`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.lm.md),
[`mlr_learners_regr.nnet`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.nnet.md),
[`mlr_learners_regr.ranger`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.ranger.md),
[`mlr_learners_regr.svm`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.svm.md),
[`mlr_learners_regr.xgboost`](https://mlr3learners.mlr-org.com/dev/reference/mlr_learners_regr.xgboost.md)

## Super classes

[`mlr3::Learner`](https://mlr3.mlr-org.com/reference/Learner.html) -\>
[`mlr3::LearnerClassif`](https://mlr3.mlr-org.com/reference/LearnerClassif.html)
-\> `LearnerClassifLDA`

## Methods

### Public methods

- [`LearnerClassifLDA$new()`](#method-LearnerClassifLDA-new)

- [`LearnerClassifLDA$clone()`](#method-LearnerClassifLDA-clone)

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

    LearnerClassifLDA$new()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    LearnerClassifLDA$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
# Define the Learner and set parameter values
learner = lrn("classif.lda")
print(learner)
#> 
#> ── <LearnerClassifLDA> (classif.lda): Linear Discriminant Analysis ─────────────
#> • Model: -
#> • Parameters: list()
#> • Packages: mlr3, mlr3learners, and MASS
#> • Predict Types: [response] and prob
#> • Feature Types: logical, integer, numeric, factor, and ordered
#> • Encapsulation: none (fallback: -)
#> • Properties: multiclass and twoclass
#> • Other settings: use_weights = 'error'

# Define a Task
task = tsk("sonar")

# Create train and test set
ids = partition(task)

# Train the learner on the training ids
learner$train(task, row_ids = ids$train)

# Print the model
print(learner$model)
#> Call:
#> lda(formula, data = task$data())
#> 
#> Prior probabilities of groups:
#>         M         R 
#> 0.5827338 0.4172662 
#> 
#> Group means:
#>           V1       V10       V11       V12       V13       V14       V15
#> M 0.03423951 0.2479111 0.2831877 0.2918852 0.3029284 0.3109679 0.3222062
#> R 0.02063103 0.1638034 0.1722966 0.1840069 0.2188172 0.2724690 0.3253138
#>         V16       V17       V18       V19         V2       V20       V21
#> M 0.3763086 0.4150259 0.4603580 0.5490531 0.04626543 0.6319605 0.6794938
#> R 0.3981707 0.4291121 0.4387017 0.4466172 0.02755345 0.4840310 0.5296862
#>         V22       V23       V24       V25       V26       V27       V28
#> M 0.6767667 0.6705642 0.6721198 0.6582938 0.6799741 0.6899272 0.6909481
#> R 0.5546379 0.6115207 0.6630345 0.6785259 0.7071121 0.7117655 0.6897017
#>         V29         V3       V30       V31       V32       V33       V34
#> M 0.6326815 0.04987901 0.5756901 0.4717148 0.4249938 0.4077358 0.3858691
#> R 0.6169086 0.03668448 0.5591069 0.5136448 0.4336138 0.4140552 0.4128276
#>         V35       V36       V37       V38       V39         V4       V40
#> M 0.3558593 0.3305099 0.3300247 0.3449593 0.3433716 0.06426543 0.3106457
#> R 0.4323310 0.4507431 0.4146241 0.3425638 0.3233603 0.04178793 0.3230776
#>         V41      V42       V43       V44       V45       V46        V47
#> M 0.2980963 0.305621 0.2735802 0.2388407 0.2428173 0.2032827 0.14611975
#> R 0.2836569 0.238031 0.2026483 0.1606155 0.1352379 0.1081431 0.08970172
#>         V48        V49         V5        V50        V51        V52         V53
#> M 0.1097889 0.06393457 0.08603210 0.02335556 0.01952840 0.01626667 0.011839506
#> R 0.0672500 0.03882586 0.06174828 0.01794655 0.01309483 0.01083793 0.009622414
#>          V54         V55         V56         V57         V58         V59
#> M 0.01236420 0.010301235 0.009453086 0.008349383 0.009440741 0.008354321
#> R 0.00987069 0.008363793 0.007455172 0.008368966 0.006553448 0.007005172
#>          V6         V60        V7        V8        V9
#> M 0.1103556 0.006712346 0.1245790 0.1528790 0.2132667
#> R 0.1032362 0.005915517 0.1200362 0.1274224 0.1460466
#> 
#> Coefficients of linear discriminants:
#>             LD1
#> V1  -24.2744914
#> V10   7.1689268
#> V11   1.0806276
#> V12  -5.3427579
#> V13  -6.0077984
#> V14   2.8838739
#> V15  -2.8148267
#> V16   0.2105987
#> V17   6.6369372
#> V18  -5.3642870
#> V19  -1.8220264
#> V2  -26.2070638
#> V20   1.6767499
#> V21   3.2212313
#> V22  -4.9240974
#> V23   3.4658965
#> V24  -6.9760036
#> V25   5.8500842
#> V26  -3.2683383
#> V27   2.6986220
#> V28  -2.3418142
#> V29   5.5669407
#> V3   31.3545246
#> V30 -10.8415714
#> V31  13.1153880
#> V32  -8.3819016
#> V33   4.4095109
#> V34   1.4096694
#> V35  -5.2101073
#> V36   4.2741312
#> V37   0.8639131
#> V38   0.9848940
#> V39  -5.5356019
#> V4  -20.1924247
#> V40   3.1036849
#> V41   0.2847652
#> V42  -2.7692876
#> V43   7.9151710
#> V44 -10.8194990
#> V45   6.7747446
#> V46  -4.1738947
#> V47   4.8727418
#> V48 -23.1638808
#> V49  -3.6634848
#> V5    0.6170108
#> V50  27.2459738
#> V51  46.1201615
#> V52 -38.3267676
#> V53  -6.6137493
#> V54  -0.9354063
#> V55  55.8428785
#> V56  71.8513647
#> V57  55.3246457
#> V58 -57.1265465
#> V59 -52.3003893
#> V6   -0.4856437
#> V60  -4.9144764
#> V7   12.8189462
#> V8    2.9664106
#> V9   -9.0052852

# Importance method
if ("importance" %in% learner$properties) print(learner$importance())

# Make predictions for the test rows
predictions = learner$predict(task, row_ids = ids$test)

# Score the predictions
predictions$score()
#> classif.ce 
#>  0.3623188 
```
