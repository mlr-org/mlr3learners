---
name: Learner Request
about: Request the implementation of a new learner
title: Connect learner [LRN] from package [PKG]
labels: 'Status: Pending, Type: Learner Request'
assignees: ''

---

Before making this request, make sure that

1. The learner is not maintained in a third party repository (listed in the [Table of all additional Learners](https://mlr3learners.mlr-org.com/dev/articles/learners/additional-learners.html)), and
2. There is no other open or closed issue on this learner in this tracker.

## Checklist before requesting a review

- [ ] Run `styler::style_pkg(style = styler::mlr_style)` (install `pat-s/styler@mlr-style` if not yet done)

- [ ] Run `lintr::lint_package()` and fix all issues.

- [ ] Run `usethis::use_tidy_description()` to format the `DESCRIPTION` file.

- [ ] Check that the learner package name is all lower case, e.g. `mlr3learners.partykit`.

- [ ] Ensure that there are not leftover of `<package>`, `<algorithm>` or `<type>` within the learner repo.

- [ ] Ensure that the "Parameter Check" passed in the CI (both for the train **and** predict functions)

- [ ] Ensure that "R CMD check" passed in the CI.

- [ ] Check that your learners upstream package is **not** listed in the "Imports" but in the "Suggests" section within the `DESCRIPTION` file.

- [ ] If you changed any parameter defaults: Did you document the change (reason and new default) in the help page of the respective learner?

- [ ] Open a Pull Request in the mlr3learners repo to add your learner to the list of ["In Progress" learners](https://mlr3learners.mlr-org.com/dev/articles/learners/additional-learners.html#in-progress-1). Once approved, it will be moved to the "Approved" section.
