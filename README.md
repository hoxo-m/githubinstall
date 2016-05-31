# An Easy Way to Install R Packages on GitHub
Koji MAKIYAMA (@hoxo_m)  



[![Travis-CI Build Status](https://travis-ci.org/hoxo-m/githubinstall.svg?branch=master)](https://travis-ci.org/hoxo-m/githubinstall)
[![CRAN Version](http://www.r-pkg.org/badges/version/githubinstall)](http://cran.rstudio.com/web/packages/githubinstall)
[![Coverage Status](https://coveralls.io/repos/github/hoxo-m/githubinstall/badge.svg?branch=master)](https://coveralls.io/github/hoxo-m/githubinstall?branch=master)

## 1. Overview

A growing number of R packages are created by various people in the world.
A part of the cause of it is the **devtools** package that makes it easy to develop R packages [[1]](https://www.rstudio.com/products/rpackages/devtools/).
The **devtools** package not only facilitates the process to develop R packages but also provides an another way to distribute R packages.

To distribute R packages, the CRAN [[2]](https://cran.r-project.org) is commonly used.
You can install the packages are available on CRAN as follows.


```r
install.packages("dplyr")
```

The **devtools** package provides `install_github()` that enables installing packages from GitHub.


```r
library(devtools)
install_github("hadley/dplyr")
```

Therefore, developers can distribute R packages that is developing on GitHub.
There are some developers who have no intention to submit to CRAN.
For instance, Twitter, Inc. provides **AnomalyDetection** package on GitHub but it will not be available on CRAN [[3]](https://blog.twitter.com/2015/introducing-practical-and-robust-anomaly-detection-in-a-time-series).
You can install such packages easily using **devtools**.


```r
library(devtools)
install_github("twitter/AnomalyDetection")
```

There is a difference what is passed between `install.packages()` and `install_github()`.
`install.packages()` takes the package names and `install_github()` needs the repository names.
It means that if you want to install a package on GitHub you must remember its repository name correctly.

The trouble is that the usernames of GitHub are often hard to remember.
Developers consider the package names so that users can understand the functionalities intuitively, however, they decide username incautiously.
For instance, **ggfortify** is a great package on GitHub, but who created it?
What is the username?
The answer is *sinhrks* [[4]](https://github.com/sinhrks/ggfortify).
It seems to be difficult to remember it.

The **githubinstall** package provides a way to install packages on GitHub by only the package names just like `install.packages()`.


```r
library(githubinstall)
githubinstall("AnomalyDetection")
```

```
Suggetion:
 - twitter/AnomalyDetection
Do you install the package? 

1: Yes (Install)
2: No (Cancel)
```

`githubinstall()` suggests the GitHub repositry from package names, and asks whether you want to execute the installation.

Furthermore, you may succeed in installing packages from a faint memory.


```r
githubinstall("AnomaryDetection")
githubinstall("AnomalyDetect")
githubinstall("anomaly-detection")
```

## 2. Installation

You can install the package from GitHub.


```r
install.packages("devtools") # if you have not installed "devtools" package
devtools::install_github("hoxo-m/githubinstall")
```

The source code for **githubinstall** package is available on GitHub at

- https://github.com/hoxo-m/githubinstall.

## 3. Details

The **githubinstall** package provides several useful functions.
To use these functions, first you should load the package as follows.


```r
library(githubinstall)
```

### 3.1. Install Packages from GitHub

`githubinstall()` enables to install packages on GitHub by only package names.


```r
githubinstall("AnomalyDetection")
```

```
Suggestion:
 - twitter/AnomalyDetection
Do you install the package? 

1: Yes (Install)
2: No (Cancel)

Selection: 
```

The function suggests GitHub repositories.
If you type '1' and 'enter', then installation of the package will begin.
The suggestion is made of looking for the list of R packages on GitHub.
The list is provided by [Gepuro Task Views](http://rpkg.gepuro.net).

If multiple candidates are found, you can select one of them.


```r
githubinstall("cats")
```

```
Select a repository or, hit 0 to cancel. 

1: amurali2/cats      cats
2: danielwilhelm/cats No description or website provided.
3: hilaryparker/cats  An R package for cat-related functions #rcatladies
4: lolibear/cats      No description or website provided.
5: rafalszota/cats    No description or website provided.
6: tahir275/cats      ff

Selection: 
```

All functions in **githubinstall** have common prefix `gh_`.
`githubinstall()` is an alias of `gh_install_packages()`.


```r
gh_install_packages("AnomalyDetection")
```

### 3.2. Suggest Repository

### 3.3. 

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
gh_guess_username("hadly")
```

```
## Warning: 'gh_guess_username' is deprecated.
## Use 'gh_suggest_username' instead.
## See help("Deprecated")
```

```
## [1] "hadley"
```

## 4. Related Work

- devtools: [Tools to make an R developer's life easier](https://github.com/hadley/devtools)
- ghit: [Lightweight GitHub Package Installer](https://github.com/cloudyr/ghit)
- drat: [Drat R Archive Template](https://github.com/eddelbuettel/drat)
- pacman: [A package management tools for R](https://github.com/trinker/pacman)
- remotes: [Install R packages from GitHub, Bitbucket, git, svn repositories, URLs](https://github.com/MangoTheCat/remotes)
