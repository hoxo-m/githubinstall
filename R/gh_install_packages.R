#' Install Packages from GitHub
#'
#' @param packages character vector of the names of packages.
#' @param ask logical. Indicates ask to confirm before install.
#' @param build_args character string used to control the package build, passed to \code{R CMD build}.
#' @param build_vignettes logical specifying whether to build package vignettes, passed to \code{R CMD build}. Can be slow. Default is \code{FALSE}.
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
#' githubinstall("AnomalyDetection")
#' gh_install_packages("AnomalyDetection")
#' }
#'
#' @importFrom ghit install_github
#' @importFrom utils menu packageDescription
#'
#' @rdname githubinstall
#'
#' @export
gh_install_packages <- function(packages, ask = TRUE, build_args = NULL, 
                                build_vignettes = FALSE, verbose = TRUE,
                                dependencies = c("Depends", "Imports", "LinkingTo"), ...) {
  lib <- list(...)$lib # NULL if not set
  packages <- reserve_suffix(packages)
  packages <- reserve_subdir(packages)
  subdir <- attr(packages, "subdir")
  suffix <- attr(packages, "suffix")
  repos <- sapply(packages, select_repository)
  repos_full <- paste0(repos, subdir, suffix)
  if (ask) {
    target <- paste(repos_full, collapse = "\n - ")
    title <- sprintf("Suggestion:\n - %s\nDo you install the package%s?", target, ifelse(length(target) == 1, "", "s"))
    choice <- menu(choices = c("Yes (Install)", "No (Cancel)"), title = title)
    if(choice != 1) {
      message("Canceled the installation.")
      return(invisible(NULL))
    }
  }
  if(is_conflict_installed_packages(repos, lib)) {
    choice <- menu(choices = c("Install Forcibly (Overwirte)", "Cancel the Installation"), 
                   title = "Warning occurred. Do you install the package forcibly?")
    if(choice != 1) {
      message("Canceled the installation.")
      return(invisible(NULL))
    }
  }
  result <- install_github(repo = repos_full, build_args = build_args, build_vignettes = build_vignettes,
                 verbose = verbose, dependencies = dependencies, ... = ...)
  log_installed_packages(repos = paste0(repos, subdir), suffix = suffix)
  result
}

select_repository <- function(package_name) {
  candidates <- gh_suggest(package_name, keep_title = TRUE)
  if (is.null(candidates)) {
    error_message <- sprintf('Not found the GitHub repository "%s".', package_name)
    stop(error_message, call. = FALSE)
  } else if(length(candidates) == 1) {
    candidates
  } else {
    choices <- format_choices(candidates)
    choice <- menu(choices = choices, title = "Select one repository or, hit 0 to cancel.")
    if(choice == 0) {
      stop("Canceled installing.", call. = FALSE)
    } else {
      candidates[choice]
    }
  }
}

format_choices <- function(candidates) {
  nchars <- nchar(candidates)
  max_nchars <- max(nchars)
  spaces <- sapply(max_nchars - nchars, function(n) paste(rep(" ", n + 1), collapse=""))
  paste0(candidates, spaces, attr(candidates, "title"))
}
