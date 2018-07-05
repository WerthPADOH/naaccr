library(testthat)
library(naaccr)


context("naaccr_factor")

test_that("naaccr_factor converts the input to a factor", {
  input <- sprintf("%02d", 1:99)
  race_factor <- naaccr_factor(input, "race4")
  expect_is(race_factor, "factor")
  expect_equal(length(race_factor), length(input))
  expect_true(is.na(race_factor[99L]))
})

test_that("naaccr_factor works for country codes", {
  input <- list(
    code = c("ZZA", "ZZU", "XNI", "FRA"),
    name = c("Asia NOS", "Unknown", "North American Islands", "France")
  )
  country_factor <- naaccr_factor(input[["code"]], "addrAtDxCountry")
  expect_identical(as.character(country_factor), input[["name"]])
})
