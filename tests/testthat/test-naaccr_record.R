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
