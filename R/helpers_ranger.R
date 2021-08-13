ranger_get_mtry = function(pv, task) {
  to_decimal = function(bits) {
    n = length(bits)
    if (n == 0L) {
      return(0L)
    }
    sum(bits * 2L^((n - 1L):0L))
  }

  switch(to_decimal(c(is.null(pv[["mtry"]]), is.null(pv[["mtry.ratio"]]))) + 1L,
    pv, # !mtry && !mtry.ratio
    pv, #  mtry && !mtry.ratio
    {   # !mtry &&  mtry.ratio
      pv$mtry = floor(pv[["mtry.ratio"]] * length(task$feature_names))
      removed_named(pv, "mtry.ratio")
    },
    stopf("Hyperparameters 'mtry' and 'mtry.ratio' are mutually exclusive")
  )
}
