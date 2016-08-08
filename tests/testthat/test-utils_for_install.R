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
  with_mock(
    `base::readline` = function(...) { is_passed_mock <<- TRUE; "y" },
    act <- recommend_dependencies(ask = ask, build_vignettes = build_vignettes, 
                                  dependencies = dependencies, quiet = quiet)
  )
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
