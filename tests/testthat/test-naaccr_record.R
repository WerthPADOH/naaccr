library(testthat)
library(naaccr)


context("Reading NAACCR-formatted files")

test_that("naaccr_record returns a 'naaccr_record', 'data.frame' object", {
  nr <- naaccr_record("../data/naaccr-record-type-i.txt")
  expect_true(inherits(nr, "naaccr_record"))
  expect_true(inherits(nr, "data.frame"))
})

test_that("name_recent updates field names", {


  get_latest_name <- function(item_number) {
    naaccr:::naaccr_items[
      naaccr_version == max(naaccr_version)
    ][
      list(item = item_number),
      r_name,
      on      = "item",
      nomatch = NA
    ]
  }


  expect_identical(
    naaccr:::name_recent("occupation_code_census"),
    get_latest_name(270)
  )
  expect_identical(
    naaccr:::name_recent("rx_date_rad_ended_flag"),
    get_latest_name(3221)
  )
})
