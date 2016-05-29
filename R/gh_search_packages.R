#' Search Packages from Titles by Regular Expressions
#' 
#' @param regex a character string containing a \link{regular expression} to be matched in the package titles.
#' @param ignore.case logical. If \code{FALSE}, the pattern matching is case sensitive and if \code{TRUE}, case is ignored during matching.
#' 
#' @return a data.frame of package information.
#' 
#' @examples 
#' \dontrun{
#' gh_search_packages("lasso")
#' }
#' 
#' @export
gh_search_packages <- function(regex, ignore.case = TRUE) {
  package_list <- get_package_list()
  ind <- grepl(regex, package_list$title, ignore.case = ignore.case)
  as.data.frame(package_list[ind, ], stringsAsFactors= FALSE)
}
