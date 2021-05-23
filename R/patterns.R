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
  inline_pattern <- sprintf("(#'?\\s?(%s)[^A-Z]*)|(<!--\\s?(%s)[^A-Z]*)",
                            pattern_col, pattern_col)
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

#' Clean line from comment tags
#'
#' @param line character with comment tag to remove
#' @param pattern character with pattern to detect (default NULL)
#'
#' @return cleaned character
#'
#' @examples
#' \dontrun{
#' clean_comments("#' TODO abc abc") #"TODO abc abc"
#' }
clean_comments <- function(line, pattern = NULL) {
  if (!is.null(pattern)) {
    line <- stringr::str_extract(line, sprintf("(%s).*", pattern)) # find comment starting from pattern
    line <- stringr::str_replace(line, "-->.*", "") # in case of HTML pattern remove ending
  }
  line <- stringr::str_replace(line, "^ *#'?", "")
  line <- stringr::str_replace(line, "^ *<!--", "")
  line <- stringr::str_replace(line, "--> *$", "")
  trim <- function (x) gsub("^\\s+|\\s+$", "", x)
  trim(line)
}
