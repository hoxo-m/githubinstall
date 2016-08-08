context("gh_suggest")

test_that("full name", {
  repo <- "twitter/AnomalyDetection"
  act <- gh_suggest(repo_name = repo, keep_title = FALSE)
  expect_equal(act, "twitter/AnomalyDetection")
})

test_that("full name: has title", {
  repo <- "twitter/AnomalyDetection"
  act <- gh_suggest(repo_name = repo, keep_title = TRUE)
  expect_false(is.null(attr(act, "title")))
})

test_that("no full name: single result", {
  repo <- "AnomalyDetection"
  act <- gh_suggest(repo_name = repo, keep_title = FALSE)
  expect_equal(act, "twitter/AnomalyDetection")
})

test_that("no full name: multi result", {
  repo <- "cats"
  act <- gh_suggest(repo_name = repo, keep_title = FALSE)
  expect_gt(length(act), 1)
})

test_that("no full name: has title", {
  repo <- "AnomalyDetection"
  act <- gh_suggest(repo_name = repo, keep_title = TRUE)
  expect_false(is.null(attr(act, "title")))
})

context("Utils for Suggest")

test_that("to_candidates: no inds", {
  package_name <- "XXX_never_package_name_XXXX"
  act <- to_candidates(package_name = package_name)
  expect_null(act)
})

test_that("to_candidates: single result", {
  package_name <- "AnomalyDetection"
  act <- to_candidates(package_name = package_name, keep_title = FALSE)
  expect_equal(act, "twitter/AnomalyDetection")
})

test_that("to_candidates: multi result", {
  package_name <- "cats"
  act <- to_candidates(package_name = package_name, keep_title = FALSE)
  expect_gt(length(act), 1)
})

test_that("to_candidates: has title", {
  package_name <- "AnomalyDetection"
  act <- to_candidates(package_name = package_name, keep_title = TRUE)
  expect_false(is.null(attr(act, "title")))
})

test_that("is_full_repo_name: no full name", {
  repo <- "densratio"
  act <- is_full_repo_name(repo)
  expect_false(act)
})

test_that("is_full_repo_name: full name", {
  repo <- "hoxo-m/densratio"
  act <- is_full_repo_name(repo)
  expect_true(act)
})
