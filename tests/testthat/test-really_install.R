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
