contains_username <- function(repo) {
  grepl("/", repo)
}

find_username <- function(repo_name) {
  authors <- .pkg_list[.pkg_list$repo_name == repo_name, "author"]
  if(length(authors) == 0) {
    stop("Can't find repository: ", repo_name)
  } else if(length(authors) >= 2) {
    message("Multi Target.")
    for(author in authors) {
      message <- sprintf("You may install by devtools::install_github(%s/%s)", author, repo_name)
      message(message)
    }
    stop("Don't run install.")
  } else {
    authors
  }
}

#' @export
install_github_package <- function(repo, username = NULL, ref = "master", subdir = NULL,
                                    auth_token = devtools::github_pat(), host = "api.github.com", ...) {
  if(!is.null(username)) {
    devtools::install_github(repo, username=username, ref=ref, subdir=subdir, 
                             auth_token=auth_token, host=host, ...)
  } else {
    if(!contains_username(repo)) {
      username <- find_username(repo)
      repo <- sprintf("%s/%s", username, repo)
    }
    devtools::install_github(repo, ref=ref, subdir=subdir, auth_token=auth_token, host=host, ...)
  }
}
