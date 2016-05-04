#' Find Function Definitions on GitHub
#' 
#' @param repo_name a character as the repository name that \code{func_name} is defiened. If you don't pass a full repository name, it guesses.
#' @param func_name a character as a function name.
#' 
#' @examples
#' \dontrun{
#' gh_find_func_definition("dplyr", "mutate")
#' }
#' 
#' @importFrom jsonlite fromJSON
#' @importFrom utils browseURL
#' 
#' @export
gh_find_func_definition <- function(repo_name, func_name) {
  repo_name <- select_repository(repo_name)

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
    browseURL(url)
  } else {
    stop("not found")
  }
}