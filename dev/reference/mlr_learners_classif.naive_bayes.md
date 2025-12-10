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
#> • Other settings: use_weights = 'error'

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
#>   M 0.03543571 0.02767424
#>   R 0.02228551 0.01563380
#> 
#>    V10
#> y        [,1]      [,2]
#>   M 0.2697457 0.1487176
#>   R 0.1545116 0.1139396
#> 
#>    V11
#> y        [,1]      [,2]
#>   M 0.3123100 0.1337594
#>   R 0.1678681 0.1172883
#> 
#>    V12
#> y        [,1]      [,2]
#>   M 0.3180171 0.1287576
#>   R 0.1843304 0.1330960
#> 
#>    V13
#> y        [,1]      [,2]
#>   M 0.3217900 0.1408331
#>   R 0.2235942 0.1381404
#> 
#>    V14
#> y        [,1]      [,2]
#>   M 0.3355800 0.1747611
#>   R 0.2614826 0.1632588
#> 
#>    V15
#> y        [,1]      [,2]
#>   M 0.3373357 0.2104526
#>   R 0.2936449 0.2136807
#> 
#>    V16
#> y        [,1]      [,2]
#>   M 0.3805800 0.2302481
#>   R 0.3624333 0.2429908
#> 
#>    V17
#> y        [,1]      [,2]
#>   M 0.4072243 0.2496591
#>   R 0.3864942 0.2844616
#> 
#>    V18
#> y        [,1]      [,2]
#>   M 0.4462057 0.2529618
#>   R 0.4162551 0.2636209
#> 
#>    V19
#> y        [,1]      [,2]
#>   M 0.5281171 0.2535792
#>   R 0.4405609 0.2541393
#> 
#>    V2
#> y         [,1]       [,2]
#>   M 0.04383286 0.03256179
#>   R 0.03071884 0.02591941
#> 
#>    V20
#> y        [,1]      [,2]
#>   M 0.6194171 0.2450133
#>   R 0.4682043 0.2555754
#> 
#>    V21
#> y        [,1]      [,2]
#>   M 0.6700914 0.2550814
#>   R 0.5022739 0.2500458
#> 
#>    V22
#> y        [,1]      [,2]
#>   M 0.6696386 0.2504505
#>   R 0.5301913 0.2718165
#> 
#>    V23
#> y        [,1]      [,2]
#>   M 0.6735243 0.2583763
#>   R 0.5767841 0.2549052
#> 
#>    V24
#> y        [,1]      [,2]
#>   M 0.6817771 0.2477394
#>   R 0.6165188 0.2435307
#> 
#>    V25
#> y        [,1]      [,2]
#>   M 0.6733243 0.2357445
#>   R 0.6279000 0.2642112
#> 
#>    V26
#> y        [,1]      [,2]
#>   M 0.7102514 0.2208602
#>   R 0.6635797 0.2480646
#> 
#>    V27
#> y        [,1]      [,2]
#>   M 0.7335686 0.2594018
#>   R 0.6751319 0.2278835
#> 
#>    V28
#> y        [,1]      [,2]
#>   M 0.7301329 0.2580287
#>   R 0.6794754 0.2051231
#> 
#>    V29
#> y        [,1]      [,2]
#>   M 0.6613400 0.2387862
#>   R 0.6400826 0.2445375
#> 
#>    V3
#> y         [,1]       [,2]
#>   M 0.04623857 0.03125455
#>   R 0.03513768 0.03054171
#> 
#>    V30
#> y        [,1]      [,2]
#>   M 0.5808114 0.2007254
#>   R 0.6011145 0.2277081
#> 
#>    V31
#> y        [,1]      [,2]
#>   M 0.4675314 0.2103041
#>   R 0.5464652 0.1955999
#> 
#>    V32
#> y        [,1]      [,2]
#>   M 0.4147329 0.2104932
#>   R 0.4547971 0.2094995
#> 
#>    V33
#> y        [,1]      [,2]
#>   M 0.3923986 0.1985727
#>   R 0.4519870 0.2119254
#> 
#>    V34
#> y        [,1]      [,2]
#>   M 0.3735514 0.2066956
#>   R 0.4465536 0.2490133
#> 
#>    V35
#> y        [,1]      [,2]
#>   M 0.3428857 0.2567624
#>   R 0.4571565 0.2585889
#> 
#>    V36
#> y        [,1]      [,2]
#>   M 0.3217357 0.2680625
#>   R 0.4732043 0.2611805
#> 
#>    V37
#> y        [,1]      [,2]
#>   M 0.3241429 0.2415785
#>   R 0.4349377 0.2495730
#> 
#>    V38
#> y        [,1]      [,2]
#>   M 0.3328471 0.2071929
#>   R 0.3744580 0.2306755
#> 
#>    V39
#> y        [,1]      [,2]
#>   M 0.3396243 0.1889006
#>   R 0.3400812 0.2285827
#> 
#>    V4
#> y         [,1]       [,2]
#>   M 0.05872714 0.03661336
#>   R 0.04082899 0.03138596
#> 
#>    V40
#> y        [,1]      [,2]
#>   M 0.3009229 0.1610126
#>   R 0.3448826 0.2076318
#> 
#>    V41
#> y        [,1]      [,2]
#>   M 0.2681014 0.1587514
#>   R 0.3103406 0.1880790
#> 
#>    V42
#> y        [,1]      [,2]
#>   M 0.2881229 0.1630567
#>   R 0.2667536 0.1775752
#> 
#>    V43
#> y        [,1]      [,2]
#>   M 0.2850800 0.1470607
#>   R 0.2160116 0.1388151
#> 
#>    V44
#> y        [,1]      [,2]
#>   M 0.2582271 0.1527208
#>   R 0.1732696 0.1121297
#> 
#>    V45
#> y        [,1]      [,2]
#>   M 0.2504386 0.1695908
#>   R 0.1435638 0.1047682
#> 
#>    V46
#> y        [,1]      [,2]
#>   M 0.2056514 0.1488980
#>   R 0.1205391 0.1009336
#> 
#>    V47
#> y         [,1]       [,2]
#>   M 0.15181714 0.09690115
#>   R 0.09809565 0.07429230
#> 
#>    V48
#> y         [,1]       [,2]
#>   M 0.11341000 0.06452643
#>   R 0.07255362 0.05198698
#> 
#>    V49
#> y         [,1]       [,2]
#>   M 0.06547571 0.03702589
#>   R 0.04014783 0.03362529
#> 
#>    V5
#> y         [,1]       [,2]
#>   M 0.07940714 0.04838741
#>   R 0.06065362 0.04717707
#> 
#>    V50
#> y         [,1]       [,2]
#>   M 0.02440714 0.01607869
#>   R 0.01810435 0.01346869
#> 
#>    V51
#> y         [,1]        [,2]
#>   M 0.01914286 0.015101767
#>   R 0.01269855 0.009320242
#> 
#>    V52
#> y         [,1]        [,2]
#>   M 0.01523571 0.009836107
#>   R 0.01104058 0.007716108
#> 
#>    V53
#> y         [,1]        [,2]
#>   M 0.01109429 0.007921533
#>   R 0.01021014 0.006667175
#> 
#>    V54
#> y          [,1]        [,2]
#>   M 0.012231429 0.008715912
#>   R 0.009402899 0.005615131
#> 
#>    V55
#> y          [,1]        [,2]
#>   M 0.010304286 0.009458796
#>   R 0.008531884 0.005390173
#> 
#>    V56
#> y          [,1]        [,2]
#>   M 0.008935714 0.006649377
#>   R 0.007288406 0.004663959
#> 
#>    V57
#> y          [,1]        [,2]
#>   M 0.007721429 0.006113679
#>   R 0.007795652 0.005700940
#> 
#>    V58
#> y          [,1]       [,2]
#>   M 0.009311429 0.00867927
#>   R 0.006965217 0.00515295
#> 
#>    V59
#> y          [,1]        [,2]
#>   M 0.007838571 0.006536881
#>   R 0.007949275 0.005600830
#> 
#>    V6
#> y         [,1]       [,2]
#>   M 0.10806714 0.04870222
#>   R 0.08961739 0.06079483
#> 
#>    V60
#> y          [,1]        [,2]
#>   M 0.006114286 0.003986691
#>   R 0.006372464 0.003845314
#> 
#>    V7
#> y        [,1]       [,2]
#>   M 0.1299900 0.05840901
#>   R 0.1117725 0.06876975
#> 
#>    V8
#> y        [,1]       [,2]
#>   M 0.1549586 0.08907895
#>   R 0.1172609 0.08343406
#> 
#>    V9
#> y        [,1]       [,2]
#>   M 0.2232171 0.11870299
#>   R 0.1290261 0.09934613
#> 

# Importance method
if ("importance" %in% learner$properties) print(learner$importance)

# Make predictions for the test rows
predictions = learner$predict(task, row_ids = ids$test)

# Score the predictions
predictions$score()
#> classif.ce 
#>  0.3043478 
```
