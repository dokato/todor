#' Find pattern
#'
#' Find patterns like
#' \code{
#' # TODO text
#' #TODO Test this thing.
#' #TODO: Test this thing.
#' #TODO - Test this thing.
#' <!-- TODO Test this thing. -->
#' <!-- TODO: Test this thing. -->
#' <!-- TODO - Test this thing. -->
#' }
#'
#' @param text character with text
#' @param patterns character vector
#'
#' @return character with pattern in brackets or NULL
find_pattern <- function(text, patterns = c("TODO", "FIXME")) {
  pattern_col <- paste(patterns, collapse = "|")
  pattern <- sprintf("^\\s{0,}.{0,6}(%s).+?(\\w.*?)\\s?(-->)?$", pattern_col)
  inline_pattern <- sprintf("#'?\\s?(%s)[^A-Z]*", pattern_col)
  extr <- stringr::str_extract(text, pattern)
  if (!is.na(extr))
    extr <- stringr::str_extract(extr, "[a-zA-Z]+")
  else {
    extr <- stringr::str_extract(text, inline_pattern)
    if (!is.na(extr))
      extr <- stringr::str_extract(extr, "[a-zA-Z]+")
    else
      extr <- NULL
  }
  extr
}
