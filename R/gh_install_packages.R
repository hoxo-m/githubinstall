#' Install Packages from GitHub
#'
#' @param pkgs character vector of the names of packages.
#' @param build_args character string used to control the package build, passed to \code{R CMD build}.
#' @param build_vignettes logical specifying whether to build package vignettes, passed to \code{R CMD build}. Can be slow. Default is \code{TRUE}.
#' @param uninstall logical
#' @param verbose logical specifying whether to print details of package building and installation.
#' @param dependencies character vector specifying which dependencies to install (of "Depends", "Imports", "Suggests", etc.).
#' @param ... additional arguments to control installation of package, passed to \link{install.packages}.
#'
#' @return A named character vector of versions of R packages installed.
#'
#' @details 
#' \code{githubinstall()} is an alias of \code{gh_install_packages()}.
#'
#' @examples
#' \dontrun{
#' githubinstall("multidplyr")
#' gh_install_packages("multidplyr")
#' }
#'
#' @importFrom utils menu
#' @importFrom ghit install_github
#'
#' @rdname githubinstall
#'
#' @export
gh_install_packages <- function(pkgs, build_args = NULL, build_vignettes = TRUE,
                                uninstall = FALSE, verbose = TRUE,
                                dependencies = c("Depends", "Imports", "Suggests"), ...) {
  load_package_list_if_not_yet()
  repos <- sapply(pkgs, function(package_name) {
    if(is_full_repo_name(package_name)) {
      package_name
    } else {
      candidates <- get_candidates(package_name)
      if(is.null(candidates)) {
        error_message <- sprintf('Not found the GitHub repository named "%s".', package_name)
        stop(error_message, call. = FALSE)
      } else if(length(candidates) == 1) {
        paste0(candidates, "/", package_name)
      } else {
        choices <- format_choices(candidates, package_name)
        choice <- menu(choices = choices, title = "Select a repository or, hit 0 to cancel.")
        if(choice == 0) {
          stop("Canceled installing.", call. = FALSE)
        } else {
          paste0(candidates[choice], "/", package_name)
        }
      }
    }
  })
  install_github(repo = repos, build_args = build_args, build_vignettes = build_vignettes,
                 uninstall = uninstall, verbose = verbose, dependencies = dependencies, ... = ...)
}

is_full_repo_name <- function(package_name) {
  grepl("/", package_name)
}

get_candidates <- function(package_name) {
  ind <- .options$package_list$package_name == package_name
  if(all(!ind)) return(NULL)
  authors <- .options$package_list$author[ind]
  attr(authors, "title") <- .options$package_list$title[ind]
  authors
}

format_choices <- function(candidates, package_name) {
  nchars <- nchar(candidates)
  max_nchars <- max(nchars)
  spaces <- sapply(max_nchars - nchars, function(n) paste(rep(" ", n + 1), collapse=""))
  paste0(candidates, "/", package_name, spaces, "(", attr(candidates, "title"), ")")
}
