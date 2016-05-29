context("gh_get_package_info")

test_that("gh_get_package_info", {
  act <- gh_get_package_info(authors = "hadley")
  
  expect_false(is.null(act))
})
