SUFFIX <- "suffix"
SUBDIR <- "subdir"

reserve_suffix <- function(packages) {
  commit_pattern <- "@.+$"
  pull_request_pattern <- "#.+$"
  branch_pattern <- "\\[.+\\]$"
  
  packages <- lapply(packages, function(x) reserve_to_attr(x, commit_pattern, SUFFIX))
  packages <- lapply(packages, function(x) reserve_to_attr(x, pull_request_pattern, SUFFIX))
  packages <- lapply(packages, function(x) reserve_to_attr(x, branch_pattern, SUFFIX))
  attrs <- unlist(lapply(packages, function(x) attr(x, SUFFIX)))
  packages <- unlist(packages)
  attr(packages, SUFFIX) <- attrs
  
  packages
}

reserve_subdir <- function(packages) {
  suffix <- attr(packages, SUFFIX)
  packages <- extract_repositry_name_with_subdir(packages)
  attr(packages, SUFFIX) <- suffix
  packages
}

#' @importFrom stringr str_detect str_extract str_replace
reserve_to_attr <- function(x, pattern, attr_name) {
  if (str_detect(x, pattern)) {
    attr <- str_extract(x, pattern)
    x <- str_replace(x, pattern, "")
    attr(x, attr_name) <- attr
  } else if (is.null(attr(x, attr_name))) {
    attr(x, attr_name) <- ""
  }
  x
}

#' @importFrom stringr str_extract str_replace
extract_repositry_name_with_subdir <- function(packages) {
  repositry_name_pattern <- "^[^/]+/[^/]+"
  result <- lapply(packages, function(x) {
    if (is_contain_subdir(x)) {
      repositry_name <- str_extract(x, repositry_name_pattern)
      attr <- str_replace(x, repositry_name, "")
      attr(repositry_name, SUBDIR) <- attr
      repositry_name
    } else {
      attr(x, SUBDIR) <- ""
      x
    }
  })
  attr <- sapply(result, function(x) attr(x, SUBDIR))
  result <- unlist(result)
  attr(result, SUBDIR) <- attr
  result
}

#' @importFrom stringr str_count
is_contain_subdir <- function(packages) {
  str_count(packages, "/") >= 2
}
