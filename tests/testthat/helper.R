library(checkmate)
library(mlr3)

lapply(list.files(system.file("testthat", package = "mlr3"),
  pattern = "^helper.*\\.[rR]$", full.names = TRUE), source)

compute_mu_sigma2 = function(model, task) {
  prediction_nodes = predict(model, data = task$data(), type = "terminalNodes", predict.all = TRUE)
  y = task$truth()
  observation_node_table = prediction_nodes$predictions
  n_trees = NCOL(observation_node_table)
  unique_nodes_per_tree = apply(observation_node_table, MARGIN = 2L, FUN = unique, simplify = FALSE)
  mu_sigma2_per_node_per_tree = lapply(seq_len(n_trees), function(tree) {
    nodes = unique_nodes_per_tree[[tree]]
    setNames(lapply(nodes, function(node) {
      y_tmp = y[observation_node_table[, tree] == node]
      c(mu = mean(y_tmp), sigma2 = if (length(y_tmp) > 1L) var(y_tmp) else 0)
    }), nm = nodes)
  })
  list(mu_sigma2_per_node_per_tree = mu_sigma2_per_node_per_tree, prediction_nodes = prediction_nodes)
}

simple_var = function(learner, newdata, mu_sigma2_per_node_per_tree) {
  prediction_nodes = predict(learner$model$model, data = newdata, type = "terminalNodes", predict.all = TRUE)
  n_observations = NROW(prediction_nodes$predictions)
  n_trees = length(mu_sigma2_per_node_per_tree)
  response = numeric(n_observations)
  se = numeric(n_observations)
  for (i in seq_len(n_observations)) {
    mu_sigma2_per_tree = lapply(seq_len(n_trees), function(tree) {
      mu_sigma2_per_node_per_tree[[tree]][[as.character(prediction_nodes$predictions[i, tree])]]
    })
    mus = sapply(mu_sigma2_per_tree, "[[", 1)
    response[i] = mean(mus)
    se[i] = if (length(mus) > 1) sqrt(var(mus)) else 0
  }
  list(response = response, se = se)
}

ltv = function(learner, newdata, mu_sigma2_per_node_per_tree) {
  prediction_nodes = predict(learner$model$model, data = newdata, type = "terminalNodes", predict.all = TRUE)
  n_observations = NROW(prediction_nodes$predictions)
  n_trees = length(mu_sigma2_per_node_per_tree)
  response = numeric(n_observations)
  se = numeric(n_observations)
  for (i in seq_len(n_observations)) {
    mu_sigma2_per_tree = lapply(seq_len(n_trees), function(tree) {
      mu_sigma2_per_node_per_tree[[tree]][[as.character(prediction_nodes$predictions[i, tree])]]
    })
    mus = sapply(mu_sigma2_per_tree, "[[", 1)
    sigmas2 = sapply(mu_sigma2_per_tree, "[[", 2)
    response[i] = mean(mus)
    # law of total variance assuming a mixture of normal distributions for each tree
    se[i] = sqrt(mean((mus ^ 2) + sigmas2) - (response[i] ^ 2))
  }
  list(response = response, se = se)
}
