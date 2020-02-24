# p = probability for levs[2] => matrix with probs for levs[1] and levs[2]
prob_vector_to_matrix = function(p, levs) {
  stopifnot(is.numeric(p))
  y = matrix(c(1 - p, p), ncol = 2L, nrow = length(p))
  colnames(y) = levs
  y
}

opts_default_contrasts = list(contrasts = c("contr.treatment", "contr.poly"))
