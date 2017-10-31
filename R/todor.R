#' TODOR
#' This package helps you to find all code rows in your code with places
#' to be filled in the future.
#'
#' @name todor
NULL

#' Create markers
#'
#' @param todo.list list of files with lists of items detected in it
#'
#' @return markers list
create_markers <- function(todo.list) {
  markers <- list()
  for (name in names(todo.list)) {
    if (length(todo.list[[name]]) == 0) next
    for (i in 1:length(todo.list[[name]])) {
      x <- todo.list[[name]][[i]]
      markers[[length(markers) + 1]] <- list(
        type = "info",
        file = name,
        line = x$nr,
        column = 1,
        message = sprintf("[ %s ] %s", x$type, x$text)
      )
    }
  }
  markers
}

#' Build Rstudio Markers
#'
#' @param markers list of markers
#'
#' @import rstudioapi
build_rstudio_markers <- function(markers){
  rstudioapi::callFun("sourceMarkers",
                      name = "todor",
                      markers = markers,
                      basePath = NULL,
                      autoSelect = "first")
}

#' TODOR
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
#'
#' @export
todor_addin <- function() {
  todor()
}
