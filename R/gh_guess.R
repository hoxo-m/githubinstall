#' Guess Github Repository Name from a Incomplete Name
#' 
#' @param repo_name a character. A part of a repository name.
#' @param keep_title logical. Indicates to keep the package titles as an attrbite. Default \code{FALSE}.
#' 
#' @return candidates for the repository name.
#' 
#' @examples 
#' gh_guess("AnomalyDetection")
#' # [1] "twitter/AnomalyDetection"
#' gh_guess("BnomalyDetection")
#' # [1] "twitter/AnomalyDetection"
#' gh_guess("Uwitter/BnomalyDetection")
#' # [1] "twitter/AnomalyDetection"
#' 
#' @importFrom stringr str_c
#' @importFrom utils adist
#' 
#' @export
gh_guess <- function (repo_name, keep_title = FALSE) {
  repo_name <- repo_name[1]
  package_list <- get_package_list()
  
  if (is_full_repo_name(repo_name)) {
    target <- str_c(package_list$author, "/", package_list$package_name)
    if(keep_title) titles <- package_list$title
  } else {
    target <- unique(package_list$package_name)
  }
  
  dist <- adist(repo_name, target)[1, ]
  mindist <- min(dist)
  result <- target[dist == mindist]
  
  if (is_full_repo_name(repo_name)) {
    if(keep_title) attr(result, "title") <- titles[dist == mindist]
    result
  } else {
    candidate_list <- lapply(result, function(package_name) {
      authors <- get_candidates(package_name)
      if (is.null(authors)) {
        NULL
      } else {
        candidates <- str_c(authors, "/", package_name)
        attr(candidates, "title") <- attr(authors, "title")
        candidates
      }
    })
    result <- unlist(candidate_list)
    if(keep_title) {
      titles <- Reduce(function(x, y) c(attr(x, "title"), attr(y, "title")), init = c(), candidate_list)
      attr(result, "title") <- titles
    }
    result
  }
}
