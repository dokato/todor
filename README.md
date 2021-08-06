# TODOr

<img src="images/hexstick.png" align="right" alt="" width="150" />

[![cranlogs](https://cranlogs.r-pkg.org/badges/todor)](https://CRAN.R-project.org/package=todor)
[![total](https://cranlogs.r-pkg.org/badges/grand-total/todor)](https://CRAN.R-project.org/package=todor)
[![Coverage Status](https://coveralls.io/repos/github/dokato/todor/badge.svg?branch=master)](https://coveralls.io/github/dokato/todor?branch=master)
[![R-CMD-check](https://github.com/dokato/todor/workflows/R-CMD-check/badge.svg)](https://github.com/dokato/todor/actions)

This is RStudio addin that finds all **TODO**, **FIXME**, **CHANGED** etc. comments in your **project** or **package** and shows them as a markers list.

# Installation

Stable release from CRAN:

```r
install.packages("todor")
```

The latest version:

```r
devtools::install_github("dokato/todor")
# or
remotes::install_github("dokato/todor")
```


# How to use it?

When you write an R package, sometimes it's useful to make a note in comments about a place for improvement.

```r
simple_function <- function(a, b) {
  # TODO in the future check the type of input here
  a + b
}
```

With **TODOr**, detecting such places in the forest of code lines is simple. There are several options to do so. You can click at "Addins" button in the top panel and select one of the options:

- *"Find active file TODOs"* (for the active file in RStudio editor)
- *"Find package TODOs"* (if you are creating package)
- *"Find project TODOs"* (if you are inside the RStudio project)

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

For more thorough walkthrough check this video-tutorial: https://youtu.be/f4mTYyD2C-8

# What can it detect?

By default *TODOr* looks for the following notes: _FIXME_, _TODO_, _CHANGED_, _IDEA_, _HACK_, _NOTE_, _REVIEW_, _BUG_, _QUESTION_, _COMBAK_, _TEMP_.

But you may change it by setting `todor_patterns` option, for example:

```r
options(todor_patterns = c("FIXME", "TODO", "CUSTOM"))
```

### Markdown

In markdown you probably don't want to use `#` comments. But that's okay, as `TODOr` supports HTML-like comments too.

```md
# Section

<!-- TODO Change this section. -->

* Very important element.
```

You can switch off the markdown search:

```r
options(todor_rmd = FALSE)
```

# Other options

Searching through `Rnw` files (a default option is set below).

```r
options(todor_rnw = TRUE)
```

Searching through `Rhtml` files.

```r
options(todor_rhtml = FALSE)
```

Searching through `R`, `r` files.

```r
options(todor_exclude_r = FALSE)
```

Excluding packrat directory.

```r
options(todor_exclude_packrat = TRUE)
```

Including extra file formats.

```r
options(todor_extra = c("txt", "dat"))
options(todor_extra = NULL)
```

