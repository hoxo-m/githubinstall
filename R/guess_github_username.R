#' @export
guess_github_username <- function(faint_username) {
  .Deprecated("gh_guess_username")
  dist <- adist(faint_username, .pkg_list$author)[1, ]
  mindist <- min(dist)
  unique(.pkg_list$author[dist == mindist])
}
