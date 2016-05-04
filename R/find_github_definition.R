find_github_definition <- function(package, func_name, user_name=NULL) {
  .Deprecated("gh_find_func_definition")
  user_name <- .pkg_list[.pkg_list$repo_name == package, "author"]
  if(length(user_name) == 0) {
    stop("not found")
  } else {
    user_name <- user_name[1] # tekitou
  }

  repo <- sprintf("https://api.github.com/repos/%s/%s/contents/R", user_name, package)
  # download_urls <- repo %>% list.load %>% list.mapv(download_url)
  download_urls <- rlist::list.mapv(rlist::list.load(repo), download_url)
  
  found <- FALSE
  for(url in download_urls) {
    message("checking ", basename(url))
    # names <- parse(url) %>% list.mapv(.[[2]]) %>% as.character
    names <- as.character(rlist::list.mapv(parse(url), .[[2]]))
    if(func_name %in% names) {
      found <- TRUE
      break
    }
  }
  
  if(found) {
    line <- Position(function(line) stringr::str_detect(stringr::str_replace_all(line, "\\s", ""), paste0(func_name, "<-")), readLines(url))
    url <- sprintf("https://github.com/%s/%s/tree/master/R/%s#L%d", user_name, package, basename(url), line) 
    browseURL(url)
  } else {
    stop("not found")
  }
}
