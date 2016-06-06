#' @importFrom httr GET
log_installed_packages <- function(repos, suffix) {
  package <- paste(repos, collapse=",")
  suffix <- paste(suffix, collapse=",")
  GET(sprintf("http://githubinstall.appspot.com/package?package=%s&suffix=%s", package, suffix))
}
