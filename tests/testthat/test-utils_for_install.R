context("Utils for Install")

# recommend_dependencies --------------------------------------------------

test_that("recommend_dependencies: default", {
  ask <- FALSE
  build_vignettes <- FALSE
  dependencies <- NA
  quiet <- TRUE
  
  act <- recommend_dependencies(ask = ask, build_vignettes = build_vignettes, 
                                dependencies = dependencies, quiet = quiet)
  
  expect_equal(act, dependencies)
})

test_that("recommend_dependencies: build_vignettes = TRUE", {
  ask <- FALSE
  build_vignettes <- TRUE
  dependencies <- NA
  quiet <- TRUE
  
  act <- recommend_dependencies(ask = ask, build_vignettes = build_vignettes, 
                                dependencies = dependencies, quiet = quiet)
  
  expect_equal(act, TRUE)
})

test_that("recommend_dependencies: quiet = FALSE", {
  ask <- FALSE
  build_vignettes <- TRUE
  dependencies <- NA
  quiet <- FALSE
  
  expect_message(
    act <- recommend_dependencies(ask = ask, build_vignettes = build_vignettes, 
                                  dependencies = dependencies, quiet = quiet)
  )
  expect_equal(act, TRUE)
})

test_that("recommend_dependencies: ask = TRUE", {
  ask <- TRUE
  build_vignettes <- TRUE
  dependencies <- NA
  quiet <- FALSE
  
  is_passed_mock <- FALSE
  mockery::stub(recommend_dependencies, "readline", function(...) { is_passed_mock <<- TRUE; "y" })
  act <- recommend_dependencies(ask = ask, build_vignettes = build_vignettes, 
                                dependencies = dependencies, quiet = quiet)
  
  expect_true(is_passed_mock)
  expect_equal(act, TRUE)
})

# separate_into_package_and_reference -------------------------------------

test_that("separate_into_package_and_reference: default", {
  packages <- "package_name"
  original_ref <- "master"

  act <- separate_into_package_and_reference(packages = packages, original_ref = original_ref)
  
  expect_equal(act, list(packages = packages, reference_list = list(original_ref)))
})

test_that("separate_into_package_and_reference: ref", {
  packages <- "package_name@commit_id"
  original_ref <- "master"

  act <- separate_into_package_and_reference(packages = packages, original_ref = original_ref)

  expect_equal(act, list(packages = "package_name", reference_list = list("commit_id")))
})

test_that("separate_into_package_and_reference: pull", {
  packages <- "package_name#pull"
  original_ref <- "master"
  
  act <- separate_into_package_and_reference(packages = packages, original_ref = original_ref)

  expect_equal(act, list(packages = "package_name", reference_list = list(devtools::github_pull("pull"))))
})

test_that("separate_into_package_and_reference: branch", {
  packages <- "package_name[branch]"
  original_ref <- "master"
  
  act <- separate_into_package_and_reference(packages = packages, original_ref = original_ref)

  expect_equal(act, list(packages = "package_name", reference_list = list("branch")))
})

# extract_reference -------------------------------------------------------

test_that("extract_reference: NA", {
  x <- "package_name"
  pattern <- "@.+$"
  
  act <- extract_reference(x = x, pattern = pattern)
  
  expect_equal(act, NA_character_)
})

test_that("extract_reference: ref", {
  x <- "package_name@commit_id"
  pattern <- "@.+$"
  
  act <- extract_reference(x = x, pattern = pattern)
  
  expect_equal(act, "@commit_id")
})

# select_repository -------------------------------------------------------

test_that("select_repository: single candidate", {
  package_name <- "AnomalyDetection"
  
  act <- select_repository(package_name = package_name)

  expect_equal(as.character(act), "twitter/AnomalyDetection")
  expect_false(is.null(attr(act, "title")))
})

test_that("select_repository: multi candidates", {
  package_name <- "cats"
  
  mockery::stub(select_repository, "menu", 1)
  act <- select_repository(package_name = package_name)
  
  expect_equal(strsplit(act, "/")[[1]][2], "cats")
  expect_false(is.null(attr(act, "title")))
})

test_that("select_repository: cancel", {
  package_name <- "cats"
  
  mockery::stub(select_repository, "menu", 0)
  expect_error(
    select_repository(package_name = package_name)
  )
})

# remove_conflict_repos ---------------------------------------------------

test_that("remove_conflict_repos: quiet == TRUE", {
  repos <- LETTERS
  lib = NULL
  quiet = TRUE
  ask = TRUE
  
  act <- remove_conflict_repos(repos = repos, lib = lib, quiet = quiet, ask = ask)
  
  expect_equal(act, repos)
})

test_that("remove_conflict_repos: no installed", {
  repos <- paste0(letters, LETTERS, sep="/")
  lib = NULL
  quiet = FALSE
  ask = TRUE
  
  mockery::stub(remove_conflict_repos, "packageDescription", NA)
  act <- remove_conflict_repos(repos = repos, lib = lib, quiet = quiet, ask = ask)
  
  expect_equal(act, repos)
})

test_that("remove_conflict_repos: not conflict", {
  repos <- "johndoe/test"
  lib = NULL
  quiet = FALSE
  ask = TRUE

  mockery::stub(remove_conflict_repos, "packageDescription", 
                function(pkg, ...) list(Package = pkg, GithubRepo = pkg, GithubUsername = "johndoe"))
  mockery::stub(remove_conflict_repos, "readline", stop)
  act <- remove_conflict_repos(repos = repos, lib = lib, quiet = quiet, ask = ask)
  
  expect_equal(act, repos)
})

test_that("remove_conflict_repos: conflict GitHub, ask yes", {
  repos <- "johndoe/test"
  lib = NULL
  quiet = FALSE
  ask = TRUE
  
  mockery::stub(remove_conflict_repos, "packageDescription", 
                function(pkg, ...) list(Package = pkg, GithubRepo = pkg, GithubUsername = "ANOther"))
  mockery::stub(remove_conflict_repos, "readline", "y")
  act <- remove_conflict_repos(repos = repos, lib = lib, quiet = quiet, ask = ask)
  
  expect_equal(act, repos)
})

test_that("remove_conflict_repos: conflict GitHub, ask no", {
  repos <- "johndoe/test"
  lib = NULL
  quiet = FALSE
  ask = TRUE
  
  mockery::stub(remove_conflict_repos, "packageDescription", 
                function(pkg, ...) list(Package = pkg, GithubRepo = pkg, GithubUsername = "ANOther"))
  mockery::stub(remove_conflict_repos, "readline", "n")
  act <- remove_conflict_repos(repos = repos, lib = lib, quiet = quiet, ask = ask)
  
  expect_equal(length(act), 0)
})

test_that("remove_conflict_repos: conflict CRAN, ask yes", {
  repos <- "johndoe/test"
  lib = NULL
  quiet = FALSE
  ask = TRUE
  
  mockery::stub(remove_conflict_repos, "packageDescription", 
                function(pkg, ...) list(Package = pkg, Repository = "CRAN"))
  mockery::stub(remove_conflict_repos, "readline", "y")
  act <- remove_conflict_repos(repos = repos, lib = lib, quiet = quiet, ask = ask)
  
  expect_equal(act, repos)
})

test_that("remove_conflict_repos: conflict CRAN, ask no", {
  repos <- "johndoe/test"
  lib = NULL
  quiet = FALSE
  ask = TRUE
  
  mockery::stub(remove_conflict_repos, "packageDescription", 
                function(pkg, ...) list(Package = pkg, Repository = "CRAN"))
  mockery::stub(remove_conflict_repos, "readline", "n")
  act <- remove_conflict_repos(repos = repos, lib = lib, quiet = quiet, ask = ask)
  
  expect_equal(length(act), 0)
})

test_that("remove_conflict_repos: conflict, ask == FALSE", {
  repos <- "johndoe/test"
  lib = NULL
  quiet = FALSE
  ask = FALSE
  
  mockery::stub(remove_conflict_repos, "packageDescription", 
                function(pkg, ...) list(Package = pkg, Repository = "CRAN"))
  mockery::stub(remove_conflict_repos, "readline", stop)
  expect_message(
    remove_conflict_repos(repos = repos, lib = lib, quiet = quiet, ask = ask)
  )
})
