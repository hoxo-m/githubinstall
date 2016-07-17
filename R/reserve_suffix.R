SUFFIX <- "suffix"
SUBDIR <- "subdir"

#' @importFrom devtools github_pull
#' @importFrom stringr str_replace str_sub
separate_reference <- function(packages, ref) {
  commit_pattern <- "@.+$"
  pull_request_pattern <- "#.+$"
  branch_pattern <- "\\[.+\\]$"

  commit <- vapply(packages, extract_reference, character(1), commit_pattern)
  pull_request <- vapply(packages, extract_reference, character(1), pull_request_pattern)
  branch <- vapply(packages, extract_reference, character(1), branch_pattern)
  
  commit <- str_sub(commit, 2)
  pull_request <- github_pull(str_sub(pull_request, 2))
  branch <- str_sub(branch, 2, -2)
  
  if (length(ref) == 1)
    ref <- rep(ref, length(packages))
  
  references <- commit
  references[is.na(references)] <- pull_request[is.na(references)]
  references[is.na(references)] <- branch[is.na(references)]
  references[is.na(references)] <- ref[is.na(references)]
  
  packages <- str_replace(packages, references, "")
  list(packages = packages, references = references)
}

#' @importFrom stringr str_detect str_extract
extract_reference <- function(x, pattern) {
  if (str_detect(x, pattern)) {
    str_extract(x, pattern)
  } else {
    NA_character_
  }
}

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

reserve_subdir <- function(packages) {
  suffix <- attr(packages, SUFFIX)
  packages <- extract_repositry_name_with_subdir(packages)
  attr(packages, SUFFIX) <- suffix
  packages
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
