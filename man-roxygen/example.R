#' @examples
#' learner = mlr3::mlr_learners$get("<%= learner_name %>")
#' print(learner)
#'
#' # available parameters:
#' tab = data.table::as.data.table(learner$param_set)
#' tab[, list(id, class, lower, upper, levels)]
