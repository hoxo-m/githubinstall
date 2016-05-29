get_package_list <- function() {
  if(!exists("package_list", envir = .options)) {
    gh_update_package_list()
  }
  .options$package_list
}