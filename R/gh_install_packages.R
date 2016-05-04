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
#' @importFrom utils menu packageDescription
#' @importFrom ghit install_github
#'
#' @rdname githubinstall
#'
#' @export
gh_install_packages <- function(pkgs, build_args = NULL, build_vignettes = TRUE,
                                uninstall = FALSE, verbose = TRUE,
                                dependencies = c("Depends", "Imports", "Suggests"), ...) {
  repos <- sapply(pkgs, select_repository)
  lib <- list(...)$lib
  if(is_conflict_installed_packages(repos, lib)) {
    choice <- menu(choices = c("Cancel Installation", "Forcibly Install (Overwirte)"), title = "Warning occurred. Do you cancel the installation?")
    if(choice <= 1) {
      stop("Canceled installing.", call. = FALSE)
    }
  }
  install_github(repo = repos, build_args = build_args, build_vignettes = build_vignettes,
                 uninstall = uninstall, verbose = verbose, dependencies = dependencies, ... = ...)
}

is_full_repo_name <- function(package_name) {
  grepl("/", package_name)
}

get_candidates <- function(package_name) {
  load_package_list_if_not_yet()
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

select_repository <- function(package_name) {
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
}

is_conflict_installed_packages <- function(repo_full_names, lib) {
  if(missing(lib)) lib <- NULL
  splitted <- strsplit(repo_full_names, "/")
  usernames <- sapply(splitted, function(x) x[1])
  package_names <- sapply(splitted, function(x) x[2])
  descs <- lapply(package_names, function(pkg) suppressWarnings(packageDescription(pkg, lib.loc = lib)))
  ind <- !is.na(descs)
  is_conflict <- mapply(function(user, pkg, desc) {
    if(exists("GithubRepo", where = desc)) {
      if(desc$GithubUsername != user) {
        repo <- paste0(user, "/", pkg)
        installed_repo <- paste0(desc$GithubUsername, "/", desc$GithubRepo)
        message <- sprintf('Installing "%s", but already installed "%s"', repo, installed_repo)
        warning(message, call. = FALSE, immediate. = TRUE)
        return(TRUE)
      } else if(desc$GithubRef != "master") {
        message <- sprintf('Installing master branch of "%s", but already installed "%s" branch.', repo, desc$GithubRef)
        warning(message, call. = FALSE, immediate. = TRUE)
        return(TRUE)
      }
      return(FALSE)
    } else {
      if(exists("Repository", where = desc)) {
        message <- sprintf('Installing "%s" package from GitHub, but it was installed from %s.', pkg, desc$Repository)
      } else {
        message <- sprintf('Installing "%s" package from GitHub, but it was installed from unknown repository.', pkg)
      }
      warning(message, call. = FALSE, immediate. = TRUE)
      return(TRUE)
    }
  }, usernames[ind], package_names[ind], descs[ind])
  any(is_conflict)
}
