#' @export
list_github_packages <- function(username) {
  .Deprecated("gh_get_package_info")
  pkg_names <- .pkg_list[.pkg_list$author == username, "pkg_name"]
  pkg_names
}
