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
