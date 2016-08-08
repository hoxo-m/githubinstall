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

#' The "repo" argument allows to contain "ref" as 
#' "package_name@ref", "package_name#pull" or "package_name[branch]".
#' The function detects that "repo" contains "ref" and separates into pure repo and ref.
#' If "repo" contains "ref" and "ref" argument is specified, the values in "repo" take precedence.
#' 
#' @param packages "repo" argument.
#' @param original_ref "ref argument.
#' 
#' @importFrom devtools github_pull
#' @importFrom stringr fixed str_replace str_sub
separate_into_package_and_reference <- function(packages, original_ref) {
  reference_pattern <- "@.+$"
  pull_request_pattern <- "#.+$"
  branch_pattern <- "\\[.+\\]$"
  
  reference <- vapply(packages, extract_reference, character(1), reference_pattern)
  pull_request <- vapply(packages, extract_reference, character(1), pull_request_pattern)
  branch <- vapply(packages, extract_reference, character(1), branch_pattern)
  
  # reference
  exists <- !is.na(reference)
  packages[exists] <- str_replace(packages[exists], reference[exists], "")
  references <- str_sub(reference, 2)
  # pull request
  exists <- !is.na(pull_request)
  packages[exists] <- str_replace(packages[exists], pull_request[exists], "")
  references[is.na(references)] <- pull_request[is.na(references)]
  # branch
  exists <- !is.na(branch)
  packages[exists] <- str_replace(packages[exists], fixed(branch[exists]), "")
  branch <- str_sub(branch, 2, -2)
  references[is.na(references)] <- branch[is.na(references)]
  # original_ref
  if (length(original_ref) == 1)
    original_ref <- rep(original_ref, length(packages))
  references[is.na(references)] <- original_ref[is.na(references)]
  
  reference_list <- lapply(references, function(r) if(str_sub(r, 1, 1) == "#") github_pull(str_sub(r, 2)) else r)
  list(packages = packages, reference_list = reference_list)
}

#' @importFrom stringr str_detect str_extract
extract_reference <- function(x, pattern) {
  if (str_detect(x, pattern)) {
    str_extract(x, pattern)
  } else {
    NA_character_
  }
}

#' @importFrom utils menu
select_repository <- function(package_name) {
  candidates <- gh_suggest(package_name, keep_title = TRUE)
  if (is.null(candidates)) {
    error_message <- sprintf('Not found the GitHub repository "%s".', package_name)
    stop(error_message, call. = FALSE)
  } else if(length(candidates) == 1) {
    candidates
  } else {
    choices <- format_choices(candidates)
    choice <- menu(choices = choices, title = "Select one repository or, hit 0 to cancel.")
    if(choice == 0) {
      stop("Canceled installing.", call. = FALSE)
    } else {
      candidates[choice]
    }
  }
}
