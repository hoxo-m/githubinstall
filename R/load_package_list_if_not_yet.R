load_package_list_if_not_yet <- function() {
  if(!exists("package_list", envir = .options)) {
    gh_update_package_list()
  }
}