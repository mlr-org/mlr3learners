ranger_get_mtry = function(pv, task) {
  to_decimal = function(bits) {
    n = length(bits)
    sum(bits * 2L ^ ((n - 1L):0L))
  }

  switch(to_decimal(c("mtry", "mtry.ratio") %in% names(pv)) + 1L,
    # !mtry && !mtry.ratio
    pv,

    # !mtry && mtry.ratio
    remove_named(insert_named(pv, list(mtry = max(as.integer(pv[["mtry.ratio"]] * length(task$feature_names)), 1L))),
      "mtry.ratio"),

    # mtry && !mtry.ratio
    pv,

    # mtry && mtry.ratio
    stopf("Hyperparameters 'mtry' and 'mtry.ratio' are mutually exclusive")
  )
}
