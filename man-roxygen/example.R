#' @examples
#' learner = mlr3::mlr_learners$get("<%= learner_name %>")
#' print(learner)
#'
#' # available parameters:
#' as.data.table(learner$param_set)[, list(id, class, lower, upper, levels)]
