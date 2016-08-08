#' Suggest Github Repository from a Incomplete Name
#' 
#' @param repo_name a character. A part of a repository name.
#' @param keep_title logical. Indicates to keep the package titles as an attrbite. Default \code{FALSE}.
#' 
#' @return candidates for the repository name.
#' 
#' @examples 
#' gh_suggest("AnomalyDetection")
#' # [1] "twitter/AnomalyDetection"
#' gh_suggest("BnomalyDetection")
#' # [1] "twitter/AnomalyDetection"
#' gh_suggest("uwitter/BnomalyDetection")
#' # [1] "twitter/AnomalyDetection"
#' 
#' @export
gh_suggest <- function (repo_name, keep_title = FALSE) {
  repo_name <- repo_name[1]
  
  if (is_full_repo_name(repo_name)) {
    suggest_fullname(repo_name = repo_name, keep_title = keep_title)
  } else {
    suggest_no_fullname(package_name = repo_name, keep_title = keep_title)
  }
}

is_full_repo_name <- function(package_name) {
  grepl("/", package_name)
}

#' @importFrom utils adist
suggest_fullname <- function(repo_name, keep_title) {
  package_list <- get_package_list()
  all_repo_names <- paste0(package_list$username, "/", package_list$package_name)

  dist <- adist(repo_name, all_repo_names)[1, ]
  mindist <- min(dist)
  suggested_repo_names <- all_repo_names[dist == mindist]
  
  if(keep_title) 
    attr(suggested_repo_names, "title") <- package_list$title[dist == mindist]
  
  suggested_repo_names
}

#' @importFrom utils adist
suggest_no_fullname <- function(package_name, keep_title) {
  package_list <- get_package_list()
  all_package_names <- unique(package_list$package_name)
  
  dist <- adist(package_name, all_package_names)[1, ]
  mindist <- min(dist)
  suggested_package_names <- all_package_names[dist == mindist]
  
  candidates_list <- lapply(suggested_package_names, to_candidates, keep_title = keep_title)
  suggested_repo_names <- unlist(candidates_list)
  
  if(keep_title) 
    attr(suggested_repo_names, "title") <- extract_titles(candidates_list)

  suggested_repo_names
}

to_candidates <- function(package_name, keep_title) {
  package_list <- get_package_list()
  inds <- package_list$package_name == package_name
  if (all(!inds)) {
    NULL
  } else {
    authors <- package_list$username[inds]
    candidates <- paste0(authors, "/", package_name)
    if (keep_title) {
      titles <- package_list$title[inds]
      attr(candidates, "title") <- titles
    }
    candidates
  }
}

extract_titles <- function(candidates_list) {
  Reduce(function(x, y) c(attr(x, "title"), attr(y, "title")), init = c(), candidates_list)
}