# githubinstall
You can install R packages on GitHub by only package names.

## Install

```r
install.packages("devtools") # if you have not installed "devtools" package
devtools::install_github("hoxo-m/githubinstall")
```

## Usage

This package completes `username` automatically.

```r
install_github_package("multidplyr")
# This is same as devtools::install_github("hadley/multidplyr")
```

```
Downloading GitHub repo hadley/multidplyr@master
Installing multidplyr
...
* DONE (multidplyr)
```

You can show the list of repositories on GitHub by `username`.

```r
list_github_packages("hadley")
```

```
 [1] "hadley/assertthat"    "hadley/babynames"     "hadley/bigrquery"     "hadley/bookdown"     
 [5] "hadley/clusterfly"    "hadley/decumar"       "hadley/devtools"      "hadley/dplyr"        
 [9] "hadley/evaluate"      "hadley/ggplot2"       "hadley/haven"         "hadley/helpr"        
[13] "hadley/httr"          "hadley/lazyeval"      "hadley/lubridate"     "hadley/meifly"       
[17] "hadley/mturkr"        "hadley/multidplyr"    "hadley/nycflights13"  "hadley/plyr"         
[21] "hadley/profr"         "hadley/pryr"          "hadley/purrr"         "hadley/rappdirs"     
[25] "hadley/readr"         "hadley/reshape"       "hadley/roxygen3"      "hadley/rsmith"       
[29] "hadley/rvest"         "hadley/secure"        "hadley/shinySignals"  "hadley/sin
```

You can guess repository names or user names.

```r
guess_github_repository("multdplyr")
```

```
[1] "hadley/multidplyr"
```

```r
guess_github_username("hadly")
```

```
[1] "hadley"
```

Enjoy!