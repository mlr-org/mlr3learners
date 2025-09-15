options(old_opts)
lg = lgr::get_logger("mlr3")
lg$set_threshold(old_threshold)
future::plan(old_plan)
