context("Really install packages")

tmp <- file.path(tempdir(), "tmplib")
suppressWarnings(dir.create(tmp))

test_that("Install a single package", {
  repo <- "AnomalyDetection"
  
  act <- suppressWarnings(gh_install_packages(repo, ask = FALSE, lib = tmp, force = TRUE))
  
  expect_true(act)
  remove.packages("AnomalyDetection", lib = tmp)
})

# cleanup
if ("AnomalyDetection" %in% installed.packages(lib.loc = tmp)[, "Package"]) {
  remove.packages("AnomalyDetection", lib = tmp)
}

unlink(tmp)

# Do not run
# gh_install_packages("densratio@v0.0.3")
# gh_install_packages("densratio@e8233e6")
# gh_install_packages("densratio#2")
# gh_install_packages("densratio", ref = github_pull("2"))
# gh_install_packages("dplyr#2058")
