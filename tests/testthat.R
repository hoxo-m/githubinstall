library(testthat)
library(githubinstall)

test_check("githubinstall",  filter = "[^(really_install)]")
