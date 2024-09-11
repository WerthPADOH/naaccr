library(testthat)
library(naaccr)


context("Data item interpretation")


test_that("Date columns are properly parsed and re-encoded", {
  input <- c("19970814", "20051231", "2004    ", "        ")
  d <- naaccr_date(input)
  expected <- as.Date(input, format = "%Y%m%d")
  expect_equivalent(d, expected)
  expect_identical(
    naaccr_encode(d, "dateOfDiagnosis", version = 21),
    c("19970814", "20051231", "2004", "")
  )
  d[3] <- as.Date("20040101", "%Y%m%d")
  expect_identical(
    naaccr_encode(d, "dateOfDiagnosis", version = 21),
    c("19970814", "20051231", "20040101", "")
  )
})


test_that("Datetime columns are properly parsed and re-encoded", {
  input <- data.frame(
    dtime = as.POSIXct(
      c(
        "1997-08-14 10:06:15+0000", "2005-12-31 02:56:24-0000",
        "2004-01-01 22:00:00+0000", NA, NA
      ),
      format = "%Y-%m-%d %H:%M:%S%z",
      tz = "UTC"
    ),
    entered_24 = c(
      "19970814100615", "20051231025624",
      "2004010122    ", "", NA
    ),
    entered_25 = c(
      "1997-08-14T10:06:15+00:00", "2005-12-30T21:56:24-05:00",
      "2004-01-01T22", "", NA
    ),
    full_24 = c(
      "19970814100615", "20051231025624",
      "20040101220000", "", ""
    ),
    full_25 = c(
      "1997-08-14T10:06:15+00:00", "2005-12-31T02:56:24+00:00",
      "2004-01-01T22:00:00+00:00", "", ""
    ),
    stringsAsFactors = FALSE
  )
  d <- naaccr_datetime(c(input[["entered_24"]], input[["entered_25"]]), tz = "UTC")
  expected <- c(input[["dtime"]], input[["dtime"]])
  attr(expected, "original") <- c(input[["entered_24"]], input[["entered_25"]])
  expect_equivalent(d, expected)
  d24 <- naaccr_datetime(input[["entered_24"]], tz = "UTC")
  encoded_24 <- naaccr_encode(d24, "pathDateSpecCollect1", version = 24)
  expect_equivalent(encoded_24, input[["full_24"]])
  d25 <- naaccr_datetime(input[["entered_25"]], tz = "UTC")
  encoded_25 <- naaccr_encode(d25, "pathDateSpecCollect1", version = 25)
  expect_equivalent(encoded_25, input[["full_25"]])
  replaced <- d
  replaced[3] <- as.POSIXct("2004-01-01 22:47:30", tz = "UTC")
  replaced_encoded_24 <- naaccr_encode(replaced, "pathDateSpecCollect1", version = 24)
  replaced_expected_24 <- rep(input[["full_24"]], 2)
  replaced_expected_24[3] <- "20040101224730"
  expect_equivalent(replaced_encoded_24, replaced_expected_24)
  replaced_encoded_25 <- naaccr_encode(replaced, "pathDateSpecCollect1", version = 25)
  replaced_expected_25 <- rep(input[["full_25"]], 2)
  replaced_expected_25[3] <- "2004-01-01T22:47:30+00:00"
  expect_equivalent(replaced_encoded_25, replaced_expected_25)
})
