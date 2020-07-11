#' TODOR
#' This package helps you to find all code rows in your code with places
#' to be filled in the future.
#'
#' @name todor
NULL

rex::register_shortcuts("todor")

#' Todor addin
#'
#' Called on project that are not R packages. Checks all places in the code
#' which require amendents as specified in \code{todo_types} on R and r files.
#' It triggers rstudio markers to appear.
#'
#' There are several options that let you control TODOr behaviour:
#'
#' \code{todor_rmd} - when set to TRUE it searches also through
#' Rmd files (default TRUE).
#'
#' \code{todor_rnw} - when set to TRUE it searches also through
#' Rnw files (default FALSE).
#'
#' \code{todor_rhtml} - when set to TRUE it searches also through
#' Rhtml files (default FALSE).
#'
#' \code{todor_exlude_packrat} when set to FALSE, all files in the
#' "packrat" directory are excluded (default TRUE).
#'
#' \code{todor_exclude_r} when TRUE, it ignores R and r files (default FALSE)
#'
#' \code{todor_patterns} must be vector. Contains all the names of patterns
#' to be detected. Default are: "FIXME", "TODO", "CHANGED", "IDEA", "HACK",
#' "NOTE", "REVIEW", "BUG", "QUESTION", "COMBAK", "TEMP".
#'
#' @param todo_types vector with character describing types of elements
#' to detect. If NULL default items will be used.
#' @param search_path vector with paths that contains comments you are
#' looking for.
#' @param file character with path to file. If not NULL the search_path
#' will be ignored.
#'
#' @export
#' @import rex
#' @import utils
todor <- function(todo_types = NULL, search_path = getwd(), file = NULL) {
  if (is.null(file)) {
    if (getOption("todor_exclude_r", FALSE)) {
      files <- c()
    } else {
      files <- dir(
        path = search_path,
        pattern = rex::rex(".", one_of("Rr"), end),
        recursive = TRUE,
        full.names = TRUE
      )
    }
    if (getOption("todor_rmd", TRUE)) {
      rmdfiles <- list_files_with_extension("Rmd", search_path)
      files <- c(files, rmdfiles)
    }
    if (getOption("todor_rnw", FALSE)) {
      rnwfiles <- list_files_with_extension("Rnw", search_path)
      files <- c(files, rnwfiles)
    }
    if (getOption("todor_rhtml", FALSE)) {
      rhtmlfiles <- list_files_with_extension("Rhtml", search_path)
      files <- c(files, rhtmlfiles)
    }
    if (getOption("todor_exclude_packrat", TRUE)) {
      files <- files[!stringr::str_detect(files, "/packrat/")]
    }
    if (getOption("todor_exclude_renv", TRUE)) {
      files <- files[!stringr::str_detect(files, "/renv/")]
    }
  }
  else {
    if (!file.exists(file))
      stop("File does not exists!")
    else
      files <- file
  }
  # Default TODO types
  patterns <- getOption("todor_patterns",
                        c("FIXME", "TODO", "CHANGED", "IDEA", "HACK", "NOTE",
                          "REVIEW", "BUG", "QUESTION", "COMBAK", "TEMP" ))

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
#' @import rstudioapi
todor_project_addin <- function() {
  project_path <- rstudioapi::getActiveProject()
  if (is.null(project_path))
    rstudioapi::showDialog("TODOr",
      paste("You're not within R project. Change to project,",
            "or use `todor_file` instead.")
    )
  else
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

#' Todor active file addin
#'
#' Calls \code{todor_file} function on active document path.
#'
#' @export
todor_file_addin <- function() {
  if (nchar(rstudioapi::getActiveDocumentContext()$path) == 0)
    rstudioapi::showDialog("TODOr","No active document detected.")
  else
    todor_file(rstudioapi::getActiveDocumentContext()$path)
}
