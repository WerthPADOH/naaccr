library(data.table)
library(naaccr)
library(testthat)


context("Read XML")


records_plain <- read_naaccr_xml_plain("../data/synthetic-naaccr-18-incidence.xml")
records_processed <- read_naaccr_xml("../data/synthetic-naaccr-18-incidence.xml")
records_plain_fwf <- read_naaccr_plain("../data/synthetic-naaccr-18-incidence.txt", version = 18)
records_processed_fwf <- read_naaccr("../data/synthetic-naaccr-18-incidence.txt", version = 18)


test_that("read_naaccr_xml_plain correctly reads just character values", {
  expect_true(all(vapply(records_plain, is.character, logical(1))))
  expect_false(any(vapply(records_plain, anyNA, logical(1))))
})

test_that("Same results for plain records from XML and fixed-width files", {
  expect_true(all(names(records_plain) %in% names(records_plain_fwf)))
  expect_identical(
    records_plain,
    records_plain_fwf[, names(records_plain)]
  )
})
