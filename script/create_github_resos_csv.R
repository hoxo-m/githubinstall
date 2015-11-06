library(rvest)

url <- "http://rpkg.gepuro.net/"
html <- read_html(url)

repos <- html %>%
  html_nodes(xpath = "/html/body/ul/li/a") %>%
  html_text %>%
  trimws

library(stringr)
library(lambdaR)

data <- repos %>% 
  Map_(repo: str_split(repo, "/")[[1]]) %>%
  Filter_(._ %>% length == 2) %>%
  Map_(repo: {
    df <- data.frame(as.list(repo))
    colnames(df) <- c("username", "repo")
    df
  }) %>%
  Reduce_(rbind)

write.csv(data, file.path("data", "github_repos.csv"), row.names=FALSE)
