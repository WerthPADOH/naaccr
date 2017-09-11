library(testthat)
library(naaccr)


context("Reading NAACCR-formatted files")

test_that("naaccr_record returns a 'naaccr_record', 'data.frame' object", {
  nr <- naaccr_record("../data/naaccr-record-type-i.txt")
  expect_true(inherits(nr, "naaccr_record"))
  expect_true(inherits(nr, "data.frame"))
})
