# p = probability for levs[2] => matrix with probs for levs[1] and levs[2]
prob_vector_to_matrix = function(p, levs) {
  checkmate::assert_numeric(p)
  y = matrix(c(1 - p, p), ncol = 2L, nrow = length(p))
  colnames(y) = levs
  y
}
