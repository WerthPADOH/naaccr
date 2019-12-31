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

test_that("Can assign parts to partial dates (with invalid dates becoming NA)", {
  d <- partial_date(1998, 12, 15)
  year(d) <- 2000
  expect_identical(d, partial_date(2000, 12, 15))
  month(d) <- 2
  expect_identical(d, partial_date(2000, 2, 15))
  mday(d) <- 29
  expect_identical(d, partial_date(2000, 2, 29))
  expect_warning(year(d) <- 2001)
  expect_identical(d, partial_date(NA, NA, NA))
})

test_that("Partial date subsets and sub-assignments are valid", {
  d <- partial_date(c(2000, 2005, 2007), c(1, 4, NA), c(2, NA, NA))
  sub_mult <- d[c(1, 3)]
  expect_s3_class(sub_mult, "partial_date")
  expect_identical(year(sub_mult), year(d)[c(1, 3)])
  expect_identical(month(sub_mult), month(d)[c(1, 3)])
  expect_identical(mday(sub_mult), mday(d)[c(1, 3)])
  sub_one <- d[[2]]
  expect_s3_class(sub_one, "partial_date")
  expect_identical(year(sub_one), year(d)[[2]])
  expect_identical(month(sub_one), month(d)[[2]])
  expect_identical(mday(sub_one), mday(d)[[2]])
  d2 <- d
  d[c(3, 2)] <- partial_date(c(2010, 1980), c(5, 12), c(30, NA))
  expect_identical(d, partial_date(c(2000, 1980, 2010), c(1, 12, 5), c(2, NA, 30)))
  d2[[1]] <- partial_date(1950, 8, 13)
  expect_identical(d2, partial_date(c(1950, 2005, 2007), c(8, 4, NA), c(13, NA, NA)))
})
