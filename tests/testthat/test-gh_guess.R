context("gh_guess")

test_that("single result", {
  repo <- "AnomalyDetection"
  
  act <- gh_guess(repo)
  
  expect_equal(act, "twitter/AnomalyDetection")
})

test_that("multi result", {
  repo <- "test"
  
  act <- gh_guess(repo)
  
  expect_gt(length(act), 1)
})

test_that("has title", {
  repo <- "AnomalyDetection"
  
  act <- gh_guess(repo, keep_title = TRUE)
  
  expect_false(is.null(attr(act, "title")))
})

