.onLoad <- function(libname, pkgname) {
  # Create Option Environment -----------------------------------------------
  package_option_env <- new.env(parent = emptyenv())
  package_namespace <- asNamespace(pkgname)
  assign(".options", package_option_env, envir = package_namespace)
}
