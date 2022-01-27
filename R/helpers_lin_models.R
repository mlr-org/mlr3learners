lin_model_importance = function(self) {
  task = self$state$train_task
  lvls = task$levels(task$feature_names, include_logicals = TRUE)
  nlvls = lengths(lvls)
  if (any(nlvls > 2L)) {
    stopf("Importance cannot be extracted for models fitted on factors with more than 2 features")
  }

  pvals = summary(self$model)$coefficients[, 4L]
  pvals = pvals[names(pvals) != "(Intercept)"]

  # remove the appended 2nd level for binary factor levels
  ii = (nlvls == 2L)
  pvals = rename(pvals,
    old = paste0(names(nlvls)[ii], map_chr(lvls[ii], tail, 1L)),
    new = names(nlvls)[ii]
  )

  sort(-log10(pvals), decreasing = TRUE)
}
