context("gh_guess_username")

test_that("gh_guess_username", {
  act <- gh_guess_username("yuhui")
  
  expect_equal(act, "yihui")
})
