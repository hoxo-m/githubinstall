context("is_full_repo_name")

test_that("no full name", {
  repo <- "densratio"
  
  act <- is_full_repo_name(repo)
  
  expect_equal(act, FALSE)
})

test_that("full name", {
  repo <- "hoxo-m/densratio"
  
  act <- is_full_repo_name(repo)
  
  expect_equal(act, TRUE)
})
