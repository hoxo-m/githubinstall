context("gh_list_packages")

test_that("gh_list_packages", {
  act <- gh_list_packages(username = "hadley")
  
  expect_false(is.null(act))
})
