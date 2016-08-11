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
#' @param lib character vector giving the library directories where to install the packages. 
#'        Recycled as needed. Defaults to the first element of \code{\link{.libPaths}()}.
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
#' @rdname gh_install_packages
#'
#' @export
gh_install_packages <- function(packages, ask = TRUE, ref = "master", 
                                build_vignettes = FALSE, dependencies = NA,
                                verbose = TRUE, quiet = !verbose, lib = NULL, ...) {
  # Adjust arguments
  if (length(lib) == 1)
    lib <- rep(lib, length(packages))
  dependencies <- recommend_dependencies(ask, build_vignettes, dependencies, quiet)
  pac_and_ref <- separate_into_package_and_reference(packages, ref)
  packages <- pac_and_ref$packages
  reference_list <- pac_and_ref$reference_list

  # Suggest repositories
  repos <- lapply(packages, select_repository)
  titles <- vapply(repos, attr, character(1), "title")
  repos <- unlist(repos)
  attr(repos, "title") <- titles
  
  # Confirm to install
  if (ask) {
    target <- paste0(format_choices(repos), collapse = "\n - ")
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
  results <- vector("list", length(repos))
  for (i in seq_along(repos)) {
    repo <- repos[i]
    ref <- reference_list[[i]]
    lib.loc <- lib[i]
    results[[i]] <- install_package(repo = repo, ref = ref, quiet = quiet, 
                                    dependencies = dependencies, 
                                    build_vignettes = build_vignettes, 
                                    lib = lib.loc, ... = ...)
  }
  names(results) <- repos
  if(length(results) == 1) {
    invisible(results[[1]])
  } else {
    invisible(results)
  }
}

#' @rdname gh_install_packages
#' @export
githubinstall <- gh_install_packages

#' @importFrom devtools install_github
install_package <- function(repo, ref, quiet, dependencies, build_vignettes, lib, ...) {
  lib_paths <- .libPaths()
  .libPaths(c(lib, lib_paths))
  result <- install_github(repo = repo, ref = ref, quiet = quiet, 
                           dependencies = dependencies, 
                           build_vignettes = build_vignettes, ... = ...)
  .libPaths(lib_paths)
  log_installed_packages(repo = repo, ref = ref)
  result
}
