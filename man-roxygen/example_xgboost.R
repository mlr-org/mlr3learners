<%
learner = mlr3::lrn(id)
task_id = if ("LearnerClassif" %in% class(learner)) "sonar" else "mtcars"
%>
#' <%= sprintf("@examplesIf mlr3misc::require_namespaces(lrn(\"%s\")$packages, quietly = TRUE)", id) %>
#' # Define the Learner and set parameter values
#' <%= sprintf("learner = lrn(\"%s\")", id) %>
#' print(learner)
#'
#' # Define a Task
#' <%= sprintf("task = tsk(\"%s\")", task_id) %>
#'
#' # Create train and test set
#' ids = partition(task)
#'
#' # Train the learner on the training ids
#' learner$train(task, row_ids = ids$train)
#'
#' # Print the model
#' print(learner$model)
#'
#' # Importance method
#' if ("importance" %in% learner$properties) print(learner$importance())
#'
#' # Make predictions for the test rows
#' predictions = learner$predict(task, row_ids = ids$test)
#'
#' # Score the predictions
#' predictions$score()
#'
#' # Early stopping
#' <%= sprintf("learner = lrn(\"%s\", nrounds = 100, early_stopping_rounds = 10, validate = 0.3)", id) %>
#'
#' # Train learner with early stopping
#' learner$train(task)
#'
#' # Inspect optimal nrounds and validation performance
#' learner$internal_tuned_values
#' learner$internal_valid_scores

