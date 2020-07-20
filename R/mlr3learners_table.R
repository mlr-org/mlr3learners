# Ideally this table would be created automatically and all required packages would be installed.
#  and loaded. Required packages are mlr3, mlr3learners, mlr3proba, and all packages in
#  mlr3learners org, also when ready other packages in mlr3verse that have learners implemented in
#  them.

# library(mlr3)
# library(mlr3learners)
# library(mlr3proba)
# library(data.table)
extra_learners = rownames(available.packages(repos = "https://mlr3learners.github.io/mlr3learners.drat"))
# install.packages(extra_learners, repos = "https://mlr3learners.github.io/mlr3learners.drat")
lapply(extra_learners, require, character.only = TRUE, quietly = TRUE)

# construct all learners in attached mlr3verse
keys = mlr_learners$keys()
# potential warnings are either that external package required but not installed or package built
#  under different R version
all_lrns = suppressWarnings(mlr3::lrns(keys))

# creates data.table with id split into name and class, as well as original id;
# the mlr3 package that the learner is implemented in; external package it is interfaced from;
# learner properties; feature types; and predict types
#
# may look better as tibble, option to print given in below function
#
# ideally this table is abstracted from the user and they access it through the getter below
learner_table = data.table(t(rbindlist(list(mlr3misc::map(all_lrns, function(.x) {
  idsplt = strsplit(.x$id, ".", TRUE)[[1]]
  list(idsplt[[2]], idsplt[[1]], .x$id, strsplit(.x$man, "::", TRUE)[[1]][1],
       .x$packages[1], .x$properties, .x$feature_types, .x$predict_types)
})))))

colnames(learner_table) = c("name", "class", "id", "mlr3_package", "required_package",
                 "properties", "feature_types", "predict_types")
learner_table[,1:4] = lapply(learner_table[,1:4], as.character)
rm(all_lrns, extra_learners, keys)

# getter function for the mlr3 learner table, assume it is called `learner_table`
# args:
#  hide_cols `character()`: specify which, if any, columns to hide
#  filter `list()`: named list of conditions to filter on, names correspond to column names
#                   in table
#  tibble `logical(1)`: if TRUE returns table as tibble otherwise data.table
#
# examples:
#    list_mlr3learners(hide_cols = c("properties", "feature_types"),
#                      filter = list(class = "surv", predict_types = "distr"))
#    list_mlr3learners(tibble = TRUE)
list_mlr3learners = function(hide_cols = NULL, filter = NULL, tibble = FALSE) {

  dt = copy(learner_table)

  if (!is.null(filter)) {
    if (!is.null(filter$class)) {
      dt = subset(dt, class %in% filter$class)
    }
    if (!is.null(filter$mlr3_package)) {
      dt = subset(dt, mlr3_package %in% filter$mlr3_package)
    }
    if (!is.null(filter$required_package)) {
      dt = subset(dt, required_package %in% filter$required_package)
    }
    if (!is.null(filter$properties)) {
      dt = subset(dt, mlr3misc::map_lgl(dt$properties,
                                        function(.x) any(filter$properties %in% .x)))
    }
    if (!is.null(filter$feature_types)) {
      dt = subset(dt, mlr3misc::map_lgl(dt$feature_types,
                                        function(.x) any(filter$feature_types %in% .x)))
    }
    if (!is.null(filter$predict_types)) {
      dt = subset(dt, mlr3misc::map_lgl(dt$predict_types,
                                        function(.x) any(filter$predict_types %in% .x)))
    }
  }

  if (!is.null(hide_cols)) {
    dt = subset(dt, select = !(colnames(dt) %in% hide_cols))
  }

  if (tibble) {
    return(tibble::tibble(dt))
  } else {
    return(dt)
  }
}


# overloads lrn function to automatically detect and install learners from any packages in
# mlr3verse. uses list_mlr3learners with filtering for the given key.
# this should actually probably be implemented in mlr3misc::dictionary_sugar_get
# however this would create a dependency loop unless the learners table also lives in mlr3misc.
# a vectorised version of this for `lrns` follows naturally.
#
# the function filters the learner_table, searches to see if the required mlr3_package is installed
# and if not uses usethis::ui_yeah to ask user to install, if yes then installed and learner loaded,
# if not then errors
#
# args:
#  .key `character(1)`: learner key
#
# examples:
#
# lrn("classif.ranger")
#
# unloadNamespace("mlr3learners.coxboost")
# utils::remove.packages("mlr3learners.coxboost")
# lrn("surv.coxboost")

lrn <- function(.key, ...) {
  pkg <- unlist(subset(list_mlr3learners(), id == .key)$mlr3_package)
  inst <- suppressWarnings(require(pkg, quietly = FALSE, character.only = TRUE))
  if (!inst) {
    ans <- usethis::ui_yeah(
      sprintf("%s is not installed but is required, do you want to install this now?", pkg),
      n_no = 1
    )
    if (ans) {
      install.packages(pkg, repos = "https://mlr3learners.github.io/mlr3learners.drat")
    } else {
      stop(sprintf("%s is not installed but is required.", pkg))
    }
  }
  mlr3misc::dictionary_sugar_get(mlr_learners, .key, ...)
}



