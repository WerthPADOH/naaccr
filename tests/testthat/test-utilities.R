library(testthat)
library(naaccr)


context("Utility functions")

test_that("naaccr_encode properly encodes blanks and NA values", {
  expect_identical(naaccr_encode("", "countyAtDx"), "   ")
  expect_identical(naaccr_encode(NA, "countyAtDx"), "   ")
  expect_identical(naaccr_encode(NA, "dateOfDiagnosis"), "        ")
  expect_identical(naaccr_encode(NA, "psaLabValue"), "     ")
  expect_identical(naaccr_encode(NA, "pathDateSpecCollect1"), "              ")
})

test_that("naaccr_encode uses original date and datetime values", {
  orig <- list(
    dateOfBirth = "201208  ",
    pathDateSpecCollect1 = "2017010115    "
  )
  r <- as.naaccr_record(orig, version = 18)
  for (column in names(orig)) {
    expected <- orig[[column]]
    result <- naaccr_encode(r[[column]], column)
    expect_identical(result, expected)
  }
})
