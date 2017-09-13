library(naaccr)
library(testthat)

context("partial_date")

test_that("partial_date inherits from Date", {
  d <- partial_date(2000, 1, 1)
  expect_true(inherits(d, "Date"))
})
