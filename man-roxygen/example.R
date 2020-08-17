<%
lrn = mlr3::lrn(id)
%>
#' @examples
#' if (<%= paste0("requireNamespace(\"", lrn$packages, "\")", collapse = " && ") %>) {
#'   learner = mlr3::lrn("<%= id %>")
#'   print(learner)
#'
#'   # available parameters:
#' learner$param_set$ids()
#' }
