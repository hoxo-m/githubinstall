#' @importFrom httr GET
log_installed_packages <- function(repo, ref) {
  if (class(ref) == "github_pull")
    ref <- paste0("%23", ref)
  if (is_available_network()) {
    tryCatch({
      GET(sprintf("http://githubinstall.appspot.com/package?package=%s&suffix=%s", repo, ref))
    }, error = function(e) {
      # do nothing
    })
  }
}

#' @importFrom curl nslookup
is_available_network <- function() {
  !is.null(nslookup("githubinstall.appspot.com", error = FALSE))
}
