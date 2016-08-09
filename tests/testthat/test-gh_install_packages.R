context("gh_install_packages")

install_package_mock <- function(...) {
  list(...)
}

test_that("Install a single package", {
  repo <- "AnomalyDetection"
  with_mock(
    `githubinstall:::install_package` = install_package_mock, 
    act <- gh_install_packages(repo, ask = FALSE)
  )
  expect_equal(act$repo, "twitter/AnomalyDetection")
})

test_that("Install two package", {
  repo <- c("AnomalyDetection", "toybayesopt")
  with_mock(
    `githubinstall:::install_package` = install_package_mock, 
    act <- gh_install_packages(repo, ask = FALSE)
  )
  expect_equal(length(act), 2)
})

test_that("Install: ask no", {
  repo <- c("AnomalyDetection")
  with_mock(
    `base::readline` = function(...) "No",
    expect_error(
      gh_install_packages(repo, ask = TRUE)
    )
  )
})

test_that("Install: ask yes", {
  repo <- c("AnomalyDetection")
  with_mock(
    `base::readline` = function(...) "Y",
    `githubinstall:::install_package` = install_package_mock,
    act <- gh_install_packages(repo, ask = TRUE)
  )
  expect_equal(act$repo, "twitter/AnomalyDetection")
})
