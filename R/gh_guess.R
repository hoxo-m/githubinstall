#' @importFrom stringr str_c
#' @export
gh_guess <- function (vague_repo_name) {
  vague_repo_name <- vague_repo_name[1]
  package_list <- get_package_list()
  
  if (is_full_repo_name(vague_repo_name)) {
    target <- str_c(package_list$author, "/", package_list$package_name)
  } else {
    target <- unique(package_list$package_name)
  }
  
  dist <- adist(vague_repo_name, target)[1, ]
  mindist <- min(dist)
  result <- target[dist == mindist]
  
  if (is_full_repo_name(vague_repo_name)) {
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
    unlist(Filter(Negate(is.null), candidate_list))
  }
}
