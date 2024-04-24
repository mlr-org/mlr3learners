#' @examples
#'
#' # Train learner with early stopping on spam data set
#' task = tsk("spam")
#'
#' # Split task into training and test set
#' split = partition(task, ratio = 0.8)
#' task$set_row_roles(split$test, "validation")
#'
#' # Set early stopping parameter
#' learner = lrn("<%= id %>",
#'   nrounds = 1000,
#'   early_stopping_rounds = 100,
#'   early_stopping = TRUE
#' )
#'
#' # Train learner with early stopping
#' learner$train(task)
