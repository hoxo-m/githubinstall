context("Suggest GitHub Repository")

test_that("single result", {
  repo <- "AnomalyDetection"
  
  act <- gh_suggest(repo)
  
  expect_equal(act, "twitter/AnomalyDetection")
})

test_that("multi result", {
  repo <- "test"
  
  act <- gh_suggest(repo)
  
  expect_gt(length(act), 1)
})

test_that("has title", {
  repo <- "AnomalyDetection"
  
  act <- gh_suggest(repo, keep_title = TRUE)
  
  expect_false(is.null(attr(act, "title")))
})

