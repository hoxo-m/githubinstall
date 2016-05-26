#' @importFrom stringr str_detect
is_full_repo_name <- function(package_name) {
  str_detect(package_name, "/")
}
