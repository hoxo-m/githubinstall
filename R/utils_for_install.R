#' The default "dependencies" is NA that means c("Depends", "Imports", "LinkingTo").
#' If "build_vignettes" is TRUE, the install needs "Suggests" dependency in many cases.
#' So we recommend in such case to set "dependencies" to TRUE that means c("Depends", "Imports", "LinkingTo", "Suggests").
#' 
#' @inheritParams gh_install_packages
recommend_dependencies <- function(ask, build_vignettes, dependencies, quiet) {
  if (build_vignettes && is.na(dependencies)) {
    if (quiet) {
      return(TRUE)
    } else {
      msg <- "We recommend to specify the 'dependencies' argument when 'build_vignettes' is TRUE."
      message(msg)
      if (ask) {
        answer <- readline("Do you want to use our recommended dependencies (Y/n)?")
        if (answer %in% c("", "y", "Y"))
          return(TRUE)
      } else {
        message("It will be set to our recommended dependencies.")
        return(TRUE)
      }
    }
  }
  dependencies
}
