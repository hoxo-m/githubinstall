.onLoad <- function(libname, pkgname) {
  # Create Option Environment -----------------------------------------------
  package_option_env <- new.env(parent = emptyenv())
  package_namespace <- asNamespace(pkgname)
  assign(".options", package_option_env, envir = package_namespace)
  
  # Old Version -------------------------------------------------------------
  url <- "http://rpkg.gepuro.net/download"
  pkg_list <- jsonlite::fromJSON(url)
  repos <- strsplit(pkg_list$pkg_list$pkg_name, "/")
  authors <- sapply(repos, function(x) x[1])
  repo_names <- sapply(repos, function(x) x[2])
  data <- transform(pkg_list$pkg_list, author=authors, repo_name=repo_names, stringsAsFactors=FALSE)
  ns <- asNamespace("githubinstall")
  assign(".pkg_list", data, envir = ns)
}
