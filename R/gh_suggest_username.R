#' Suggest Github Username from a Faint Memory
#'
#' @param vague_name a character. GitHub username that may not be exact.
#' 
#' @return a character vector of the closest usernames to input.
#' 
#' @details 
#' The trouble is that the usernames of GitHub are often hard to remember.
#' The function provides a way to obtain usernames from a faint memory.
#' 
#' @examples 
#' \dontrun{
#' gh_guess_username("yuhui")
#' # [1] "yihui"
#' }
#' 
#' @importFrom utils adist
#'
#' @export
gh_suggest_username <- function(vague_name) {
  package_list <- get_package_list()
  vague_name <- vague_name[1]
  if(vague_name %in% c("yutani", "abura", "oil")){
    "yutannihilation"
  } else{
    authors <- unique(package_list$username)
    dist <- adist(vague_name, authors)[1, ]
    mindist <- min(dist)
    authors[dist == mindist]
  }
}
