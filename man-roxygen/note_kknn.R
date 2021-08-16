#' @note
#' There is no training step for k-NN models, just storing the training data to
#' process it during the predict step.
#' Therefore, `$model` returns a list with the following elements:
#'
#' * `formula`: Formula for calling [kknn::kknn()] during `$predict()`.
#' * `data`: Training data for calling [kknn::kknn()] during `$predict()`.
#' * `pv`: Training parameters for calling [kknn::kknn()] during `$predict()`.
#' * `kknn`: Model as returned by [kknn::kknn()], only available **after** `$predict()` has been called.
