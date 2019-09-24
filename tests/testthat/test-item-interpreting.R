library(testthat)
library(naaccr)


context("Data item interpretation")


test_that("Date columns are properly parsed and re-encoded", {
  input <- c("19970814", "20051231", "2004    ", "        ")
  d <- naaccr_date(input)
  expected <- as.Date(input, format = "%Y%m%d")
  expect_equivalent(d, expected)
  expect_identical(naaccr_encode(d, "dateOfDiagnosis"), input)
  d[3] <- as.Date("20040101", "%Y%m%d")
  expect_identical(
    naaccr_encode(d, "dateOfDiagnosis"),
    c(input[1:2], "20040101", input[4])
  )
})


test_that("Datetime columns are properly parsed and re-encoded", {
  input <- c("19970814100615", "20051231025624", "2004010122    ", "              ")
  d <- naaccr_datetime(input)
  expected <- as.POSIXct(
    c("19970814100615", "20051231025624", "20040101220000", "              "),
    format = "%Y%m%d%H%M%S"
  )
  expect_true(all(d == expected, na.rm = TRUE) && all(is.na(d) == is.na(expected)))
  expect_identical(naaccr_encode(d, "pathDateSpecCollect1"), input)
  d[3] <- as.POSIXct("20040101224730", format = "%Y%m%d%H%M%S")
  expect_identical(
    naaccr_encode(d, "pathDateSpecCollect1"),
    c(input[1:2], "20040101224730", input[4])
  )
})
