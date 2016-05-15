SUFFIX <- "suffix"

reserve_suffix <- function(packages) {
  commit_pattern <- "@.+$"
  pull_request_pattern <- "#.+$"
  branch_pattern <- "\\[.+\\]$"
  
  packages <- lapply(packages, function(x) reserve_to_attr(x, commit_pattern))
  packages <- lapply(packages, function(x) reserve_to_attr(x, pull_request_pattern))
  packages <- lapply(packages, function(x) reserve_to_attr(x, branch_pattern))
  attrs <- sapply(packages, function(x) attr(x, SUFFIX))
  packages <- unlist(packages)
  attr(packages, SUFFIX) <- attrs
  
  packages
}

#' @importFrom stringr str_detect str_extract str_replace
reserve_to_attr <- function(x, pattern) {
  if (str_detect(x, pattern)) {
    attr <- str_extract(x, pattern)
    x <- str_replace(x, pattern, "")
    attr(x, SUFFIX) <- attr
  } else if (is.null(attr(x, SUFFIX))) {
    attr(x, SUFFIX) <- ""
  }
  x
}
