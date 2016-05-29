library(testthat)
library(githubinstall)

test_check("githubinstall",  filter = "[^(gh_install_packages)]")
