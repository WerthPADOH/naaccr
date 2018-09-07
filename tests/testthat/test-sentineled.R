library(testthat)
library(naaccr)


context("Reading NAACCR-formatted files")

test_that("naaccr_sentineled works", {
  gleason <- naaccr_sentineled(
    c("02", "10", "X7", "X8", "X9", ""),
    "gleasonScoreClinical"
  )
  expect_is(gleason, "sentineled")
  expect_identical(as.numeric(gleason), c(2, 10, NA, NA, NA, NA))
  expect_identical(
    levels(gleason),
    c("", "procedure not done", "not applicable", "not documented")
  )
  expect_identical(
    as.character(sentinels(gleason)),
    c("", "", "procedure not done", "not applicable", "not documented", NA)
  )
})

test_that("naaccr_sentineled warns for non-fields", {
  expect_warning(naaccr_sentineled(1, "foo"))
})
