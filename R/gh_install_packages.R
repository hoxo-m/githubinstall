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
#' @rdname githubinstall
#'
#' @export
gh_install_packages <- function(packages, ask = TRUE, ref = "master", 
                                build_vignettes = FALSE, dependencies = NA,
                                verbose = TRUE, quiet = !verbose, ...) {
  # Adjust arguments
  lib <- list(...)$lib # NULL if not set
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
  lib_paths <- .libPaths()
  .libPaths(c(lib, lib_paths))
  results <- vector("list", length(repos))
  for (i in seq_along(repos)) {
    repo <- repos[i]
    ref <- reference_list[[i]]
    results[[i]] <- install_package(repo = repo, ref = ref, quiet = quiet, 
                                    dependencies = dependencies, 
                                    build_vignettes = build_vignettes, ... = ...)
  }
  .libPaths(lib_paths)
  names(results) <- repos
  if(length(results) == 1) {
    invisible(results[[1]])
  } else {
    invisible(results)
  }
}

#' @importFrom devtools install_github
install_package <- function(repo, ref, quiet, dependencies, build_vignettes, ...) {
  result <- install_github(repo = repo, ref = ref, quiet = quiet, 
                           dependencies = dependencies, 
                           build_vignettes = build_vignettes, ... = ...)
  log_installed_packages(repos = repo, ref = ref)
  result
}

format_choices <- function(candidates) {
  nchars <- nchar(candidates)
  max_nchars <- max(nchars)
  spaces <- sapply(max_nchars - nchars, function(n) paste(rep(" ", n + 1), collapse=""))
  paste0(candidates, spaces, " ", attr(candidates, "title"))
}

#' @importFrom utils packageDescription
remove_conflict_repos <- function(repos, lib, quiet, ask) {
  ignored_inds <- c()
  
  splitted <- strsplit(repos, "/")
  usernames <- sapply(splitted, function(x) x[1])
  package_names <- sapply(splitted, function(x) x[2])
  descs <- lapply(package_names, function(pkg) suppressWarnings(packageDescription(pkg, lib.loc = lib)))
  inds <- which(!is.na(descs))
  
  for (i in inds) {
    message <- NULL
    username <- usernames[i]
    package_name <- package_names[i]
    desc <- descs[[i]]
    if(exists("GithubRepo", where = desc)) {
      repo <- repos[i]
      if (username != desc$GithubUsername) {
        installed_repo <- paste0(desc$GithubUsername, "/", desc$GithubRepo)
        message <- sprintf('Installing "%s", but already installed "%s".', repo, installed_repo)
      }
    } else  {
      package_repository <- ifelse(exists("Repository", where = desc), desc$Repository, "unknown repository")
      message <- sprintf('Installing "%s" package from GitHub, but already installed from %s.', package_name, package_repository)
    }
    if (!quiet & !is.null(message)) {
      message(message)
      if (ask) {
        prompt <- "Do you want to overwrite the package (Y/n)?  "
        answer <- substr(readline(prompt), 1L, 1L)
        if (!(answer %in% c("", "y", "Y"))) {
          ignored_inds <- c(ignored_inds, i)
        }
      } else {
        message("It will be overwriten.")
      }
    }
  }
  if (is.null(ignored_inds)) {
    repos
  } else {
    repos[-ignored_inds]
  }
}
