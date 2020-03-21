#' @section Contrasts:
#' To ensure reproducibility, this learner always uses the default contrasts:
#'
#' * [contr.treatment()] for unordered factors, and
#' * [contr.poly()] for ordered factors.
#'
#' Setting the option `"contrasts"` does not have any effect.
#' Instead, set the respective hyperparameter or use \CRANpkg{mlr3pipelines} to create dummy features.
