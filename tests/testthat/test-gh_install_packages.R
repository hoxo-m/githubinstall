context("Install packages")

tmp <- file.path(tempdir(), "tmplib")
suppressWarnings(dir.create(tmp))
.libPaths(c(tmp, .libPaths()))

test_that("Install a single package", {
  repo <- "AnomalyDetection"

  act <- suppressWarnings(gh_install_packages(repo, ask = FALSE, force = TRUE))

  expect_true(act)
  remove.packages("AnomalyDetection", lib = tmp)
})

test_that("Install two packages", {
  repo <- c("AnomalyDetection", "toybayesopt")

  act <- suppressWarnings(gh_install_packages(repo, ask = FALSE, force = TRUE))
  expect_true(act)
  remove.packages("AnomalyDetection", lib = tmp)
  remove.packages("toybayesopt", lib = tmp)
})

# cleanup
if ("AnomalyDetection" %in% installed.packages(lib.loc = tmp)[, "Package"]) {
  remove.packages("AnomalyDetection", lib = tmp)
}
if ("toybayesopt" %in% installed.packages(lib.loc = tmp)[, "Package"]) {
  remove.packages("toybayesopt", lib = tmp)
}
unlink(tmp)
