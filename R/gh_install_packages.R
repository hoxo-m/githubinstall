#' Install Packages from GitHub
#'
#' @param packages character vector of the names of the packages.
#'        You can specify \code{ref} argument (see below) using \code{package_name[@ref|#pull]}.
#'        If both are specified, the values in repo take precedence.
#' @param ask logical. Indicates ask to confirm before install.
#' @param ref character vector. Desired git reference. 
#'        Could be a commit, tag, or branch name, or a call to \code{\link{github_pull}}. 
#'        Defaults to "master".
#' @param build_vignettes logical. If \code{TRUE}, will build vignettes.
#' @param dependencies logical. Indicating to also install uninstalled packages which the packages depends on/links to/suggests. 
#'        See argument dependencies of \code{\link{install.packages}}.
#' @param verbose logical. Indicating to print details of package building and installation. Dfault is \code{TRUE}.
#' @param quiet logical. Not \code{verbose}.
#' @param ... additional arguments to control installation of package, passed to \code{\link{install_github}}.
#'
#' @return TRUE if success.
#'
#' @details 
#' \code{githubinstall()} is an alias of \code{gh_install_packages()}.
#'
#' @examples
#' \dontrun{
#' gh_install_packages("AnomalyDetection")
#' githubinstall("AnomalyDetection")
#' }
#'
#' @importFrom devtools install_github
#'
#' @rdname githubinstall
#'
#' @export
gh_install_packages <- function(packages, ask = TRUE, ref = "master", 
                                build_vignettes = FALSE, dependencies = NA,
                                verbose = TRUE, quiet = !verbose, ...) {
  # Adjust arguments
  lib <- list(...)$lib # NULL if not set
  dependencies <- select_dependencies(ask, build_vignettes, dependencies, quiet)
  pac_ref <- separate_reference(packages, ref)
  packages <- pac_ref$packages
  references <- pac_ref$references

  # Suggest repositories
  repos <- lapply(packages, select_repository)
  titles <- vapply(repos, attr, character(1), "title")
  repos <- unlist(repos)
  attr(repos, "title") <- titles
  
  # Confirm to install
  if (ask) {
    if (length(repos) == 1) {
      target <- paste0(repos, "  (", titles, ")", collapse = "\n - ")
    } else {
      target <- paste0(format_choices(repos), collapse = "\n - ")
    }
    msg <- sprintf("Suggestion:\n - %s", target)
    message(msg)
    prompt <- sprintf("Do you want to install the package%s (Y/n)?  ", ifelse(length(repos) == 1, "", "s"))
    answer <- substr(readline(prompt), 1L, 1L)
    if (!(answer %in% c("", "y", "Y"))) {
      message("cancelled by user\n")
      stop_without_message()
    }
  }
  
  # Check conflict
  repos <- remove_conflict_repos(repos, lib, quiet, ask)
  if (length(repos) == 0) {
    message("cancelled by user\n")
    stop_without_message()
  }
  
  # Install
  lib_paths <- .libPaths()
  .libPaths(c(lib, lib_paths))
  for (i in seq_along(repos)) {
    repo <- repos[i]
    ref <- references[i]
    install_github(repo = repo, ref = ref, quiet = quiet, 
                   dependencies = dependencies, build_vignettes = build_vignettes, ... = ...)
    log_installed_packages(repos = repo, ref = ref)
  }
  .libPaths(lib_paths)
  invisible(TRUE)
}

select_dependencies <- function(ask, build_vignettes, dependencies, quiet) {
  if (build_vignettes && is.na(dependencies)) {
    msg <- "We recommend to specify the 'dependencies' argument when you build vignettes."
    if (!quiet) {
      message(msg)
      if (ask) {
        answer <- readline("Do you want to use our recommended dependencies (Y/n)?")
        if (answer %in% c("", "y", "Y"))
          return(TRUE)
      } else {
        message("It will be set to our recommended dependencies.")
        return(TRUE)
      }
    }
  }
  dependencies
}

#' @importFrom utils menu
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
