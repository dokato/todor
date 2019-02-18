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
build_rstudio_markers <- function(markers){
  rstudioapi::callFun("sourceMarkers",
                      name = "todor",
                      markers = markers,
                      basePath = NULL,
                      autoSelect = "first")
}
