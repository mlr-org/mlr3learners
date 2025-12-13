# k-Nearest-Neighbor Classification Learner

k-Nearest-Neighbor classification. Calls
[`kknn::kknn()`](https://rdrr.io/pkg/kknn/man/kknn.html) from package
[kknn](https://CRAN.R-project.org/package=kknn).

## Note

There is no training step for k-NN models, just storing the training
data to process it during the predict step. Therefore, `$model` returns
a list with the following elements:

- `formula`: Formula for calling
  [`kknn::kknn()`](https://rdrr.io/pkg/kknn/man/kknn.html) during
  `$predict()`.

- `data`: Training data for calling
  [`kknn::kknn()`](https://rdrr.io/pkg/kknn/man/kknn.html) during
  `$predict()`.

- `pv`: Training parameters for calling
  [`kknn::kknn()`](https://rdrr.io/pkg/kknn/man/kknn.html) during
  `$predict()`.

- `kknn`: Model as returned by
  [`kknn::kknn()`](https://rdrr.io/pkg/kknn/man/kknn.html), only
  available **after** `$predict()` has been called. This is not stored
  by default, you must set hyperparameter `store_model` to `TRUE`.

## Initial parameter values

- `store_model`:

  - See note.

## Dictionary

This [mlr3::Learner](https://mlr3.mlr-org.com/reference/Learner.html)
can be instantiated via the
[dictionary](https://mlr3misc.mlr-org.com/reference/Dictionary.html)
[mlr3::mlr_learners](https://mlr3.mlr-org.com/reference/mlr_learners.html)
or with the associated sugar function
[`mlr3::lrn()`](https://mlr3.mlr-org.com/reference/mlr_sugar.html):

    mlr_learners$get("classif.kknn")
    lrn("classif.kknn")

## Meta Information

- Task type: “classif”

- Predict Types: “response”, “prob”

- Feature Types: “logical”, “integer”, “numeric”, “factor”, “ordered”

- Required Packages: [mlr3](https://CRAN.R-project.org/package=mlr3),
  [mlr3learners](https://CRAN.R-project.org/package=mlr3learners),
  [kknn](https://CRAN.R-project.org/package=kknn)

## Parameters

|             |           |         |                                                                                               |                  |
|-------------|-----------|---------|-----------------------------------------------------------------------------------------------|------------------|
| Id          | Type      | Default | Levels                                                                                        | Range            |
| k           | integer   | 7       |                                                                                               | \\\[1, \infty)\\ |
| distance    | numeric   | 2       |                                                                                               | \\\[0, \infty)\\ |
| kernel      | character | optimal | rectangular, triangular, epanechnikov, biweight, triweight, cos, inv, gaussian, rank, optimal | \-               |
| scale       | logical   | TRUE    | TRUE, FALSE                                                                                   | \-               |
| ykernel     | untyped   | NULL    |                                                                                               | \-               |
| store_model | logical   | FALSE   | TRUE, FALSE                                                                                   | \-               |

## References

Hechenbichler, Klaus, Schliep, Klaus (2004). “Weighted
k-nearest-neighbor techniques and ordinal classification.” Technical
Report Discussion Paper 399, SFB 386, Ludwig-Maximilians University
Munich.
[doi:10.5282/ubm/epub.1769](https://doi.org/10.5282/ubm/epub.1769) .

Samworth, J R (2012). “Optimal weighted nearest neighbour classifiers.”
*The Annals of Statistics*, **40**(5), 2733–2763.
[doi:10.1214/12-AOS1049](https://doi.org/10.1214/12-AOS1049) .

Cover, Thomas, Hart, Peter (1967). “Nearest neighbor pattern
classification.” *IEEE transactions on information theory*, **13**(1),
21–27.
[doi:10.1109/TIT.1967.1053964](https://doi.org/10.1109/TIT.1967.1053964)
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
[`mlr_learners_classif.cv_glmnet`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.cv_glmnet.md),
[`mlr_learners_classif.glmnet`](https://mlr3learners.mlr-org.com/reference/mlr_learners_classif.glmnet.md),
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
[`mlr_learners_regr.svm`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.svm.md),
[`mlr_learners_regr.xgboost`](https://mlr3learners.mlr-org.com/reference/mlr_learners_regr.xgboost.md)

## Super classes

[`mlr3::Learner`](https://mlr3.mlr-org.com/reference/Learner.html) -\>
[`mlr3::LearnerClassif`](https://mlr3.mlr-org.com/reference/LearnerClassif.html)
-\> `LearnerClassifKKNN`

## Methods

### Public methods

- [`LearnerClassifKKNN$new()`](#method-LearnerClassifKKNN-new)

- [`LearnerClassifKKNN$clone()`](#method-LearnerClassifKKNN-clone)

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

    LearnerClassifKKNN$new()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    LearnerClassifKKNN$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
# Define the Learner and set parameter values
learner = lrn("classif.kknn")
print(learner)
#> 
#> ── <LearnerClassifKKNN> (classif.kknn): k-Nearest-Neighbor ─────────────────────
#> • Model: -
#> • Parameters: k=7
#> • Packages: mlr3, mlr3learners, and kknn
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
#> $formula
#> Class ~ .
#> NULL
#> 
#> $data
#>       Class     V1    V10    V11    V12    V13    V14    V15    V16    V17
#>      <fctr>  <num>  <num>  <num>  <num>  <num>  <num>  <num>  <num>  <num>
#>   1:      R 0.0200 0.2111 0.1609 0.1582 0.2238 0.0645 0.0660 0.2273 0.3100
#>   2:      R 0.0453 0.2872 0.4918 0.6552 0.6919 0.7797 0.7464 0.9444 1.0000
#>   3:      R 0.0762 0.4459 0.4152 0.3952 0.4256 0.4135 0.4528 0.5326 0.7306
#>   4:      R 0.0317 0.3513 0.1786 0.0658 0.0513 0.3752 0.5419 0.5440 0.5150
#>   5:      R 0.0164 0.0251 0.0801 0.1056 0.1266 0.0890 0.0198 0.1133 0.2826
#>  ---                                                                      
#> 135:      M 0.0272 0.3997 0.3941 0.3309 0.2926 0.1760 0.1739 0.2043 0.2088
#> 136:      M 0.0187 0.2684 0.3108 0.2933 0.2275 0.0994 0.1801 0.2200 0.2732
#> 137:      M 0.0323 0.2154 0.3085 0.3425 0.2990 0.1402 0.1235 0.1534 0.1901
#> 138:      M 0.0522 0.2529 0.2716 0.2374 0.1878 0.0983 0.0683 0.1503 0.1723
#> 139:      M 0.0303 0.2354 0.2898 0.2812 0.1578 0.0273 0.0673 0.1444 0.2070
#>         V18    V19     V2    V20    V21    V22    V23    V24    V25    V26
#>       <num>  <num>  <num>  <num>  <num>  <num>  <num>  <num>  <num>  <num>
#>   1: 0.2999 0.5078 0.0371 0.4797 0.5783 0.5071 0.4328 0.5550 0.6711 0.6415
#>   2: 0.8874 0.8024 0.0523 0.7818 0.5212 0.4052 0.3957 0.3914 0.3250 0.3200
#>   3: 0.6193 0.2032 0.0666 0.4636 0.4148 0.4292 0.5730 0.5399 0.3161 0.2285
#>   4: 0.4262 0.2024 0.0956 0.4233 0.7723 0.9735 0.9390 0.5559 0.5268 0.6826
#>   5: 0.3234 0.3238 0.0173 0.4333 0.6068 0.7652 0.9203 0.9719 0.9207 0.7545
#>  ---                                                                      
#> 135: 0.2678 0.2434 0.0378 0.1839 0.2802 0.6172 0.8015 0.8313 0.8440 0.8494
#> 136: 0.2862 0.2034 0.0346 0.1740 0.4130 0.6879 0.8120 0.8453 0.8919 0.9300
#> 137: 0.2429 0.2120 0.0101 0.2395 0.3272 0.5949 0.8302 0.9045 0.9888 0.9912
#> 138: 0.2339 0.1962 0.0437 0.1395 0.3164 0.5888 0.7631 0.8473 0.9424 0.9986
#> 139: 0.2645 0.2828 0.0353 0.4293 0.5685 0.6990 0.7246 0.7622 0.9242 1.0000
#>         V27    V28    V29     V3    V30    V31    V32    V33    V34    V35
#>       <num>  <num>  <num>  <num>  <num>  <num>  <num>  <num>  <num>  <num>
#>   1: 0.7104 0.8080 0.6791 0.0428 0.3857 0.1307 0.2604 0.5121 0.7547 0.8537
#>   2: 0.3271 0.2767 0.4423 0.0843 0.2028 0.3788 0.2947 0.1984 0.2341 0.1306
#>   3: 0.6995 1.0000 0.7262 0.0481 0.4724 0.5103 0.5459 0.2881 0.0981 0.1951
#>   4: 0.5713 0.5429 0.2177 0.1321 0.2149 0.5811 0.6323 0.2965 0.1873 0.2969
#>   5: 0.8289 0.8907 0.7309 0.0347 0.6896 0.5829 0.4935 0.3101 0.0306 0.0244
#>  ---                                                                      
#> 135: 0.9168 1.0000 0.7896 0.0488 0.5371 0.6472 0.6505 0.4959 0.2175 0.0990
#> 136: 0.9987 1.0000 0.8104 0.0168 0.6199 0.6041 0.5547 0.4160 0.1472 0.0849
#> 137: 0.9448 1.0000 0.9092 0.0298 0.7412 0.7691 0.7117 0.5304 0.2131 0.0928
#> 138: 0.9699 1.0000 0.8630 0.0180 0.6979 0.7717 0.7305 0.5197 0.1786 0.1098
#> 139: 0.9979 0.8297 0.7032 0.0490 0.7141 0.6893 0.4961 0.2584 0.0969 0.0776
#>         V36    V37    V38    V39     V4    V40    V41    V42    V43    V44
#>       <num>  <num>  <num>  <num>  <num>  <num>  <num>  <num>  <num>  <num>
#>   1: 0.8507 0.6692 0.6097 0.4943 0.0207 0.2744 0.0510 0.2834 0.2825 0.4256
#>   2: 0.4182 0.3835 0.1057 0.1840 0.0689 0.1970 0.1674 0.0583 0.1401 0.1628
#>   3: 0.4181 0.4604 0.3217 0.2828 0.0394 0.2430 0.1979 0.2444 0.1847 0.0841
#>   4: 0.5163 0.6153 0.4283 0.5479 0.1408 0.6133 0.5017 0.2377 0.1957 0.1749
#>   5: 0.1108 0.1594 0.1371 0.0696 0.0070 0.0452 0.0620 0.1421 0.1597 0.1384
#>  ---                                                                      
#> 135: 0.0434 0.1708 0.1979 0.1880 0.0848 0.1108 0.1702 0.0585 0.0638 0.1391
#> 136: 0.0608 0.0969 0.1411 0.1676 0.0177 0.1200 0.1201 0.1036 0.1977 0.1339
#> 137: 0.1297 0.1159 0.1226 0.1768 0.0564 0.0345 0.1562 0.0824 0.1149 0.1694
#> 138: 0.1446 0.1066 0.1440 0.1929 0.0292 0.0325 0.1490 0.0328 0.0537 0.1309
#> 139: 0.0364 0.1572 0.1823 0.1349 0.0608 0.0849 0.0492 0.1367 0.1552 0.1548
#>         V45    V46    V47    V48    V49     V5    V50    V51    V52    V53
#>       <num>  <num>  <num>  <num>  <num>  <num>  <num>  <num>  <num>  <num>
#>   1: 0.2641 0.1386 0.1051 0.1343 0.0383 0.0954 0.0324 0.0232 0.0027 0.0065
#>   2: 0.0621 0.0203 0.0530 0.0742 0.0409 0.1183 0.0061 0.0125 0.0084 0.0089
#>   3: 0.0692 0.0528 0.0357 0.0085 0.0230 0.0590 0.0046 0.0156 0.0031 0.0054
#>   4: 0.1304 0.0597 0.1124 0.1047 0.0507 0.1674 0.0159 0.0195 0.0201 0.0248
#>   5: 0.0372 0.0688 0.0867 0.0513 0.0092 0.0187 0.0198 0.0118 0.0090 0.0223
#>  ---                                                                      
#> 135: 0.0638 0.0581 0.0641 0.1044 0.0732 0.1127 0.0275 0.0146 0.0091 0.0045
#> 136: 0.0902 0.1085 0.1521 0.1363 0.0858 0.0393 0.0290 0.0203 0.0116 0.0098
#> 137: 0.0954 0.0080 0.0790 0.1255 0.0647 0.0760 0.0179 0.0051 0.0061 0.0093
#> 138: 0.0910 0.0757 0.1059 0.1005 0.0535 0.0351 0.0235 0.0155 0.0160 0.0029
#> 139: 0.1319 0.0985 0.1258 0.0954 0.0489 0.0167 0.0241 0.0042 0.0086 0.0046
#>         V54    V55    V56    V57    V58    V59     V6    V60     V7     V8
#>       <num>  <num>  <num>  <num>  <num>  <num>  <num>  <num>  <num>  <num>
#>   1: 0.0159 0.0072 0.0167 0.0180 0.0084 0.0090 0.0986 0.0032 0.1539 0.1601
#>   2: 0.0048 0.0094 0.0191 0.0140 0.0049 0.0052 0.2583 0.0044 0.2156 0.3481
#>   3: 0.0105 0.0110 0.0015 0.0072 0.0048 0.0107 0.0649 0.0094 0.1209 0.2467
#>   4: 0.0131 0.0070 0.0138 0.0092 0.0143 0.0036 0.1710 0.0103 0.0731 0.1401
#>   5: 0.0179 0.0084 0.0068 0.0032 0.0035 0.0056 0.0671 0.0040 0.1056 0.0697
#>  ---                                                                      
#> 135: 0.0043 0.0043 0.0098 0.0054 0.0051 0.0065 0.1103 0.0103 0.1349 0.2337
#> 136: 0.0199 0.0033 0.0101 0.0065 0.0115 0.0193 0.1630 0.0157 0.2028 0.1694
#> 137: 0.0135 0.0063 0.0063 0.0034 0.0032 0.0062 0.0958 0.0067 0.0990 0.1018
#> 138: 0.0051 0.0062 0.0089 0.0140 0.0138 0.0077 0.1171 0.0031 0.1257 0.1178
#> 139: 0.0126 0.0036 0.0035 0.0034 0.0079 0.0036 0.1354 0.0048 0.1465 0.1123
#>          V9
#>       <num>
#>   1: 0.3109
#>   2: 0.3337
#>   3: 0.3564
#>   4: 0.2083
#>   5: 0.0962
#>  ---       
#> 135: 0.3113
#> 136: 0.2328
#> 137: 0.1030
#> 138: 0.1258
#> 139: 0.1945
#> 
#> $pv
#> $pv$k
#> [1] 7
#> 
#> 
#> $kknn
#> NULL
#> 

# Importance method
if ("importance" %in% learner$properties) print(learner$importance)

# Make predictions for the test rows
predictions = learner$predict(task, row_ids = ids$test)

# Score the predictions
predictions$score()
#> classif.ce 
#>  0.1594203 
```
