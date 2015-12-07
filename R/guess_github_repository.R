#' @export
guess_github_repository <- function(faint_repo) {
  dist <- adist(faint_repo, .pkg_list$repo_name)[1, ]
  mindist <- min(dist)
  unique(.pkg_list$pkg_name[dist == mindist])
}
