## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ----eval=FALSE----------------------------------------------------------
#  install_github("DeveloperName/PackageName")

## ----eval=FALSE----------------------------------------------------------
#  githubinstall("PackageName")

## ----eval=FALSE----------------------------------------------------------
#  install.packages("dplyr")

## ----eval=FALSE----------------------------------------------------------
#  library(devtools)
#  install_github("hadley/dplyr")

## ----eval=FALSE----------------------------------------------------------
#  library(devtools)
#  install_github("twitter/AnomalyDetection")

## ----eval=FALSE----------------------------------------------------------
#  library(githubinstall)
#  githubinstall("AnomalyDetection")

## ----eval=FALSE----------------------------------------------------------
#  githubinstall("AnomaryDetection")
#  githubinstall("AnomalyDetect")
#  githubinstall("anomaly-detection")

## ----eval=FALSE----------------------------------------------------------
#  install.packages("githubinstall")

## ----eval=FALSE----------------------------------------------------------
#  install.packages("devtools") # if you have not installed "devtools" package
#  devtools::install_github("hoxo-m/githubinstall")

## ------------------------------------------------------------------------
library(githubinstall)

## ----eval=FALSE----------------------------------------------------------
#  gh_install_packages("AnomalyDetection")

## ----eval=FALSE----------------------------------------------------------
#  gh_install_packages("cats")

## ----eval=FALSE----------------------------------------------------------
#  githubinstall("AnomalyDetection")

## ----eval=FALSE----------------------------------------------------------
#  gh_install_packages("awaptools", ref = "develop")

## ----eval=FALSE----------------------------------------------------------
#  gh_install_packages("densratio", ref = "v0.0.3")

## ----eval=FALSE----------------------------------------------------------
#  gh_install_packages("densratio", ref = "e8233e6")

## ----eval=FALSE----------------------------------------------------------
#  gh_install_packages("dplyr", ref = github_pull("3274"))

## ------------------------------------------------------------------------
gh_suggest("AnomalyDetection")

## ------------------------------------------------------------------------
gh_suggest("cats")

## ------------------------------------------------------------------------
gh_suggest_username("hadly")

## ------------------------------------------------------------------------
gh_suggest_username("yuhui")

## ----eval=FALSE----------------------------------------------------------
#  hadleyverse <- gh_list_packages(username = "hadley")
#  head(hadleyverse)

## ----echo=FALSE----------------------------------------------------------
hadleyverse <- gh_list_packages(username = "hadley")
transform(head(hadleyverse), title = substr(title, 1, 50))

## ----eval=FALSE----------------------------------------------------------
#  repos <- with(hadleyverse, paste(username, package_name, sep="/"))
#  githubinstall(repos) # I have not tried it

## ----eval=FALSE----------------------------------------------------------
#  lasso_packages <- gh_search_packages("lasso")
#  head(lasso_packages)

## ----echo=FALSE----------------------------------------------------------
lasso_packages <- transform(gh_search_packages("lasso"), title = paste0(" ", substr(title, 1, 36), 
                                                           ifelse(nchar(title) <= 36, "  ", "..")))
head(lasso_packages)

## ----eval=FALSE----------------------------------------------------------
#  gh_show_source("mutate", repo = "dplyr")

## ----eval=FALSE----------------------------------------------------------
#  library(dplyr)
#  gh_show_source(mutate)

## ----eval=FALSE----------------------------------------------------------
#  gh_update_package_list()

