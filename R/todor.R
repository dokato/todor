#' TODOR
#' This package helps you to find all code rows in your code with places
#' to be filled in the future.
#'
#' @name todor
NULL

#' todor
#'
#' Called on project that are not R packages. Checks all places in the code which require amendents
#' as specified in \code{todo_types}.
#' It triggers rstudio markers to appear.
#'
#' @param todo_types vector with character describing types of elements to detect.
#' If NULL default items will be used.
#' @param search_path vector with paths that contains comments you are looking for.
#'
#' @export
todor <- function(todo_types = NULL, search_path = getwd()) {
  files <- dir(
    path = search_path,
    pattern = rex::rex(".", one_of("Rr"), end),
    recursive = TRUE,
    full.names = TRUE
  )
  # TODO some task to be done in the future
  # Default TODO types
  patterns <- c("FIXME", "TODO", "CHANGED", "IDEA",
                "HACK", "NOTE", "REVIEW", "BUG",
                "QUESTION", "COMBAK", "TEMP")
  if (is.null(todo_types))
    todo_types <- patterns
  else {
    if (!all(todo_types %in% patterns))
      stop(paste("One or more 'todo_types' were not recognized.",
           "See documentation of 'todor' for more information"))
  }
  processed <- sapply(files, function(x) process_file(x, todo_types))
  markers <- create_markers(processed)
  build_rstudio_markers(markers)
}

#' todor_package
#'
#' Called on packages. Checks all places in the code which require amendents
#' as specified in \code{todo_types}.
#' It triggers rstudio markers to appear.
#'
#' @param todo_types
#'   todor that only checks directories specific to R packages
#'
#' @export
todor_package <- function(todo_types = NULL) {
  pkg_path    <- find_package()
  search_path <- file.path(pkg_path,
                           c("R", "tests", "inst")
                  )
  todor(todo_types = todo_types, search_path = search_path)
}
#' Todor addin
#'
#' Calls \code{todor} function.
#'
#' @export
todor_project_addin <- function() {
  todor(search_path = rstudioapi::getActiveProject())
}

#' Title
#'
#' Calls \code{todor_package} function.
#'
#' @export
todor_package_addin <- function() {
  todor_package()
}
