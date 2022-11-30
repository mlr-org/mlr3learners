#' @import data.table
#' @import paradox
#' @import mlr3misc
#' @import checkmate
#' @importFrom R6 R6Class
#' @importFrom mlr3 mlr_learners LearnerClassif LearnerRegr
#' @importFrom stats predict reformulate
#'
#' @description
#' More learners are implemented in the [mlr3extralearners package](https://github.com/mlr-org/mlr3extralearners).
#' A guide on how to create custom learners is covered in the book:
#' \url{https://mlr3book.mlr-org.com}.
#' Feel invited to contribute a missing learner to the \CRANpkg{mlr3} ecosystem!
"_PACKAGE"

register_mlr3 = function() {
  x = utils::getFromNamespace("mlr_learners", ns = "mlr3")

  iwalk(learners, function(obj, nm) x$add(nm, obj))
}

.onLoad = function(libname, pkgname) { # nolint
  register_namespace_callback(pkgname, "mlr3", register_mlr3)
} # nocov end

.onUnload = function(libpaths) { # nolint
  mlr_learners = mlr3::mlr_learners

  walk(names(learners), function(id) mlr_learners$remove(id))
}

leanify_package()
