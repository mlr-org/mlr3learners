#' @title Convert a Ratio Hyperparameter
#'
#' @description
#' Given the named list `pv` (values of a [ParamSet]), converts a possibly provided hyperparameter
#' called `ratio` to an integer hyperparameter `target`.
#' If both are found in `pv`, an exception is thrown.
#'
#' @param pv (named `list()`).
#' @param target (`character(1)`)\cr
#'   Name of the integer hyperparameter.
#' @param ratio (`character(1)`)\cr
#'   Name of the ratio hyperparameter.
#' @param n (`integer(1)`)\cr
#'   Ratio of what?
#'
#' @return (named `list()`) with new hyperparameter settings.
#' @noRd
convert_ratio = function(pv, target, ratio, n) {
  switch(to_decimal(c(target, ratio) %in% names(pv)) + 1L,
    # !mtry && !mtry.ratio
    pv,

    # !mtry && mtry.ratio
    {
      pv[[target]] = max(ceiling(pv[[ratio]] * n), 1)
      remove_named(pv, ratio)
    },


    # mtry && !mtry.ratio
    pv,

    # mtry && mtry.ratio
    stopf("Hyperparameters '%s' and '%s' are mutually exclusive", target, ratio)
  )
}




ranger_selected_features = function(self) {
  if (is.null(self$model)) {
    stopf("No model stored")
  }

  splitvars = ranger::treeInfo(object = self$model, tree = 1)$splitvarName
  i = 2
  while (i <= self$model$num.trees &&
      !all(self$state$feature_names %in% splitvars)) {
    sv = ranger::treeInfo(object = self$model, tree = i)$splitvarName
    splitvars = union(splitvars, sv)
    i = i + 1
  }

  # order the names of the selected features in the same order as in the task
  self$state$feature_names[self$state$feature_names %in% splitvars]
}


