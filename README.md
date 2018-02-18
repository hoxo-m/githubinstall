“A Helpful Way to Install R Packages Hosted on GitHub”
======================================================

<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build
Status](https://travis-ci.org/hoxo-m/githubinstall.svg?branch=master)](https://travis-ci.org/hoxo-m/githubinstall)
[![CRAN
Version](http://www.r-pkg.org/badges/version-ago/githubinstall)](https://cran.r-project.org/package=githubinstall)
[![CRAN
Downloads](http://cranlogs.r-pkg.org/badges/githubinstall)](http://cranlogs.r-pkg.org/badges/githubinstall)
[![Coverage
Status](https://coveralls.io/repos/github/hoxo-m/githubinstall/badge.svg?branch=master)](https://coveralls.io/github/hoxo-m/githubinstall?branch=master)

Abstract
--------

There is an `install_github` function to install R packages hosted on
GitHub in the **devtools** package. But it requests developer’s name.

``` r
install_github("DeveloperName/PackageName")
```

The **githubinstall** package provides a function `githubinstall`. It
does not need developer’s name.

``` r
githubinstall("PackageName")
```

The package also provides some helpful functions for R packages hosted
on GitHub.

1 Overview
----------

Various people in the world create a growing number of R packages. A
part of the cause of it is the **devtools** package that makes it easy
to develop R packages
[\[1\]](https://www.rstudio.com/products/rpackages/devtools/). The
**devtools** package not only facilitates the process to develop R
packages but also provides another way to distribute R packages.

When developers publish R packages that created by them, they commonly
use CRAN [\[2\]](https://cran.r-project.org). You can install packages
that are available on CRAN using `install.package()`. For example, you
can install **dplyr** package as follows:

``` r
install.packages("dplyr")
```

The **devtools** package provides `install_github()` that enables
installing packages from GitHub.

``` r
library(devtools)
install_github("hadley/dplyr")
```

Therefore, developers can distribute R packages that are developing on
GitHub. Besides, there are some developers that they have no intention
to submit to CRAN. For instance, Twitter, Inc. provides
**AnomalyDetection** package on GitHub, but they won’t submit to CRAN
[\[3\]](https://blog.twitter.com/2015/introducing-practical-and-robust-anomaly-detection-in-a-time-series).
You can install such packages conveniently using **devtools**.

``` r
library(devtools)
install_github("twitter/AnomalyDetection")
```

There is a difference between `install.packages()` and
`install_github()` in their required argument. `install.packages()`
takes package names, while `install_github()` needs repository names in
addition. It means that when you want to install a package on GitHub,
you must remember its repository name correctly.

The trouble is that the usernames of GitHub are often hard to remember.
Developers consider their package names so that users can understand
their functionalities intuitively. However, they often decide username
incautiously. For instance, **ggfortify** is an excellent package on
GitHub, but who created it? What is its username? The answer is
*sinhrks* [\[4\]](https://github.com/sinhrks/ggfortify). It seems to be
difficult to remember it.

The **githubinstall** package provides a way to install packages on
GitHub by only their package names just like `install.packages()`.

``` r
library(githubinstall)
githubinstall("AnomalyDetection")
```

    Suggestion:
     - twitter/AnomalyDetection  Anomaly Detection with R
    Do you want to install the package (Y/n)?  

`githubinstall()` suggests GitHub repositories from input package names
and asks whether you install it.

Furthermore, you may succeed in installing packages from a faint memory
because our package automatically corrects its spelling by fuzzy string
search.

``` r
githubinstall("AnomaryDetection")
githubinstall("AnomalyDetect")
githubinstall("anomaly-detection")
```

2 Installation
--------------

You can install the **githubinstall** package from CRAN.

``` r
install.packages("githubinstall")
```

You can also install the package from GitHub.

``` r
install.packages("devtools") # if you have not installed "devtools" package
devtools::install_github("hoxo-m/githubinstall")
```

The source code for **githubinstall** package is available on GitHub at

-   <https://github.com/hoxo-m/githubinstall>.

3 Details
---------

The **githubinstall** package provides several useful functions.

-   `gh_install_packages()` or `githubinstall()`
-   `gh_suggest()`
-   `gh_suggest_username()`
-   `gh_list_packages()`
-   `gh_search_packages()`
-   `gh_show_source()`
-   `gh_update_package_list()`

The functions have common prefix `gh`. `githubinstall()` is an alias of
`gh_install_packages()`.

To use these functions, first, you should load the package as follows.

``` r
library(githubinstall)
```

### 3.1 Install Packages from GitHub

`gh_install_packages()` enables to install packages on GitHub by only
package names.

``` r
gh_install_packages("AnomalyDetection")
```

    Suggestion:
     - twitter/AnomalyDetection  Anomaly Detection with R
    Do you want to install the package (Y/n)?  

The function suggests GitHub repositories. If you type ‘Y’ or ‘y’ and
press ‘Enter’ (the default is ‘Y’), then the installation of the package
will begin. The suggestion is made by looking for a list of R packages
on GitHub. [Gepuro Task Views](http://rpkg.gepuro.net) provides the
list.

If it found multiple candidates, you can select one of them.

``` r
gh_install_packages("cats")
```

    Select a number or, hit 0 to cancel. 

    1: amurali2/cats      cats
    2: danielwilhelm/cats No description or website provided.
    3: hilaryparker/cats  An R package for cat-related functions #rcatladies
    4: lolibear/cats      No description or website provided.
    5: rafalszota/cats    No description or website provided.
    6: tahir275/cats      ff

    Selection: 

`githubinstall()` is an alias of `gh_install_packages()`.

``` r
githubinstall("AnomalyDetection")
```

#### 3.1.1 Specify Git References (Branch, Tag, Commit and Pull Request)

You can install packages by specifying Git references (branch, tag,
commit and pull request).

Developers are divided in policy to manage R packages on GitHub. If a
package is going to be developed in “develop” branch, you may want to
install the package from the branch.

`gh_install_packages()` has `ref` argument to specify Git references.
For instance, you can install **awaptools** from the [“develop”
branch](https://github.com/swish-climate-impact-assessment/awaptools/tree/develop)
as follows:

``` r
gh_install_packages("awaptools", ref = "develop")
```

You may sometimes encounter failing to install packages because its
repository HEAD is not valid no longer. In such case, you can specify a
tag or commit to `ref`. In most cases, developers add tags on an
unbroken commit. For instance, you can install **densratio** from the
[“v0.0.3” tag](https://github.com/hoxo-m/densratio/releases/tag/v0.0.3)
as follows:

``` r
gh_install_packages("densratio", ref = "v0.0.3")
```

Even if you cannot find such tags, you can install packages from any
commit that is valid. For instance, you can install **densratio** from
the [“e8233e6”
commit](https://github.com/hoxo-m/densratio/commit/e8233e651dbef2b34a8c9c2e4432594a13ea8de7)
as follows:

``` r
gh_install_packages("densratio", ref = "e8233e6")
```

Finally, you may find a patch for fixing bugs as a pull request. In such
case, you can specify pull requests to `ref` using `github_pull()`. For
instance, you can install **dplyr** from the [pull request
\#2058](https://github.com/hadley/dplyr/pull/3274) as follows:

``` r
gh_install_packages("dplyr", ref = github_pull("3274"))
```

### 3.2 Suggest Repositories

`gh_install_packages()` prompts you to install the suggested packages.
But you may just want to know what will be suggestions.

`gh_suggest()` returns the suggested repository names as a vector.

``` r
gh_suggest("AnomalyDetection")
#> [1] "twitter/AnomalyDetection"
```

``` r
gh_suggest("cats")
#>  [1] "Kkm5/cats"             "amurali2/cats"        
#>  [3] "briglx/cats"           "danielwilhelm/cats"   
#>  [5] "davidluizrusso/cats"   "fadiphi/cats"         
#>  [7] "germayneng/cats"       "hilaryparker/cats"    
#>  [9] "jonathanelee1993/cats" "lloydlow/cats"        
#> [11] "lolibear/cats"         "mfabla/cats"          
#> [13] "nkatiyar/cats"         "oliviergimenez/cats"  
#> [15] "piyush-kgp/cats"       "rafalszota/cats"      
#> [17] "riteekteek/cats"       "sunstat/cats"         
#> [19] "tahir275/cats"         "thackl/cats"          
#> [21] "tomis9/cats"           "verreet/cats"
```

Also, `gh_suggest_username()` is useful when you want to know usernames
from a faint memory.

``` r
gh_suggest_username("hadly")
#> [1] "hadley"
```

``` r
gh_suggest_username("yuhui")
#> [1] "yihui"
```

### 3.3 List the Packages

`gh_list_packages()` returns a list of R package repositories on GitHub
as `data.frame`.

For example, if you want to get the repositories that have been created
by *hadley*, run the following.

``` r
hadleyverse <- gh_list_packages(username = "hadley")
head(hadleyverse)
```

    #>   username package_name                                              title
    #> 1   hadley RcppDateTime                                                   
    #> 2   hadley           S3  Helpers for Programming with the S3 Object System
    #> 3   hadley   assertthat                     User friendly assertions for R
    #> 4   hadley    babynames An R package contain all baby names data from the 
    #> 5   hadley        bench                            Bechmarking tools for R
    #> 6   hadley    bigrquery          An interface to Google's bigquery from R.

By using the result, you can install all packages created by hadley.

``` r
repos <- with(hadleyverse, paste(username, package_name, sep="/"))
githubinstall(repos) # I have not tried it
```

### 3.4 Search Packages by a Keyword

`gh_search_packages()` returns a list of R package repositories on
GitHub that their titles contain a given keyword.

For example, if you want to search packages that are relevant to
*lasso*, run the following.

``` r
lasso_packages <- gh_search_packages("lasso")
head(lasso_packages)
```

    #>              username package_name                                   title
    #> 1              CY-dev    sparseSVM  Solution Paths of Sparse Linear Supp..
    #> 2     ChingChuan-Chen         milr  multiple-instance logistic regressio..
    #> 3              FrankD        fuser  Fused lasso for high-dimensional reg..
    #> 4           ManuSetty        SeqGL  SeqGL is a group lasso based algorit..
    #> 5 PNNL-Comp-Mass-Spec    glmnetGLR  The primary goal was to build a clas..
    #> 6        PingYangChen         milr  multiple-instance logistic regressio..

### 3.5 Show the Source Code of Functions on GitHub

`gh_show_source()` looks for a source code on GitHub for a given
function and tries to open the place on your Web browser.

``` r
gh_show_source("mutate", repo = "dplyr")
```

If you have loaded the package that the function belongs to, you can
input it directly.

``` r
library(dplyr)
gh_show_source(mutate)
```

This function may do not work well with Safari.

### 3.6 Update the List of R Packages

The **githubinstall** package uses [Gepuro Task
Views](http://rpkg.gepuro.net) for getting the list of R packages on
GitHub. Gepuro Task Views is crawling the GitHub and updates information
every day. The package downloads the list of R packages from Gepuro Task
Views each time it was loaded. Thus, you can always use the newest list
of packages on a new R session.

However, you may use an R session for a long time. In such case,
`gh_update_package_list()` is useful.

`gh_update_package_list()` updates the downloaded list of the R packages
explicitly.

``` r
gh_update_package_list()
```

4 Related Work
--------------

-   remotes: [Install R packages from GitHub, Bitbucket, git, svn
    repositories, URLs](https://github.com/MangoTheCat/remotes) [![CRAN
    Version](http://www.r-pkg.org/badges/version-ago/remotes)](https://cran.r-project.org/package=remotes)
-   ghit: [Lightweight GitHub Package
    Installer](https://github.com/cloudyr/ghit) [![CRAN
    Version](http://www.r-pkg.org/badges/version-ago/ghit)](https://cran.r-project.org/package=ghit)
-   pacman: [A package management tools for
    R](https://github.com/trinker/pacman) [![CRAN
    Version](http://www.r-pkg.org/badges/version-ago/pacman)](https://cran.r-project.org/package=pacman)
-   drat: [Drat R Archive
    Template](https://github.com/eddelbuettel/drat) [![CRAN
    Version](http://www.r-pkg.org/badges/version-ago/drat)](https://cran.r-project.org/package=drat)
-   devtools: [Tools to make an R developer’s life
    easier](https://github.com/hadley/devtools) [![CRAN
    Version](http://www.r-pkg.org/badges/version-ago/devtools)](https://cran.r-project.org/package=devtools)
