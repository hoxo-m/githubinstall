get_package_list <- function() {
  load_package_list_if_not_yet()
  .options$package_list
}