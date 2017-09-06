find_pattern <- function(text, patterns = c("TODO", "FIXIT")) {
  pattern <- paste(patterns, collapse="|")
  pattern <- sprintf("(%s)", pattern)
  extr <- stringr::str_extract(text, pattern)
  if (!is.na(extr)) {
    extr <- stringr::str_extract(extr, "[a-zA-Z]+")
  }
  else
    extr <- NULL
  extr
}
