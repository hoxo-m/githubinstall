## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

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
#  install.packages("devtools") # if you have not installed "devtools" package
#  devtools::install_github("hoxo-m/githubinstall")

## ------------------------------------------------------------------------
library(githubinstall)

## ----eval=FALSE----------------------------------------------------------
#  githubinstall("AnomalyDetection")

## ----eval=FALSE----------------------------------------------------------
#  githubinstall("cats")

## ----eval=FALSE----------------------------------------------------------
#  gh_install_packages("AnomalyDetection")

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
#  gh_search_packages("lasso")

## ----echo=FALSE----------------------------------------------------------
transform(gh_search_packages("lasso"), title = paste0(" ", substr(title, 1, 35), ".."))

## ----eval=FALSE----------------------------------------------------------
#  gh_show_source("mutate", "dplyr")

## ----eval=FALSE----------------------------------------------------------
#  library(dplyr)
#  gh_show_source(mutate)

## ----eval=FALSE----------------------------------------------------------
#  gh_update_package_list()

