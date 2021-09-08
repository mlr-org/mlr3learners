convert_ratio = function(pv, target, ratio, n) {
  to_decimal = function(bits) {
    sum(bits * 2L ^ ((length(bits) - 1L):0L))
  }

  switch(to_decimal(c(pv[[target]], pv[[ratio]]) %in% names(pv)) + 1L,
    # !mtry && !mtry.ratio
    pv,

    # !mtry && mtry.ratio
    {
      pv[[target]] = min(as.integer(pv[[ratio]] * n + 1), n)
      remove_named(pv, ratio)
    },


    # mtry && !mtry.ratio
    pv,

    # mtry && mtry.ratio
    stopf("Hyperparameters '%s' and '%s' are mutually exclusive", target, ratio)
  )
}
