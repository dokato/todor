% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/patterns.R
\name{clean_comments}
\alias{clean_comments}
\title{Clean line from comment tags}
\usage{
clean_comments(line, pattern = NULL)
}
\arguments{
\item{line}{character with comment tag to remove}

\item{pattern}{character with pattern to detect (default NULL)}
}
\value{
cleaned character
}
\description{
Clean line from comment tags
}
\examples{
\dontrun{
clean_comments("#' TODO abc abc") #"TODO abc abc"
}
}
