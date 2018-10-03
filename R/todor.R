#' TODOR
#' This package helps you to find all code rows in your code with places
#' to be filled in the future.
#'
#' @name todor
NULL

DEFAULT_PATTERNS <- "default.csv"

#' Todor addin
#'
#' Called on project that are not R packages. Checks all places in the code which require amendents
#' as specified in \code{todo_types} on R and r files. When option \code{todor_rmd} is set to TRUE
#' it searches also through Rmd files.
#' It triggers rstudio markers to appear.
#'
#' @param todo_types vector with character describing types of elements to detect.
#' If NULL default items will be used.
#' @param search_path vector with paths that contains comments you are looking for.
#' @param file character with path to file. If not NULL the search_path will be ignored.
#'
#' @export
todor <- function(todo_types = NULL, search_path = getwd(), file = NULL) {
  if (is.null(file)) {
    files <- dir(
      path = search_path,
      pattern = rex::rex(".", one_of("Rr"), end),
      recursive = TRUE,
      full.names = TRUE
    )
    if (getOption("todor_rmd", FALSE)) {
      rmdfiles <- dir(
        path = search_path,
        pattern = rex::rex(".", "Rmd", end),
        recursive = TRUE,
        full.names = TRUE
      )
      files <- c(files, rmdfiles)
    }
  }
  else {
    if (!file.exists(file))
      stop("File does not exists!")
    else
      files <- file
  }
  # Default TODO types
  patterns <- as.character(read.csv(system.file(DEFAULT_PATTERNS, package = "todor"),
                          stringsAsFactors=FALSE, header = FALSE))

  if (is.null(todo_types))
    todo_types <- patterns
  else {
    if (!all(todo_types %in% patterns))
      stop(paste("One or more 'todo_types' were not recognized.",
           "See documentation of 'todor' for more information"))
  }
  processed <- lapply(files, function(x) process_file(x, todo_types))
  names(processed) <- files
  markers <- create_markers(processed)
  build_rstudio_markers(markers)
}

#' Todor Package addin
#'
#' Called on packages. Checks all places in the code which require amendents
#' as specified in \code{todo_types}.
#' It triggers rstudio markers to appear.
#'
#' @param todo_types vector with character describing types of elements to detect.
#' If NULL default items will be used.
#'
#' @export
todor_package <- function(todo_types = NULL) {
  pkg_path    <- find_package()
  search_path <- file.path(pkg_path,
                           c("R", "tests", "inst")
                  )
  todor(todo_types = todo_types, search_path = search_path)
}

#' Todor file
#'
#' @param file_name character with file name
#' @param todo_types vector with character describing types of elements to detect.
#' If NULL default items will be used.
#'
#' @export
todor_file <- function(file_name, todo_types = NULL) {
  todor(todo_types = todo_types, file = file_name)
}

#' Todor project addin
#'
#' Calls \code{todor} function.
#'
#' @export
todor_project_addin <- function() {
  project_path = rstudioapi::getActiveProject()
  if (is.null(project_path))
    stop(paste0("You're not within R project. Change to project, ",
                "or use `todor_file` instead."))
  todor(search_path = project_path)
}

#' Todor package addin
#'
#' Calls \code{todor_package} function.
#'
#' @export
todor_package_addin <- function() {
  todor_package()
}
