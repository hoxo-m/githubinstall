context("Install packages")

tmp <- file.path(tempdir(), "tmplib")
suppressWarnings(dir.create(tmp))

test_that("Install a single package", {
  repo <- "AnomalyDetection"

  act <- suppressWarnings(gh_install_packages(repo, ask = FALSE, lib = tmp))

  expect_false(is.na(act))
  remove.packages("AnomalyDetection", lib = tmp)
})

test_that("Install two packages", {
  repo <- c("AnomalyDetection", "toybayesopt")

  act <- suppressWarnings(gh_install_packages(repo, ask = FALSE, lib = tmp))
  expect_equal(length(act), 2)
  expect_false(is.na(act[1]))
  expect_false(is.na(act[2]))
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
