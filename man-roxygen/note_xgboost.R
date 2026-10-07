#' @note
#' To compute on GPUs, you first need to compile \CRANpkg{xgboost} yourself and link
#' against CUDA.
#' See \url{https://xgboost.readthedocs.io/en/stable/build.html#building-with-gpu-support}.
#'
#' The `outputmargin`, `predcontrib`, `predinteraction`, and `predleaf` parameters are not supported.
#' You can still call e.g. `predict(learner$model, newdata = newdata, outputmargin = TRUE)` to get these predictions.
#'
#' Factor features are passed to \CRANpkg{xgboost} as categorical features,
#' see \url{https://xgboost.readthedocs.io/en/stable/tutorials/categorical.html}.
#' This requires `tree_method` `"hist"` (the upstream default) or `"approx"`,
#' and is not supported by the `"gblinear"` booster.
