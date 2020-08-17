# R CMD check
if (!ci_has_env("PARAMTEST")) {
  get_stage("install") %>%
    add_step(step_install_cran("bibtex"))

  do_package_checks()
} else {
  # PARAMTEST
  get_stage("install") %>%
    add_step(step_install_deps())

  get_stage("script") %>%
    add_code_step(remotes::install_dev("mlr3")) %>%
    add_code_step(testthat::test_dir(system.file("paramtest", package = "mlr3learners"),
      stop_on_failure = TRUE))
}

if (ci_on_ghactions() && ci_has_env("BUILD_PKGDOWN")) {
  # creates pkgdown site and pushes to gh-pages branch
  # only for the runner with the "BUILD_PKGDOWN" env var set
  get_stage("install") %>%
    add_step(step_install_github("mlr-org/mlr3pkgdowntemplate"))
  do_pkgdown()
}
