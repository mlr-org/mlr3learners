<%
lrn = mlr3::lrn(id)
pkgs = setdiff(lrn$packages, c("mlr3", "mlr3learners"))
%>
#' <% task_id = if ("LearnerClassif" %in% class(lrn(id))) "sonar" else "mtcars" %>
#'
#' @examples
#' if (<%= paste0("requireNamespace(\"", pkgs, "\", quietly = TRUE)", collapse = " && ") %>) {
#' # Define the Learner and set parameter values
#' <%= sprintf("learner = lrn(\"%s\")", id)%>
#' print(learner)
#'
#' # Define a Task
#' <%= sprintf("task = tsk(\"%s\")", task_id)%>
#'
#' # Create train and test set
#' <%= sprintf("ids = partition(task)")%>
#'
#' # Train the learner on the training ids
#' <%= sprintf("learner$train(task, row_ids = ids$train)")%>
#'
#' # print the model
#' print(learner$model)
#'
#' # importance method
#' if("importance" %in% learner$properties) print(learner$importance)
#'
#' # Make predictions for the test rows
#' <%= sprintf("predictions = learner$predict(task, row_ids = ids$test)")%>
#'
#' # Score the predictions
#' predictions$score()
#' }
