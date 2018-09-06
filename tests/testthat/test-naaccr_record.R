library(testthat)
library(naaccr)


context("Reading NAACCR-formatted files")

test_that("read_naaccr returns a 'naaccr_record', 'data.frame' object", {
  nr <- read_naaccr("../data/synthetic-naaccr-18-incidence.txt", version = 18)
  expect_true(inherits(nr, "naaccr_record"))
  expect_true(inherits(nr, "data.frame"))
})

test_that("read_naaccr returns the same number of columns for any input", {
  abst <- read_naaccr("../data/synthetic-naaccr-18-abstract.txt",  version = 18)
  inc  <- read_naaccr("../data/synthetic-naaccr-18-incidence.txt", version = 18)
  expect_identical(nrow(abst), nrow(inc))
})

test_that("naaccr_record can be used to create a new naaccr_record object", {
  nr <- naaccr_record(
    sex             = c(1, 9),
    race1           = c(1, 88),
    dateOfDiagnosis = c("20140104", "20100705")
  )
  expect_is(nr, "naaccr_record")
  expect_identical(nrow(nr), 2L)
})

test_that("as.naaccr_record auto-cleans fields", {
  record <- data.frame(
    comorbidComplication3 = c("00000", "12345"),
    addrAtDxCity          = c("UNKNOWN", "Nowhere"),
    followUpContactPostal = c("888888888", "17110"),
    censusTract2000       = c("000000", "123456"),
    followingRegistry     = c("0099999999", "1111111111"),
    causeOfDeath          = c("7797", "C010"),
    cancerStatus          = c("9", "2"),
    stringsAsFactors = FALSE
  )
  processed <- as.naaccr_record(record)
  for (column in names(record)) {
    expect_true( is.na(processed[[column]][[1L]]))
    expect_false(is.na(processed[[column]][[2L]]))
  }
})

test_that("as.naaccr_record creates fields with correct classes", {
  record <- as.naaccr_record(list(ageAtDiagnosis = NA))
  expect_is(record[["ageAtDiagnosis"]], "integer")
  expect_is(record[["dateOfBirth"]], "Date")
  expect_is(record[["censusOccCode19702000"]], "factor")
  expect_is(record[["estrogenReceptorSummary"]], "logical")
  expect_is(record[["secondaryDiagnosis1"]] ,"character")
  expect_is(record[["latitude"]], "numeric")
})
