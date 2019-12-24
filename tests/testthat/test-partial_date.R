library(naaccr)
library(testthat)

context("partial_date")

test_that("partial_date inherits from Date", {
  d <- partial_date(2000, 1, 1)
  expect_true(inherits(d, "Date"))
})

test_that("Can extract parts from partial dates", {
  d <- as.partial_date(c("20000102", "200504  ", "2007"))
  expect_identical(year(d), c(2000L, 2005L, 2007L))
  expect_identical(month(d), c(1L, 4L, NA_integer_))
  expect_identical(mday(d), c(2L, NA_integer_, NA_integer_))
})
