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

test_that("naaccr_factor warns for non-fields", {
  expect_warning(naaccr_factor("a", "foo"))
})

test_that("separate_sentineled returns a data.frame of the values and flags", {
  values <- c(sprintf("%02d", 0:50), "X1", "X7", "X9", 51:99)
  result <- separate_sentineled(values, "numberOfCoresExamined")
  expect_is(result, "data.frame")
  expect_identical(dim(result), c(length(values), 2L))
  expect_named(result, c("numberOfCoresExamined", "numberOfCoresExaminedFlag"))
  expect_is(result[["numberOfCoresExamined"]], "numeric")
  expect_is(result[["numberOfCoresExaminedFlag"]], "factor")
  missing_value <- is.na(result[["numberOfCoresExamined"]])
  missing_flag  <- is.na(result[["numberOfCoresExaminedFlag"]])
  expect_true(all(missing_value | missing_flag))
})
