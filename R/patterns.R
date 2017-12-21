#' Find pattern
#'
#' @param text character with text
#' @param patterns character vector
#'
#' @return character with pattern in brackets or NULL
find_pattern <- function(text, patterns = c("TODO", "FIXIT")) {
  pattern <- paste(patterns, collapse = "|")
  pattern <- sprintf("#'?\\s?(%s)[^A-Z]", pattern)
  extr <- stringr::str_extract(text, pattern)
  if (!is.na(extr)) {
    extr <- stringr::str_extract(extr, "[a-zA-Z]+")
  }
  else
    extr <- NULL
  extr
}

