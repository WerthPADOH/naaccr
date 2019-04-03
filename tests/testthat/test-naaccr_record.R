library(data.table)
library(testthat)
library(naaccr)


context("naaccr_record")

test_that("read_naaccr returns a 'naaccr_record', 'data.frame' object", {
  nr <- read_naaccr("../data/synthetic-naaccr-18-incidence.txt", version = 18)
  expect_true(inherits(nr, "naaccr_record"))
  expect_true(inherits(nr, "data.frame"))
})

test_that("read_naaccr returns all columns by default", {
  abst <- read_naaccr("../data/synthetic-naaccr-18-abstract.txt",  version = 18)
  inc  <- read_naaccr("../data/synthetic-naaccr-18-incidence.txt", version = 18)
  expect_identical(ncol(abst), ncol(inc))
  expect_identical(
    ncol(abst),
    naaccr_format_18[, .N + sum(startsWith(type, "sentineled"))]
  )
})

test_that("read_naaccr reads the data", {
  nr <- read_naaccr("../data/synthetic-naaccr-18-abstract.txt", version = 18)
  record_lines <- readLines("../data/synthetic-naaccr-18-abstract.txt")
  age_expected <- as.integer(substr(record_lines, 223, 225))
  expect_identical(nr[["ageAtDiagnosis"]], age_expected)
})

test_that("read_naaccr only creates the columns from the format", {
  nr <- read_naaccr("../data/synthetic-naaccr-18-abstract.txt", version = 18)
  expected_names <- naaccr_format_18[
    ,
    c(name, paste0(name[startsWith(type, "sentineled")], "Flag"))
  ]
  expect_named(nr, expected_names, ignore.order = TRUE)
})

test_that("read_naaccr can handle different versions", {
  nr16 <- read_naaccr("../data/synthetic-naaccr-16-abstract.txt", version = 16)
  expect_identical(
    nr16[["ageAtDiagnosis"]],
    c(60L, 72L, 70L, 60L, 83L, 56L, 73L, 60L, 42L, 61L)
  )
  expect_identical(
    nr16[["addrAtDxCity"]][1:2],
    c("STRASBURG", "BRIDGEVILLE")
  )
})

test_that("read_naaccr only keeps requested columns and their flags", {
  kept <- c("nameMiddle", "rxDateHormone", "diagnosticConfirmation")
  nr <- read_naaccr(
    input       = "../data/synthetic-naaccr-18-abstract.txt",
    version     = 18,
    keep_fields = kept
  )
  expect_named(nr, kept)

  kept_with_sentinel <- c(kept, "tumorDeposits", "lnSize")
  nr <- read_naaccr(
    input       = "../data/synthetic-naaccr-18-abstract.txt",
    version     = 18,
    keep_fields = kept_with_sentinel
  )
  expect_named(
    nr,
    c(kept, "tumorDeposits", "tumorDepositsFlag", "lnSize", "lnSizeFlag")
  )
})

test_that("read_naaccr fills in fields beyond end of lines", {
  records <- readLines("../data/synthetic-naaccr-18-incidence.txt")
  subformat <- naaccr_format_18[1:3, ]
  shorn <- substr(records, 1, subformat[["end_col"]][2])
  result <- read_naaccr(shorn, format = subformat)
  expect_true(all(is.na(result[[3]])))
})

test_that("naaccr_record can be used to create a new naaccr_record object", {
  nr <- naaccr_record(
    sex             = c(1, 9),
    race1           = c(1, 88),
    dateOfDiagnosis = c("20140104", "20100705")
  )
  expect_is(nr, "naaccr_record")
  expect_identical(nrow(nr), 2L)
})

test_that("as.naaccr_record auto-cleans fields", {
  record <- data.frame(
    comorbidComplication3 = c("00000", "12345"),
    addrAtDxCity          = c("UNKNOWN", "Nowhere"),
    followUpContactPostal = c("888888888", "17110"),
    censusTract2000       = c("000000", "123456"),
    followingRegistry     = c("0099999999", "1111111111"),
    causeOfDeath          = c("7797", "C010"),
    cancerStatus          = c("9", "2"),
    stringsAsFactors = FALSE
  )
  processed <- as.naaccr_record(record)
  for (column in names(record)) {
    test_label <- paste0("(", column, " is NA)")
    expect_true(
      is.na(processed[[column]][[1L]]),
      label = paste0(column, "[1] is NA")
    )
    expect_false(
      is.na(processed[[column]][[2L]]),
      label = paste0(column, "[2] is not NA")
    )
  }
})

test_that("as.naaccr_record creates fields with correct classes", {
  record <- as.naaccr_record(list(
    ageAtDiagnosis          = NA,
    dateOfBirth             = NA,
    censusOccCode19702000   = NA,
    estrogenReceptorSummary = NA,
    secondaryDiagnosis1     = NA,
    latitude                = NA
  ))
  expect_is(record[["ageAtDiagnosis"]], "integer")
  expect_is(record[["dateOfBirth"]], "Date")
  expect_is(record[["censusOccCode19702000"]], "factor")
  expect_is(record[["estrogenReceptorSummary"]], "logical")
  expect_is(record[["secondaryDiagnosis1"]] ,"character")
  expect_is(record[["latitude"]], "numeric")
})

test_that("naaccr_record allows users to keep 'unknown' levels", {
  has_unknown <- naaccr_record(laterality = "9", keep_unknown = TRUE)
  expect_false(is.na(has_unknown[["laterality"]]))
  expect_true("unknown" %in% levels(has_unknown[["laterality"]]))

  no_unknown <- naaccr_record(laterality = "9", keep_unknown = FALSE)
  expect_true(is.na(no_unknown[["laterality"]]))
  expect_false("unknown" %in% levels(no_unknown[["laterality"]]))
})

test_that("read_naaccr_plain returns a data.frame with no NAs", {
  rabs16 <- read_naaccr_plain("../data/synthetic-naaccr-16-abstract.txt", version = 16)
  expect_false(anyNA(rabs16))
  rinc16 <- read_naaccr_plain("../data/synthetic-naaccr-16-incidence.txt", version = 16)
  expect_false(anyNA(rinc16))
  rabs18 <- read_naaccr_plain("../data/synthetic-naaccr-18-abstract.txt", version = 18)
  expect_false(anyNA(rabs18))
  rinc18 <- read_naaccr_plain("../data/synthetic-naaccr-18-incidence.txt", version = 18)
  expect_false(anyNA(rinc18))
})
