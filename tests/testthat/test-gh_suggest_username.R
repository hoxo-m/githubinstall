context("Suggest GitHub Username")

test_that("gh_suggest_username", {
  act <- gh_suggest_username("yuhui")
  
  expect_equal(act, "yihui")
})

test_that("yutannihilation", {
  expect_equal(gh_suggest_username("yutani"), "yutannihilation")
  expect_equal(gh_suggest_username("abura"), "yutannihilation")
  expect_equal(gh_suggest_username("oil"), "yutannihilation")
})
  