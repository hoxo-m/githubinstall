context("Install packages")

install_github_mock <- function(...) {
  list(...)
}

test_that("Install a single package", {
  repo <- "AnomalyDetection"
  with_mock(
    `devtools::install_github` = install_github_mock, 
    act <- gh_install_packages(repo, ask = FALSE)
  )
  expect_equal(act$repo, "twitter/AnomalyDetection")
})

test_that("Install two package", {
  repo <- c("AnomalyDetection", "toybayesopt")
  with_mock(
    `devtools::install_github` = install_github_mock, 
    act <- gh_install_packages(repo, ask = FALSE)
  )
  expect_equal(length(act), 2)
})
