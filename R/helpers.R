# helper for classif.logreg
# p = probabilites for levs[1] => matrix with probs for levs[1] and levs[2]
propVectorToMatrix = function (p, levs)
{
    checkmate::assert_numeric(p)
    y = matrix(0, ncol = 2L, nrow = length(p))
    colnames(y) = levs
    y[, 1L] = p
    y[, 2L] = 1 - p
    y
}

