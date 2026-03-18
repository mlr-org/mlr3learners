# Naive Bayes Classification Learner

Naive Bayes classification. Calls
[`e1071::naiveBayes()`](https://rdrr.io/pkg/e1071/man/naiveBayes.html)
from package [e1071](https://CRAN.R-project.org/package=e1071).

## Dictionary

This [mlr3::Learner](https://mlr3.mlr-org.com/reference/Learner.html)
can be instantiated via the
[dictionary](https://mlr3misc.mlr-org.com/reference/Dictionary.html)
[mlr3::mlr_learners](https://mlr3.mlr-org.com/reference/mlr_learners.html)
or with the associated sugar function
[`mlr3::lrn()`](https://mlr3.mlr-org.com/reference/mlr_sugar.html):

    mlr_learners$get("classif.naive_bayes")
    lrn("classif.naive_bayes")

## Meta Information

- Task type: “classif”

- Predict Types: “response”, “prob”

- Feature Types: “logical”, “integer”, “numeric”, “factor”

- Required Packages: [mlr3](https://CRAN.R-project.org/package=mlr3),
  [mlr3learners](https://CRAN.R-project.org/package=mlr3learners),
  [e1071](https://CRAN.R-project.org/package=e1071)

## Parameters

|           |         |         |                       |
|-----------|---------|---------|-----------------------|
| Id        | Type    | Default | Range                 |
| eps       | numeric | 0       | \\(-\infty, \infty)\\ |
| laplace   | numeric | 0       | \\\[0, \infty)\\      |
| threshold | numeric | 0.001   | \\(-\infty, \infty)\\ |

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
-\> `LearnerClassifNaiveBayes`

## Methods

### Public methods

- [`LearnerClassifNaiveBayes$new()`](#method-LearnerClassifNaiveBayes-new)

- [`LearnerClassifNaiveBayes$clone()`](#method-LearnerClassifNaiveBayes-clone)

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

    LearnerClassifNaiveBayes$new()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    LearnerClassifNaiveBayes$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
# Define the Learner and set parameter values
learner = lrn("classif.naive_bayes")
print(learner)
#> 
#> ── <LearnerClassifNaiveBayes> (classif.naive_bayes): Naive Bayes ───────────────
#> • Model: -
#> • Parameters: list()
#> • Packages: mlr3, mlr3learners, and e1071
#> • Predict Types: [response] and prob
#> • Feature Types: logical, integer, numeric, and factor
#> • Encapsulation: none (fallback: -)
#> • Properties: multiclass and twoclass
#> • Other settings: use_weights = 'error', predict_raw = 'FALSE'

# Define a Task
task = tsk("sonar")

# Create train and test set
ids = partition(task)

# Train the learner on the training ids
learner$train(task, row_ids = ids$train)

# Print the model
print(learner$model)
#> 
#> Naive Bayes Classifier for Discrete Predictors
#> 
#> Call:
#> naiveBayes.default(x = x, y = y)
#> 
#> A-priori probabilities:
#> y
#>         M         R 
#> 0.5035971 0.4964029 
#> 
#> Conditional probabilities:
#>    V1
#> y         [,1]       [,2]
#>   M 0.03576143 0.02684351
#>   R 0.02209565 0.01559364
#> 
#>    V10
#> y        [,1]      [,2]
#>   M 0.2726129 0.1421090
#>   R 0.1588696 0.1185101
#> 
#>    V11
#> y        [,1]      [,2]
#>   M 0.3043686 0.1361172
#>   R 0.1724275 0.1171354
#> 
#>    V12
#> y        [,1]      [,2]
#>   M 0.3100729 0.1301461
#>   R 0.1840812 0.1321283
#> 
#>    V13
#> y        [,1]      [,2]
#>   M 0.3244829 0.1396395
#>   R 0.2238464 0.1393880
#> 
#>    V14
#> y        [,1]      [,2]
#>   M 0.3332643 0.1766075
#>   R 0.2611797 0.1673167
#> 
#>    V15
#> y        [,1]      [,2]
#>   M 0.3422671 0.2084315
#>   R 0.2911377 0.2162335
#> 
#>    V16
#> y        [,1]      [,2]
#>   M 0.3821657 0.2314869
#>   R 0.3597014 0.2464136
#> 
#>    V17
#> y        [,1]      [,2]
#>   M 0.4003786 0.2602862
#>   R 0.3879000 0.2829729
#> 
#>    V18
#> y        [,1]      [,2]
#>   M 0.4338314 0.2669955
#>   R 0.4174826 0.2629652
#> 
#>    V19
#> y        [,1]      [,2]
#>   M 0.5156686 0.2657469
#>   R 0.4363855 0.2472369
#> 
#>    V2
#> y         [,1]       [,2]
#>   M 0.04520857 0.03243771
#>   R 0.03037391 0.02639112
#> 
#>    V20
#> y        [,1]      [,2]
#>   M 0.5974200 0.2725917
#>   R 0.4626855 0.2485295
#> 
#>    V21
#> y        [,1]      [,2]
#>   M 0.6437671 0.2733279
#>   R 0.4987290 0.2413938
#> 
#>    V22
#> y        [,1]      [,2]
#>   M 0.6464457 0.2514303
#>   R 0.5333333 0.2673713
#> 
#>    V23
#> y        [,1]      [,2]
#>   M 0.6484114 0.2654438
#>   R 0.5817986 0.2564723
#> 
#>    V24
#> y        [,1]      [,2]
#>   M 0.6641671 0.2584230
#>   R 0.6187058 0.2446702
#> 
#>    V25
#> y        [,1]      [,2]
#>   M 0.6623857 0.2485371
#>   R 0.6287870 0.2645679
#> 
#>    V26
#> y        [,1]      [,2]
#>   M 0.7076943 0.2330708
#>   R 0.6625348 0.2469941
#> 
#>    V27
#> y        [,1]      [,2]
#>   M 0.7195943 0.2597404
#>   R 0.6733986 0.2273145
#> 
#>    V28
#> y        [,1]      [,2]
#>   M 0.7141914 0.2524030
#>   R 0.6753275 0.2076381
#> 
#>    V29
#> y        [,1]      [,2]
#>   M 0.6535357 0.2350319
#>   R 0.6370029 0.2426187
#> 
#>    V3
#> y         [,1]       [,2]
#>   M 0.05095714 0.03566286
#>   R 0.03528261 0.03073139
#> 
#>    V30
#> y        [,1]      [,2]
#>   M 0.5830171 0.2029212
#>   R 0.6036870 0.2251306
#> 
#>    V31
#> y        [,1]      [,2]
#>   M 0.4908371 0.2245753
#>   R 0.5530855 0.1932639
#> 
#>    V32
#> y        [,1]      [,2]
#>   M 0.4405857 0.2229313
#>   R 0.4626159 0.2098553
#> 
#>    V33
#> y        [,1]      [,2]
#>   M 0.4132214 0.2045360
#>   R 0.4520246 0.2101155
#> 
#>    V34
#> y        [,1]      [,2]
#>   M 0.3652014 0.2111059
#>   R 0.4513464 0.2464201
#> 
#>    V35
#> y        [,1]      [,2]
#>   M 0.3269557 0.2453314
#>   R 0.4705870 0.2602240
#> 
#>    V36
#> y        [,1]      [,2]
#>   M 0.3052214 0.2436184
#>   R 0.4893899 0.2529661
#> 
#>    V37
#> y        [,1]      [,2]
#>   M 0.3047500 0.2272292
#>   R 0.4426101 0.2468271
#> 
#>    V38
#> y        [,1]      [,2]
#>   M 0.3258229 0.2036651
#>   R 0.3810652 0.2318662
#> 
#>    V39
#> y        [,1]      [,2]
#>   M 0.3363629 0.1857309
#>   R 0.3444217 0.2273772
#> 
#>    V4
#> y         [,1]       [,2]
#>   M 0.06339286 0.03778774
#>   R 0.04149855 0.03131444
#> 
#>    V40
#> y        [,1]      [,2]
#>   M 0.3010771 0.1652422
#>   R 0.3480333 0.2052403
#> 
#>    V41
#> y        [,1]      [,2]
#>   M 0.2797414 0.1670650
#>   R 0.3106986 0.1877347
#> 
#>    V42
#> y        [,1]      [,2]
#>   M 0.2920700 0.1697089
#>   R 0.2650203 0.1774334
#> 
#>    V43
#> y        [,1]      [,2]
#>   M 0.2768086 0.1482344
#>   R 0.2154884 0.1404886
#> 
#>    V44
#> y        [,1]      [,2]
#>   M 0.2538214 0.1531734
#>   R 0.1726913 0.1145143
#> 
#>    V45
#> y        [,1]      [,2]
#>   M 0.2477743 0.1839631
#>   R 0.1440551 0.1054603
#> 
#>    V46
#> y        [,1]      [,2]
#>   M 0.2031357 0.1604962
#>   R 0.1198101 0.1015279
#> 
#>    V47
#> y         [,1]       [,2]
#>   M 0.16128429 0.10599481
#>   R 0.09678696 0.07508253
#> 
#>    V48
#> y        [,1]       [,2]
#>   M 0.1258614 0.07319167
#>   R 0.0715913 0.05264197
#> 
#>    V49
#> y         [,1]       [,2]
#>   M 0.07143286 0.03871689
#>   R 0.03937246 0.03389372
#> 
#>    V5
#> y         [,1]       [,2]
#>   M 0.08451143 0.05083893
#>   R 0.06198551 0.04737666
#> 
#>    V50
#> y         [,1]       [,2]
#>   M 0.02507571 0.01465077
#>   R 0.01812464 0.01339883
#> 
#>    V51
#> y         [,1]       [,2]
#>   M 0.02130857 0.01533759
#>   R 0.01250000 0.00940061
#> 
#>    V52
#> y         [,1]        [,2]
#>   M 0.01616714 0.010879668
#>   R 0.01099565 0.007860576
#> 
#>    V53
#> y          [,1]        [,2]
#>   M 0.011864286 0.007562571
#>   R 0.009981159 0.006709306
#> 
#>    V54
#> y          [,1]        [,2]
#>   M 0.013040000 0.008841542
#>   R 0.009675362 0.005728166
#> 
#>    V55
#> y          [,1]        [,2]
#>   M 0.010202857 0.009150750
#>   R 0.008584058 0.005399717
#> 
#>    V56
#> y          [,1]        [,2]
#>   M 0.009448571 0.006855395
#>   R 0.007128986 0.004714748
#> 
#>    V57
#> y          [,1]        [,2]
#>   M 0.008214286 0.006693048
#>   R 0.007617391 0.005784105
#> 
#>    V58
#> y          [,1]        [,2]
#>   M 0.010165714 0.008554055
#>   R 0.006963768 0.005151983
#> 
#>    V59
#> y          [,1]        [,2]
#>   M 0.009668571 0.007351891
#>   R 0.008030435 0.005618177
#> 
#>    V6
#> y         [,1]       [,2]
#>   M 0.11148571 0.05276747
#>   R 0.09168406 0.06398966
#> 
#>    V60
#> y          [,1]        [,2]
#>   M 0.006977143 0.006143930
#>   R 0.006447826 0.003817976
#> 
#>    V7
#> y        [,1]       [,2]
#>   M 0.1342243 0.06446209
#>   R 0.1105913 0.06909169
#> 
#>    V8
#> y        [,1]       [,2]
#>   M 0.1565043 0.09010940
#>   R 0.1163783 0.08433947
#> 
#>    V9
#> y        [,1]      [,2]
#>   M 0.2251914 0.1227192
#>   R 0.1316116 0.1031606
#> 

# Importance method
if ("importance" %in% learner$properties) print(learner$importance())

# Make predictions for the test rows
predictions = learner$predict(task, row_ids = ids$test)

# Score the predictions
predictions$score()
#> classif.ce 
#>  0.3913043 
```
