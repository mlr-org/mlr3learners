# R CMD check
if (!ci_has_env("PARAMTEST")) {
  get_stage("install") %>%
    add_step(step_install_cran("bibtex"))

  do_package_checks()
} else {
  # PARAMTEST
  get_stage("install") %>%
    add_step(step_install_deps()) %>%
    add_step(step_session_info())

  get_stage("script") %>%
    # source helper_autotest.R from mlr3o
    add_step(step_install_github("mlr-org/mlr3")) %>% # remove when mlr3 0.13 is on CRAN
    add_step(step_install_github("rvest")) %>% # for scraping xgboost params
    add_step(step_install_github("magrittr")) %>% # for scraping xgboost params
    add_code_step(devtools::install()) %>%
    add_code_step(testthat::test_dir("inst/paramtest",
      stop_on_failure = TRUE))
}

if (ci_on_ghactions() && ci_has_env("BUILD_PKGDOWN")) {
  # creates pkgdown site and pushes to gh-pages branch
  # only for the runner with the "BUILD_PKGDOWN" env var set
  get_stage("install") %>%
    add_step(step_install_github("mlr-org/mlr3pkgdowntemplate"))
  do_pkgdown()
}
