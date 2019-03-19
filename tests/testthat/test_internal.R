library(todor)

test_that("test process_file function", {
  to_detect <- c("BUG")
  p <- process_file("demo.R", to_detect)
  expect_equal(length(p), 1)
  to_detect <- c("BUG", "TODO")
  p <- process_file("demo.R", to_detect)
  expect_equal(length(p), 2)
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
