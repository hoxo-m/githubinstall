context("utils")

test_that("get_package_list", {
  act <- get_package_list()

  expect_false(is.null(act))
})

test_that("stop_without_message", {
  expect_error(
    expect_silent(
      stop_without_message()
    )
  )
})
