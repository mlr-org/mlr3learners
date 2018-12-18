propVectorToMatrix = function (p, levs)
{
    assertNumeric(p)
    y = matrix(0, ncol = 2L, nrow = length(p))
    colnames(y) = levs
    y[, 1L] = p
    y[, 2L] = 1 - p
    y
}
