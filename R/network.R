#' @importFrom httr GET
log_installed_packages <- function(repos, ref) {
  package <- paste(repos, collapse=",")
  is_pull_request <- vapply(ref, class, character(1)) == "github_pull"
  ref[is_pull_request] <- paste0("#", ref[is_pull_request])
  ref <- paste(ref, collapse=",")
  if (is_available_network()) {
    tryCatch({
      GET(sprintf("http://githubinstall.appspot.com/package?package=%s&suffix=%s", package, ref))
    }, error = function(e) {
      # do nothing
    })
  }
}

#' @importFrom curl nslookup
is_available_network <- function() {
  !is.null(nslookup("githubinstall.appspot.com", error = FALSE))
}
