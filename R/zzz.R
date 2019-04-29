#' @rawNamespace import(data.table, except = transpose)
#' @import paradox
#' @import mlr3misc
#' @importFrom R6 R6Class
#' @importFrom mlr3 mlr_learners LearnerClassif LearnerRegr
"_PACKAGE"


.onLoad = function(libname, pkgname) { # nocov start
  populate_dictionaries()
  setHook(packageEvent("mlr3", "onLoad"), function(...) populate_dictionaries(), action = "append")
} # nocov end
