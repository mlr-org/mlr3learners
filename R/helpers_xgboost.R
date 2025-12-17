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
