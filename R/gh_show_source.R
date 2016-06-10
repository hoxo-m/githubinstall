#' Find source code for functions in packages on GitHub
#' 
#' @param func a function or a character string. A function name.
#' @param repo a character string. A GitHub repository name that must not be exactry.
#' @param browser a character string giving the name of the program to be used as the HTML browser.
#' 
#' @examples
#' \dontrun{
#' gh_show_source("mutate", "dplyr")
#' 
#' library(dplyr)
#' gh_show_source(mutate)
#' }
#' 
#' @importFrom jsonlite fromJSON
#' @importFrom utils browseURL
#' 
#' @export
gh_show_source <- function(func, repo = NULL, browser = getOption("browser")) {
  if(is.character(func)) {
    func_name <- func
  } else {
    func_name <- as.character(substitute(func))
  }
  if(is.null(repo)) {
    func <- match.fun(func)
    ns <- environment(func)
    repo <- get(".packageName", ns)
  }
  repo_name <- select_repository(repo)
  
  contents_url <- sprintf("https://api.github.com/repos/%s/contents/R", repo_name)
  download_urls <- fromJSON(contents_url)$download_url

  found <- FALSE
  for(url in download_urls) {
    message("checking ", basename(url))
    names <- sapply(parse(url), function(x) x[[2]])
    if(func_name %in% names) {
      found <- TRUE
      break
    }
  }

  if(found) {
    line_num <- which(grepl(paste0(func_name, "<-"), gsub("\\s", "", readLines(url))))
    url <- sprintf("https://github.com/%s/tree/master/R/%s#L%d", repo_name, basename(url), line_num)
    browseURL(url, browser = browser)
  } else {
    stop("not found")
  }
}
