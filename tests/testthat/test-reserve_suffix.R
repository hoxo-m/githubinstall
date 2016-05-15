context("reserve_suffix")

SUFFIX <- "suffix"

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
