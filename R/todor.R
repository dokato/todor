#' TODOR
#' This package helps you to find all code rows in your code with places
#' to be filled in the future.
#'
#' @name todor
NULL

#' TODOR
#'
#' Called on packages. Checks all places in the code which require amendents
#' as specified in \code{todo_types}.
#' It triggers rstudio markers to appear.
#'
#' @param todo_types vector with character describing types of elements to detect.
#' If NULL default items will be used.
#'
#' @export
todor <- function(todo_types = NULL) {
  pkg_path <- find_package()
  files <- dir(
    path = file.path(pkg_path,
                     c("R", "tests", "inst")
    ),
    pattern = rex::rex(".", one_of("Rr"), end),
    recursive = TRUE,
    full.names = TRUE
  )
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

#' Todor addin
#'
#' Calls \code{todor} function.
todor_addin <- function() {
  todor()
}
