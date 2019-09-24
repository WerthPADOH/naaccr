library(testthat)
library(naaccr)


context("Data item interpretation")


test_that("Date columns are properly parsed and re-encoded", {
  input <- c("19970814", "20051231", "2004    ", "        ")
  d <- naaccr_date(input)
  expected <- as.Date(
    c("19970814", "20051231", "2004    ", "        "),
    format = "%Y%m%d"
  )
  expect_equivalent(d, expected)
  expect_identical(
    naaccr_encode(d, "dateOfDiagnosis"),
    input
  )
  d[3] <- as.Date("20040101", "%Y%m%d")
  expect_identical(
    naaccr_encode(d, "dateOfDiagnosis"),
    c(input[1:2], "20040101", input[4])
  )
})
