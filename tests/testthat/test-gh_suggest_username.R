context("Suggest GitHub Username")

test_that("gh_suggest_username", {
  act <- gh_suggest_username("yuhui")
  
  expect_equal(act, "yihui")
})
