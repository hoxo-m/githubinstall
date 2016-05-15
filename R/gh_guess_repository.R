#' Guess Github Repository Name from a Faint Memory
#'
#' @param vague_repo_name a character as GitHub repository name that may not be exact.
#' You can pass full repository names e.g. "hadley/bigquery".
#' @param fullname logical. Indicates to return full repoitory names e.g. "hadley/bigrquery". 
#' If you pass full repository name to \code{vague_repo_name}, force \code{TRUE}.
#' Default is \code{FALSE}.
#' 
#' @return a character vector of the closest repository names to input.
#' 
#' @examples 
#' \dontrun{
#' gh_guess_repository("bigquery")
#' # [1] "bigrquery"
#' gh_guess_repository("bigquery", fullname = TRUE)
#' # [1] "hadley/bigrquery"    "rstats-db/bigrquery"
#' gh_guess_repository("hadley/bigquery")
#' # [1] "hadley/bigrquery"
#' }
#' 
#' @importFrom utils adist
#'
#' @export
gh_guess_repository <- function(vague_repo_name, fullname = FALSE) {
  load_package_list_if_not_yet()
  vague_name <- vague_repo_name[1]
  
  if(is_full_repo_name(vague_name)) {
    target <- paste0(.options$package_list$author, "/", .options$package_list$package_name)
    result <- target
  } else if(fullname) {
    target <- .options$package_list$package_name
    result <- paste0(.options$package_list$author, "/", .options$package_list$package_name)
  } else {
    target <- unique(.options$package_list$package_name)
    result <- target
  }
  
  dist <- adist(vague_name, target)[1, ]
  mindist <- min(dist)
  result[dist == mindist]
}
