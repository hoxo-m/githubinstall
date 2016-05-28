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
