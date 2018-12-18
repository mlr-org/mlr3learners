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

# helper for glmnet
getFixDataInfo = function(data, restore.levels = FALSE, factors.to.dummies = FALSE, ordered.to.int = FALSE) {
  assertDataFrame(data, types = c("logical", "numeric", "factor"))
  assertFlag(restore.levels)
  assertFlag(factors.to.dummies)
  assertFlag(ordered.to.int)

  cl = vcapply(data, getClass1)
  factors = lapply(data[cl == "factor"], levels)
  ordered = lapply(data[cl == "ordered"], levels)

  makeS3Obj("FixDataInfo",
    factors = factors,
    ordered = ordered,
    restore.levels = restore.levels,
    factors.to.dummies = factors.to.dummies && length(factors) > 0L,
    ordered.to.int = ordered.to.int && length(ordered) > 0L
  )
}

fixDataForLearner = function(data, info) {
  cn = c(names(info$factors), names(info$ordered))
  not.found = which.first(cn %nin% names(data))
  if (length(not.found) > 0L)
    stopf("Column '%s' found in info, but not in new data", cn[not.found])

  if (info$restore.levels) {
    if (!info$factors.to.dummies && length(info$factors) > 0L) {
      cols = names(info$factors)
      data[cols] = Map(factor, x = data[cols], levels = info$factors)
    }
    if (!info$ordered.to.int && length(info$ordered) > 0L) {
      cols = names(info$ordered)
      data[cols] = Map(factor, x = data[cols], levels = info$ordered, ordered = TRUE)
    }
  }

  if (info$factors.to.dummies) {
    cols = names(info$factors)
    new.cols = Map(function(x, lvls) {
      as.data.frame(setNames(lapply(lvls, "==", x), lvls))
    }, x = data[cols], lvls = info$factors)
    data = cbind(dropNamed(data, cols), do.call(cbind, new.cols))
  }

  if (info$ordered.to.int) {
    cols = names(info$ordered)
    data[cols] = lapply(data[cols], as.integer)
  }

  data
}

attachTrainingInfo = function(x, info) {
  attr(x, "mlr3.train.info") = info
  x
}

getTrainingInfo = function(x) {
  attr(x, "mlr3.train.info") %??% attr(x$model, "mlr3.train.info")
}




