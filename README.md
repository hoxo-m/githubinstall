# githubinstall: Easy to install R packages on GitHub
Koji MAKIYAMA (@hoxo_m)  



[![Travis-CI Build Status](https://travis-ci.org/hoxo-m/githubinstall.svg?branch=master)](https://travis-ci.org/hoxo-m/githubinstall)
[![CRAN Version](http://www.r-pkg.org/badges/version/githubinstall)](http://cran.rstudio.com/web/packages/githubinstall)
[![Coverage Status](https://coveralls.io/repos/github/hoxo-m/githubinstall/badge.svg?branch=master)](https://coveralls.io/github/hoxo-m/githubinstall?branch=master)

## 1. Overview

The package provides an easy way to install packages on GitHub.

## 2. Installation

You can install the package from GitHub.


```r
install.packages("devtools") # if you have not installed "devtools" package
devtools::install_github("hoxo-m/githubinstall")
```

The source code for **githubinstall** package is available on GitHub at

- https://github.com/hoxo-m/githubinstall.

## 3. Details

This package completes `username` automatically.


```r
library(githubinstall)
```


```r
githubinstall("AnomalyDetection")
# This is same as devtools::install_github("twitter/AnomalyDetection")
```

Or


```r
gh_install_packages("AnomalyDetection", build_vignettes = F)
```

```
Downloading GitHub repo hadley/multidplyr@master
Installing multidplyr
...
* DONE (multidplyr)
```

You can show the list of repositories on GitHub by `username`.


```r
hadleyverse <-  gh_get_package_info("hadley")
head(hadleyverse)
```

```
##   author package_name
## 1 hadley   assertthat
## 2 hadley    babynames
## 3 hadley    bigrquery
## 4 hadley     bookdown
## 5 hadley   clusterfly
## 6 hadley      decumar
##                                                                 title
## 1                                      User friendly assertions for R
## 2               An R package contain all baby names data from the SSA
## 3                           An interface to Google's bigquery from R.
## 4                                                               Watch
## 5 An R package for visualising high-dimensional clustering algorithms
## 6                                            An alternative to sweave
```

You can guess repository names or user names.


```r
gh_guess_repository("multdplyr", fullname = TRUE)
```

```
## [1] "hadley/multidplyr"    "jeblundell/multiplyr"
```


```r
gh_guess_username("hadly")
```

```
## [1] "hadley"
```

## 4. Related Work

- [ghit: Lightweight GitHub Package Installer](https://github.com/cloudyr/ghit)
- [Drat R Archive Template](https://github.com/eddelbuettel/drat)
- [Tools to make an R developer's life easier](https://github.com/hadley/devtools)
