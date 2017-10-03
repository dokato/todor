find_package <- function(path = getwd()) {
  start_wd <- getwd()
  on.exit(setwd(start_wd))
  setwd(path)

  prev_path <- ""
  while (!file.exists(file.path(prev_path, "DESCRIPTION"))) {
    if (prev_path == getwd()) {
      return(NULL)
    }
    prev_path <- getwd()
    setwd("..")
  }
  prev_path
}

process_file <- function(filepath, patterns) {
  con <- file(filepath, "r")
  n <- 1
  markers <- list()
  while (TRUE) {
    line <- readLines(con, n = 1)
    if (length(line) == 0) {
      break
    }
    pattern_check <- todor::find_pattern(line, patterns = patterns)
    if (!is.null(pattern_check))
      markers[[length(markers) + 1]] <- list(nr = n,
                                             type = pattern_check,
                                             text = stringr::str_replace(
                                               line, pattern_check, "")
      )
    n <- n + 1
  }
  close(con)
  markers
}
