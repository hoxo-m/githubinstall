context("reserve_suffix")

SUFFIX <- "suffix"
SUBDIR <- "subdir"

test_that("no suffix", {
  repo <- "klutometis/roxygen"
  
  act <- reserve_suffix(repo)
  
  expect_equal(as.vector(act), "klutometis/roxygen")
  expect_equal(attr(act, SUFFIX), "")
})

test_that("commit suffix", {
  repo <- "leeper/rio@a8d0fca27"
  
  act <- reserve_suffix(repo)

  expect_equal(as.vector(act), "leeper/rio")
  expect_equal(attr(act, SUFFIX), "@a8d0fca27")
})

test_that("pull request suffix", {
  repo <- "cloudyr/ghit#13"
  
  act <- reserve_suffix(repo)
  
  expect_equal(as.vector(act), "cloudyr/ghit")
  expect_equal(attr(act, SUFFIX), "#13")
})

test_that("branch suffix", {
  repo <- "kbenoit/quanteda[dev]"
  
  act <- reserve_suffix(repo)
  
  expect_equal(as.vector(act), "kbenoit/quanteda")
  expect_equal(attr(act, SUFFIX), "[dev]")
})

test_that("contains subdir", {
  repo <- c("mfrasca/r-logging/pkg", "AnomalyDetection", "hoxo-m/densratio")

  act <- is_contain_subdir(repo)

  expect_true(act[1])
  expect_false(act[2])
  expect_false(act[3])
})

test_that("extract_repositry_name_with_subdir", {
  repo <- c("mfrasca/r-logging/pkg", "AnomalyDetection", "hoxo-m/densratio")
  
  act <- extract_repositry_name_with_subdir(repo)
  
  expect_equal(as.vector(act), c("mfrasca/r-logging", "AnomalyDetection", "hoxo-m/densratio"))
  expect_equal(attr(act, SUBDIR), c("/pkg", "", ""))
})

test_that("contains subdir true", {
  repo <- "mfrasca/r-logging/pkg"
  
  act <- is_contain_subdir(repo)
  
  expect_true(act)
})

test_that("subdir", {
  repo <- "mfrasca/r-logging/pkg"
  
  tmp <- reserve_suffix(repo)
  act <- reserve_subdir(tmp)
  
  expect_equal(as.vector(act), "mfrasca/r-logging")
  expect_equal(attr(act, SUBDIR), "/pkg")
})
