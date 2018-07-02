library(testthat)
library(naaccr)


context("Reading NAACCR-formatted files")

test_that("naaccr_record returns a 'naaccr_record', 'data.frame' object", {
  nr <- naaccr_record("../data/fake-naaccr14inc-2-rec.txt")
  expect_true(inherits(nr, "naaccr_record"))
  expect_true(inherits(nr, "data.frame"))
})

test_that("name_recent gets the right names from item numbers", {
  expect_identical(
    naaccr:::name_recent("270"),
    "censusOccCode19702000"
  )
  expect_identical(
    naaccr:::name_recent("3221"),
    "rxDateRadiationEndedFlag"
  )
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
