test_that("autotest", {
  learner = mlr3::lrn("classif.log_reg")
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})

test_that("class labels are correctly encoded", {
  task = tsk("sonar")
  learner = lrn("classif.log_reg")

  task$positive = "M"
  suppressWarnings(learner$train(task))
  expect_equal(unname(learner$model$y), rep(0:1, c(97, 111)))

  task$positive = "R"
  suppressWarnings(learner$train(task))
  expect_equal(unname(learner$model$y), rep(1:0, c(97, 111)))
})
