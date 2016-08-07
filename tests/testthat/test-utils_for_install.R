context("Utils for Install")

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
