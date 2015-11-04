contains_username <- function(repo) {
  grepl("/", repo)
}

find_username <- function(repo) {
  data <- read.csv("data/github_repos.csv")
  data[data$repo == repo, ]$username[1]
}

#' @export
install_github_packages <- function(repo) {
  if(!contains_username(repo)) {
    username <- find_username(repo)
    repo <- paste(username, repo, sep="/")
  }
  message(sprintf("devtools::install_github(%s)", repo))
  devtools::install_github(repo = repo)
}

