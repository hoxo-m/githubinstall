context("Install packages")
Sys.setenv("R_TESTS" = "")
tmp <- file.path(tempdir(), "tmplib")
suppressWarnings(dir.create(tmp))

test_that("Install a single package", {
  repo <- "AnomalyDetection"
  
  act <- suppressWarnings(gh_install_packages(repo, lib=tmp))
  expect_false(is.na(act))
  remove.packages("AnomalyDetection", lib = tmp)
})

test_that("Install tow packages", {
  repo <- c("AnomalyDetection", "densratio")
  
  act <- suppressWarnings(gh_install_packages(repo, build_vignettes = FALSE, lib=tmp))
  expect_equal(length(act), 2)
  expect_false(is.na(act[1]))
  expect_false(is.na(act[2]))
  remove.packages("AnomalyDetection", lib = tmp)
  remove.packages("densratio", lib = tmp)
})

# cleanup
if ("AnomalyDetection" %in% installed.packages(lib.loc = tmp)[, "Package"]) {
  remove.packages("AnomalyDetection", lib = tmp)
}
if ("densratio" %in% installed.packages(lib.loc = tmp)[, "Package"]) {
  remove.packages("densratio", lib = tmp)
}
unlink(tmp)
