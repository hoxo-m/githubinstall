#' @importFrom utils packageDescription
remove_conflict_repos <- function(repos, lib, quiet, ask) {
  ignored_inds <- c()
  
  splitted <- strsplit(repos, "/")
  usernames <- sapply(splitted, function(x) x[1])
  package_names <- sapply(splitted, function(x) x[2])
  descs <- lapply(package_names, function(pkg) suppressWarnings(packageDescription(pkg, lib.loc = lib)))
  inds <- which(!is.na(descs))
  
  for (i in inds) {
    username <- usernames[i]
    package_name <- package_names[i]
    desc <- descs[[i]]
    if(exists("GithubRepo", where = desc)) {
      repo <- repos[i]
      installed_repo <- paste0(desc$GithubUsername, "/", desc$GithubRepo)
      message <- sprintf('Installing "%s", but already installed "%s".', repo, installed_repo)
    } else  {
      package_repository <- ifelse(exists("Repository", where = desc), desc$Repository, "unknown repository")
      message <- sprintf('Installing "%s" package from GitHub, but already installed from %s.', package_name, package_repository)
    }
    if (!quiet) {
      message(message)
      if (ask) {
        prompt <- "Do you want to overwrite the package (Y/n)?  "
        answer <- substr(readline(prompt), 1L, 1L)
        if (!(answer %in% c("", "y", "Y"))) {
          message("cancelled by user\n")
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

#' #' @importFrom utils packageDescription
#' is_conflict_installed_packages <- function(repo_full_names, lib) {
#'   if(missing(lib)) lib <- NULL
#'   splitted <- strsplit(repo_full_names, "/")
#'   usernames <- sapply(splitted, function(x) x[1])
#'   package_names <- sapply(splitted, function(x) x[2])
#'   descs <- lapply(package_names, function(pkg) suppressWarnings(packageDescription(pkg, lib.loc = lib)))
#'   ind <- !is.na(descs)
#'   is_conflict <- mapply(function(user, pkg, desc) {
#'     if(exists("GithubRepo", where = desc)) {
#'       if(desc$GithubUsername != user) {
#'         repo <- paste0(user, "/", pkg)
#'         installed_repo <- paste0(desc$GithubUsername, "/", desc$GithubRepo)
#'         message <- sprintf('Installing "%s", but already installed "%s"', repo, installed_repo)
#'         warning(message, call. = FALSE, immediate. = TRUE)
#'         return(TRUE)
#'       } else if(desc$GithubRef != "master") {
#'         message <- sprintf('Installing master branch of "%s", but already installed "%s" branch.', repo, desc$GithubRef)
#'         warning(message, call. = FALSE, immediate. = TRUE)
#'         return(TRUE)
#'       }
#'       return(FALSE)
#'     } else {
#'       if(exists("Repository", where = desc)) {
#'         message <- sprintf('Installing "%s" package from GitHub, but it was installed from %s.', pkg, desc$Repository)
#'       } else {
#'         message <- sprintf('Installing "%s" package from GitHub, but it was installed from unknown repository.', pkg)
#'       }
#'       warning(message, call. = FALSE, immediate. = TRUE)
#'       return(TRUE)
#'     }
#'   }, usernames[ind], package_names[ind], descs[ind])
#'   any(is_conflict)
#' }
