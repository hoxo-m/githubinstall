#' Get Information of Packages on GitHub
#' 
#' @param authors a character vector as GitHub username. If you set \code{NULL} (default), it returns all packages information.
#' 
#' @return a data.frame that has author, package name and title.
#' 
#' @examples 
#' \dontrun{
#' gh_get_package_info("hadley")
#' }
#' 
#' @export
gh_get_package_info <- function(authors = NULL) {
  package_list <- get_package_list()
  if(is.null(authors)) {
    as.data.frame(package_list)
  } else {
    ind <- package_list$author %in% authors
    as.data.frame(package_list[ind, ])
  }
}
