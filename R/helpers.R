# p = probability for levs[2] => matrix with probs for levs[1] and levs[2]
pvec2mat = function(p, levs) {
  stopifnot(is.numeric(p))
  y = matrix(c(1 - p, p), ncol = 2L, nrow = length(p))
  colnames(y) = levs
  y
}


ordered_features = function(task, learner) {
  cols = names(learner$state$task_prototype %??% learner$state$data_prototype)
  task$data(cols = intersect(cols, task$feature_names))
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
  if (length(x)) {
    ii = match(names(x), old, nomatch = 0L)
    names(x)[ii > 0L] = new[ii]
  }
  x
}


extract_loglik = function(self) {
  require_namespaces(self$packages)
  if (is.null(self$model)) {
    stopf("Learner '%s' has no model stored", self$id)
  }
  stats::logLik(self$model)
}


opts_default_contrasts = list(contrasts = c("contr.treatment", "contr.poly"))
