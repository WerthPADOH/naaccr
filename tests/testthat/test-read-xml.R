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

test_that("read_naaccr_xml works with XML data kept in a character vector", {
  xml_lines <- readLines("../data/synthetic-naaccr-18-incidence.xml")
  xml_blob <- paste0(xml_lines, collapse = "\n")

  plain_from_char <- read_naaccr_xml_plain(xml_lines, as_text = TRUE)
  expect_identical(records_plain, plain_from_char)
  plain_from_blob <- read_naaccr_xml_plain(xml_blob, as_text = TRUE)
  expect_identical(records_plain, plain_from_blob)

  processed_from_char <- read_naaccr_xml(xml_lines, as_text = TRUE)
  expect_identical(records_processed, processed_from_char)
  processed_from_blob <- read_naaccr_xml(xml_blob, as_text = TRUE)
  expect_identical(records_processed, processed_from_blob)
})