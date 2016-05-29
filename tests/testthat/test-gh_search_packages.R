context("gh_search_packages")

test_that("gh_search_packages", {
  act <- gh_search_packages("lasso")
  
  expect_false(is.null(act))
})
