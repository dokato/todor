context("exported functions")

mock_markers <- list()
mock_markers[[1]] <- list(file = "aaa.R", line = 12,
                          column = 1, message = "[BUG] bug")
mock_markers[[2]] <- list(file = "bbb.R", line = 5,
                          column = 5, message = "[TODO] todo")

test_that("test extract markers", {
  res <- extract_markers_to_md("aaa.R", mock_markers)
  expect_equal(res, "**aaa.R** \n\n- [BUG] bug\n\n")
  res <- extract_markers_to_md("bbb.R", mock_markers)
  expect_match(res, "todo")
})

test_that("test markdown report", {
  res <- build_markdown_report(mock_markers)
  expect_equal(res, "**aaa.R** \n\n- [BUG] bug\n\n**bbb.R** \n\n- [TODO] todo\n\n")
})

test_that("test todor output options", {
  expect_error(todor(output = "mjdshbnxXgh"))
  res <- todor(output = "markdown")
  expect_is(res, "character")
  res <- todor(output = "list")
  expect_is(res, "list")
})


test_that("test create_markers function", {
  p <- list(file1.R = list(list(nr = 4, type = "TODO", text = "abc abc"),
                           list(nr = 6, type = "BUG", text = "www")))
  m <- create_markers(p)
  expect_match(m[[1]]$file, "file1.R")
  expect_match(m[[1]]$type, "info")
  expect_equal(m[[1]]$line, 4)
  expect_match(m[[2]]$file, "file1.R")
  expect_equal(m[[2]]$line, 6)
  expect_match(m[[2]]$type, "info")
})

test_that("test find_pattern function", {
  p <- find_pattern("# TODO ab abc absdkskad", patterns = c("FIX"))
  expect_null(p)
  p <- find_pattern("# TODO ab abc absdkskad", patterns = c("TODO"))
  expect_match(p, "TODO")
  p <- find_pattern("#TODO ab abc absdkskad", patterns = c("TODO"))
  expect_match(p, "TODO")
  p <- find_pattern("<!-- BUG ab abc absdkskad -->", patterns = c("BUG"))
  expect_match(p, "BUG")
})

test_that("test find_pattern function at the end of the line", {
  p <- find_pattern(" ab abc absdkskad # TODO", patterns = c("TODO"))
  expect_match(p, "TODO")
  p <- find_pattern(" ab abc absdkskad # TODO", patterns = c("FIX"))
  expect_null(p)
})

test_that("test clean_comments", {
  p <- clean_comments("   #'TODO abc abc")
  expect_match(p, "TODO abc abc")
  tstline <- "abc abc"
  p <- clean_comments(tstline)
  expect_match(p, tstline)
  tstline <- "   <!-- TODO abc abc -->"
  p <- clean_comments(tstline)
  expect_match(p, "TODO abc abc")
  tstline <- "abc abc ( <!-- TODO Get date --> )"
  p <- clean_comments(tstline, "TODO")
  expect_match(p, "TODO Get date")
})

