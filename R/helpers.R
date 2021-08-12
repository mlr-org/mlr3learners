# p = probability for levs[2] => matrix with probs for levs[1] and levs[2]
pvec2mat = function(p, levs) {
  stopifnot(is.numeric(p))
  y = matrix(c(1 - p, p), ncol = 2L, nrow = length(p))
  colnames(y) = levs
  y
}


ordered_features = function(task, feature_names) {
  fn = intersect(feature_names, task$feature_names)
  task$data(cols = fn)
}


as_numeric_matrix = function(x) { # for svm / #181
  x = as.matrix(x)
  if (is.logical(x)) {
    storage.mode(x) = "double"
  }
  x
}


swap_levels = function(x) {
  factor(x, levels = rev(levels(x)))
}


rename = function(x, old, new) {
  ii = match(names(x), old, nomatch = 0L)
  names(x)[ii > 0L] = new[ii]
  x
}


opts_default_contrasts = list(contrasts = c("contr.treatment", "contr.poly"))