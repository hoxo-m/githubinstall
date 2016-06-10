#' Get Information of Packages on GitHub
#' 
#' @param username a character vector as GitHub username. If you set \code{NULL} (default), it returns all packages information.
#' 
#' @return a data.frame that has author, package name and title.
#' 
#' @examples 
#' \dontrun{
#' gh_list_packages("hadley")
#' }
#' 
#' @export
gh_list_packages <- function(username = NULL) {
  package_list <- get_package_list()
  if(is.null(username)) {
    as.data.frame(package_list)
  } else {
    ind <- package_list$username %in% username
    as.data.frame(package_list[ind, ])
  }
}
