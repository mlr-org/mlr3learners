# p = probability for levs[2] => matrix with probs for levs[1] and levs[2]
pvec2mat = function(p, levs) {
  stopifnot(is.numeric(p))
  y = matrix(c(1 - p, p), ncol = 2L, nrow = length(p))
  colnames(y) = levs
  y
}

opts_default_contrasts = list(contrasts = c("contr.treatment", "contr.poly"))


ordered_features = function(task, feature_names) {
  fn = intersect(feature_names, task$feature_names)
  task$data(cols = fn)
}

glmnet_feature_names = function(model) {
  beta = model$beta
  if (is.null(beta))
    beta = model$glmnet.fit$beta
  rownames(if (is.list(beta)) beta[[1L]] else beta)
}