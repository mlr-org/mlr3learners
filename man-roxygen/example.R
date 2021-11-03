<%
lrn = mlr3::lrn(id)
pkgs = setdiff(lrn$packages, c("mlr3", "mlr3learners"))
%>
#' @examples
#' if (<%= paste0("requireNamespace(\"", pkgs, "\")", collapse = " && ") %>) {
#'   learner = mlr3::lrn("<%= id %>")
#'   print(learner)
#'
#'   # available parameters:
#' learner$param_set$ids()
#' }
