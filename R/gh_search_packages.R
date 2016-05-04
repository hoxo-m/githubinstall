#' Search Packages from Titles by Regular Expressions
#' 
#' @param regex a character string containing a \link{regular expression} to be matched in the package titles.
#' @param ignore.case logical. If \code{FALSE}, the pattern matching is case sensitive and if \code{TRUE}, case is ignored during matching.
#' 
#' @return a data.frame of package information.
#' 
#' @examples 
#' \dontrun{
#' gh_search_title("lasso")
#' }
#' 
#' @export
gh_search_packages <- function(regex, ignore.case = TRUE) {
  load_package_list_if_not_yet()
  ind <- grepl(regex, .options$package_list$title, ignore.case = ignore.case)
  as.data.frame(.options$package_list[ind, ], stringsAsFactors= FALSE)
}
