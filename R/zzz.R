.onLoad <- function(libname, pkgname) {
  url <- "http://rpkg.gepuro.net/download"
  pkg_list <- jsonlite::fromJSON(url)
  repos <- strsplit(pkg_list$pkg_list$pkg_name, "/")
  authors <- sapply(repos, function(x) x[1])
  repo_names <- sapply(repos, function(x) x[2])
  data <- transform(pkg_list$pkg_list, author=authors, repo_name=repo_names, stringsAsFactors=FALSE)
  ns <- asNamespace("githubinstall")
  assign(".pkg_list", data, envir = ns)
}
