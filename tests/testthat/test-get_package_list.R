context("get_package_list")

test_that("get_package_list", {
  act <- get_package_list()

  expect_false(is.null(act))
})
