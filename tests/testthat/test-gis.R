library(testthat)
library(naaccr)


context("GIS")

test_that("parse_geocoding_quality_codes works for good values", {
  expected_names <- c(
    "geocodingQualityInputType", "geocodingQualityStreetType",
    "geocodingQualityStreet", "geocodingQualityZip", "geocodingQualityCity",
    "geocodingQualityCityRefs", "geocodingQualityDirectionals",
    "geocodingQualityQualifiers", "geocodingQualityDistance",
    "geocodingQualityOutliers", "geocodingQualityCensusBlockGroups",
    "geocodingQualityCensusTracts", "geocodingQualityCensusCounties",
    "geocodingQualityRefMatchCount"
  )
  # Good values
  good <- parse_geocoding_quality_codes(c("MM1MM2DMMM1MM3", "XXXXXXXXXXXXXX"))
  expect_is(good, "data.frame")
  expect_named(good, expected_names)
  expect_identical(
    as.character(good[["geocodingQualityInputType"]]),
    c("full address", "full address")
  )
  expect_identical(
    as.character(good[["geocodingQualityStreet"]]),
    c("soundex match", "100% match")
  )
  expect_identical(
    as.character(good[["geocodingQualityCityRefs"]]),
    c("2 to 4 references unmatched", "all match")
  )
  expect_identical(
    as.character(good[["geocodingQualityDirectionals"]]),
    c("pre directionals do not match", "all match")
  )
  expect_identical(
    as.character(good[["geocodingQualityCensusBlockGroups"]]),
    c("at least one reference different", "all match")
  )
  expect_identical(
    good[["geocodingQualityRefMatchCount"]],
    c(3L, NA_integer_)
  )
  # Bad values
  expect_warning(parse_geocoding_quality_codes(c(NA, "MMMMMM", "QMMMMMMMMMMMM9")))
  suppressWarnings(
    bad <- parse_geocoding_quality_codes(c(NA, "MMMMMM", "QMMMMMMMMMMMM9"))
  )
  expect_is(bad, "data.frame")
  expect_named(bad, expected_names)
  expect_identical(
    is.na(bad[["geocodingQualityInputType"]]),
    c(TRUE, TRUE, TRUE)
  )
  expect_identical(
    is.na(bad[["geocodingQualityStreetType"]]),
    c(TRUE, TRUE, FALSE)
  )
  expect_identical(
    bad[["geocodingQualityRefMatchCount"]],
    c(NA_integer_, NA_integer_, 9L)
  )
  # Weird inputs
  weird <- parse_geocoding_quality_codes(character())
  expect_is(weird, "data.frame")
  expect_named(weird, expected_names)
  expect_identical(nrow(weird), 0L)
})
