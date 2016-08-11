#' @importFrom devtools github_pull
#' @export
devtools::github_pull

get_package_list <- function() {
  if(!exists("package_list", envir = .options)) {
    gh_update_package_list()
  }
  .options$package_list
}

stop_without_message <- function() {
  old_sem <- options("show.error.messages")$show.error.messages
  on.exit(options(show.error.messages = old_sem))
  options(show.error.messages = FALSE)
  stop()
}
