#' @export
list_github_packages <- function(username) {
  pkg_names <- .pkg_list[.pkg_list$author == username, "pkg_name"]
  pkg_names
}
