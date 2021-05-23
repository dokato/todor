#' Create markers
#'
#' @param todo.list list of files with lists of items detected in each
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
build_rstudio_markers <- function(markers){
  rstudioapi::callFun("sourceMarkers",
                      name = "todor",
                      markers = markers,
                      basePath = NULL,
                      autoSelect = "first")
}

#' Extract markers to markdown
#'
#' @description Extracts all \code{todor} markers in a given file and converts
#'   them to bullet-pointed markdown syntax. The file name is printed in bold at
#'   the top of each section.
#'
#' @param file Name of file. Used to extract TODOs in that file from the list of
#'   markers.
#' @param markers List of \code{todor} markers.
#'
#' @export
extract_markers_to_md <- function(file, markers) {
  paste0(
    "**",
    R.utils::getRelativePath(file),
    "** \n\n",
    paste0("- ", sapply(
      Filter(function(x)
        x$file == file, markers), `[[`, "message"
    ), collapse = "\n"),
    "\n\n"
  )
}
