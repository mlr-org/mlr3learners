# mlr3 measure to custom inner measure functions
xgboost_binary_binary_prob = function(pred, dtrain, measure, ...) {
  # label is a vector of labels (0, 1)
  truth = factor(xgboost::getinfo(dtrain, "label"), levels = c(0, 1))
  # pred is a vector of log odds
  # transform log odds to probabilities
  pred = 1 / (1 + exp(-pred))
  measure$fun(truth, pred, positive = "1")
}

xgboost_binary_classif_prob = function(pred, dtrain, measure, ...) {
  # label is a vector of labels (0, 1)
  truth = factor(xgboost::getinfo(dtrain, "label"), levels = c(0, 1))
  # pred is a vector of log odds
  # transform log odds to probabilities
  pred = 1 / (1 + exp(-pred))
  # multiclass measure needs a matrix of probabilities
  pred_mat = matrix(c(pred, 1 - pred), ncol = 2)
  colnames(pred_mat) = c("1", "0")
  measure$fun(truth, pred_mat, positive = "1")
}

xgboost_binary_response = function(pred, dtrain, measure, ...) {
  # label is a vector of labels (0, 1)
  truth = factor(xgboost::getinfo(dtrain, "label"), levels = c(0, 1))
  # pred is a vector of log odds
  response = factor(as.integer(pred > 0), levels = c(0, 1))
  measure$fun(truth, response)
}

xgboost_multiclass_prob = function(pred, dtrain, measure, n_classes, ...) {
  # label is a vector of labels (0, 1, ..., n_classes - 1)
  truth = factor(xgboost::getinfo(dtrain, "label"), levels = seq_len(n_classes) - 1L)

  # pred is a matrix of log odds for each class
  # transform log odds to probabilities
  pred_exp = exp(pred)
  pred_mat = pred_exp / rowSums(pred_exp)
  colnames(pred_mat) = levels(truth)

  measure$fun(truth, pred_mat)
}

xgboost_multiclass_response = function(pred, dtrain, measure, n_classes, ...) {
  # label is a vector of labels (0, 1, ..., n_classes - 1)
  truth = factor(xgboost::getinfo(dtrain, "label"), levels = seq_len(n_classes) - 1L)

  # pred is a matrix of log odds for each class
  response = factor(max.col(pred, ties.method = "random") - 1, levels = levels(truth))
  measure$fun(truth, response)
}

# convenience function for classif.xgboost
# returns base_margin (vector / matrix) or NULL
xgboost_get_base_margin = function(task, phase = "train", pv) {
  assert_choice(phase, c("train", "predict"))

  # task needs to support offset
  if ("offset" %nin% task$properties) {
    return(NULL)
  }

  is_predict = (phase == "predict")
  use_pred_offset = isTRUE(pv$use_pred_offset)

  # prediction phase but offset disabled
  if (is_predict && !use_pred_offset) {
    return(NULL)
  }

  offset = task$offset
  n_levels = length(task$class_names)

  # binary classification: return vector
  if (n_levels == 2L) {
    return(offset$offset)
  }

  # multiclass: return (n_obs x n_classes) matrix
  # xgboost expects columns ordered by internal label encoding
  # it seems reasonable to reorder according to label (0,1,2,...)
  # which is reverted in the train function due to integer conversion
  reordered_cols = paste0("offset_", rev(levels(task$truth())))
  n_offsets = ncol(offset) - 1L  # excluding row_id

  if (length(reordered_cols) != n_offsets) {
    stopf(
      "Task has %i class labels, but %i offset columns are provided",
      n_levels, n_offsets
    )
  }

  as_numeric_matrix(offset)[, reordered_cols, drop = FALSE]
}
