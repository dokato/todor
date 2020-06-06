# TODOr

<img src="images/hexstick.png" align="right" alt="" width="150" />

[![cranlogs](https://cranlogs.r-pkg.org/badges/todor)](https://CRAN.R-project.org/package=todor)
[![total](https://cranlogs.r-pkg.org/badges/grand-total/todor)](https://CRAN.R-project.org/package=todor)


This is RStudio addin that finds all **TODO**, **FIXME**, **CHANGED** etc. comments in your **project** or **package** and shows them as a markers list.

# Installation

Stable release:

```
install.packages("todor")
```

The most recent version:

```
devtools::install_github("dokato/todor")
```

# How to use it?

When you write an R package, sometimes it's useful to make a note in comments about a place for improvement.

```r
simple_function <- function(a, b) {
  # TODO in the future it should be multiplication
  a + b
}
```

With **TODOr**, detecting such places in the forest of code lines is simple. There are several options to do so. You can click at "Addins" button in the top panel and select *"Find package TODOs"* or *"Find project TODOs"* from the list of possible options:

![Addins panel](images/pic1.png)

It is also possible to call `todor` directly from RStudio console:

```r
> todor::todor()
```

or you can call:

```r
> todor::todor(c("TODO"))
```

to limit `todor` detection only to `"TODO"` tags.

**HINT:** By default `todor` works on projects, but you can call `todor_package` to search an entire package.

Regardless of the option that you have chosen, as a result you should see the Markers tab next to your console window in RStudio.

![TODO Markers](images/pic2.png)

To perform the search on a single file just call:

```r
> todor::todor_file("path_to_file.R")
```

### Markdown

In markdown you probably don't want to use `#` comments. But that's okay, as `TODOr` supports HTML-like comments too.

```md
# Section

<!-- TODO Change this section. -->

* Very important element.
```

You can lock the markdown search option by setting:

```r
options(todor_rmd = FALSE)
```

# What can it detect?

By default *TODOr* looks for the following notes:

- _FIXME_
- _TODO_
- _CHANGED_
- _IDEA_
- _HACK_
- _NOTE_
- _REVIEW_
- _BUG_
- _QUESTION_
- _COMBAK_
- _TEMP_

But you may change it by setting `todor_patterns` option, for example:

```r
options(todor_patterns = c("FIXME", "TODO", "CUSTOM"))
```
