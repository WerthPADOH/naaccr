library(data.table)
library(testthat)
library(naaccr)
library(stringi)


context("naaccr_record")


expected_column_names <- function(format_data) {
  nm <- format_data[["name"]]
  if ("sequenceNumberCentral" %in% nm) {
    nm <- c(nm, naaccr:::sequence_number_columns[, "central"])
  }
  if ("sequenceNumberHospital" %in% nm) {
    nm <- c(nm, naaccr:::sequence_number_columns[, "hospital"])
  }
  flag_columns <- stri_join(
    intersect(naaccr:::field_sentinel_scheme[["name"]], format_data[["name"]]),
    "Flag"
  )
  unique(c(nm, flag_columns))
}


test_that("read_naaccr returns a 'naaccr_record', 'data.frame' object", {
  nr <- read_naaccr(
    "../data/synthetic-naaccr-18-incidence.txt",
    version = 18,
    keep_fields = "sex"
  )
  expect_true(inherits(nr, "naaccr_record"))
  expect_true(inherits(nr, "data.frame"))
})

test_that("read_naaccr returns all columns by default", {
  abst <- read_naaccr("../data/synthetic-naaccr-18-abstract.txt",  version = 18)
  inc  <- read_naaccr("../data/synthetic-naaccr-18-incidence.txt", version = 18)
  expected_ncol <- length(expected_column_names(naaccr_format_18))
  expect_identical(ncol(abst), expected_ncol)
  expect_identical(ncol(abst), expected_ncol)
})

test_that("read_naaccr reads the data", {
  nr <- read_naaccr(
    "../data/synthetic-naaccr-18-abstract.txt",
    version = 18,
    keep_fields = "ageAtDiagnosis"
  )
  record_lines <- readLines("../data/synthetic-naaccr-18-abstract.txt")
  age_expected <- as.integer(substr(record_lines, 223, 225))
  expect_identical(nr[["ageAtDiagnosis"]], age_expected)
})

test_that("read_naaccr only creates the columns from the format", {
  all_types <- naaccr_format_18[
    list(type = unique(type)),
    on = "type",
    mult = "first"
  ]
  nr <- read_naaccr("../data/synthetic-naaccr-18-abstract.txt", format = all_types)
  expected_names <- expected_column_names(all_types)
  expect_named(
    nr, expected_names, ignore.order = TRUE,
    info = stri_join(
      "Mismatches: ",
      stri_join("+", setdiff(names(nr), expected_names), collapse = ", "),
      stri_join("-", setdiff(expected_names, names(nr)), collapse = ", ")
    )
  )
})

test_that("read_naaccr can handle different versions", {
  nr16 <- read_naaccr(
    "../data/synthetic-naaccr-16-abstract.txt",
    version = 16,
    keep_fields = c("ageAtDiagnosis", "addrAtDxCity")
  )
  expect_identical(
    nr16[["ageAtDiagnosis"]],
    c(60L, 72L, 70L, 60L, 83L, 56L, 73L, 60L, 42L, 61L)
  )
  expect_identical(
    nr16[["addrAtDxCity"]][1:2],
    c("STRASBURG", "BRIDGEVILLE")
  )
})

test_that("read_naaccr can handle custom formats", {
  sub_format <-naaccr_format_18[1:5]
  custom_format <- rbind(
    sub_format,
    record_format(
      name = c("copyRecordType", "fieldNotInFile"), item = 998:999,
      start_col = c(1, NA), end_col = c(1, NA), type = "character"
    )
  )
  plain <- read_naaccr(
    input = "../data/synthetic-naaccr-18-incidence.txt", format = sub_format,
    nrows = 10
  )
  custom <- read_naaccr(
    input = "../data/synthetic-naaccr-18-incidence.txt", format = custom_format,
    nrows = 10
  )
  expect_identical(plain[, sub_format[["name"]]], custom[, sub_format[["name"]]])
  expect_identical(
    plain[["recordType"]],
    naaccr_factor(custom[["copyRecordType"]], field = "recordType")
  )
  expect_true(all(is.na(custom[["fieldNotInFile"]])))
  expect_true(is.character(custom[["fieldNotInFile"]]))
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
    race1           = 1,
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

test_that("naaccr_record can preserve 'unknown' codes in cleaned fields", {
  record <- naaccr_record(
    ageAtDiagnosis = c("001", "200"),
    addrAtDxPostalCode = c("888888888", "90210"),
    dateOfDiagnosis = c("19900801", "1998    "),
    keep_unknown = TRUE
  )
  expect_identical(record[["ageAtDiagnosis"]], c(1L, 200L))
  expect_identical(record[["addrAtDxPostalCode"]], c("888888888", "90210"))
  expect_equivalent(record[["dateOfDiagnosis"]], as.Date(c("1990-08-01", NA)))
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

test_that("naaccr_record preserves columns not detailed in the format", {
  foo <- c(0 + 1i, 2 + 3i)
  record <- naaccr_record(
    ageAtDiagnosis = "075",
    dateOfBirth = "20081021",
    `/foo/` = foo # definitely not a name in the format
  )
  expect_named(record, c("ageAtDiagnosis", "dateOfBirth", "/foo/"))
  expect_identical(record[["/foo/"]], foo)
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

test_that("read_naaccr allows skipping lines", {
  inc_file <- "../data/synthetic-naaccr-16-incidence.txt"
  rec_all <- read_naaccr(inc_file, version = 16, keep_fields = "sex")
  rec_some <- read_naaccr(inc_file, version = 16, keep_fields = "sex", skip = 5)
  expect_equivalent(rec_all[-(1:5), , drop = FALSE], rec_some)
})

test_that("read_naaccr can read only a subset of lines", {
  inc_file <- "../data/synthetic-naaccr-16-incidence.txt"
  rec_all <- read_naaccr(inc_file, version = 16, keep_fields = "sex")
  rec_some <- read_naaccr(inc_file, version = 16, keep_fields = "sex", nrows = 3)
  expect_equivalent(rec_some, rec_all[1:3, , drop = FALSE])
  rec_beyond <- read_naaccr(
    inc_file,
    version = 16,
    keep_fields = "sex",
    nrows = 2 * nrow(rec_all)
  )
  expect_equivalent(rec_beyond, rec_all)
})

test_that("read_naaccr can read data in chunks", {
  inc_file <- "../data/synthetic-naaccr-18-incidence.txt"
  fields <- c("ageAtDiagnosis", "patientIdNumber", "primarySite")
  recs <- read_naaccr(inc_file, version = 18, keep_fields = fields)
  for (buffer in c(1, 7, 10, 20, 100)) {
    chunked <- read_naaccr(
      inc_file, version = 18, keep_fields = fields, buffersize = buffer
    )
    expect_equivalent(chunked, recs)
  }
  for (buffer in c(1, 7, 10, 20, 100)) {
    chunked <- read_naaccr(
      inc_file, version = 18, keep_fields = fields, buffersize = buffer,
      nrows = 13
    )
    expect_equivalent(chunked, recs[1:13, ])
  }
})

test_that("read_naaccr can handle different file encodings", {
  rec_lines <- readLines("../data/synthetic-naaccr-16-incidence.txt")
  write_and_read_encoding <- function(enc) {
    tf <- tempfile()
    on.exit(if (file.exists(tf)) file.remove(tf), add = TRUE)
    write_con <- file(tf, open = "w", encoding = enc)
    writeLines(rec_lines, con = write_con)
    close(write_con)
    read_naaccr(tf, version = 16, keep_fields = "sex", encoding = enc)
  }
  encodings <- c("native.enc", "latin1", "UTF-8", "UTF-16")
  results <- lapply(encodings, write_and_read_encoding)
  for (ii in seq_along(encodings)[-1]) {
    expect_identical(
      results[[1]], results[[ii]],
      info = paste0(
        "Results from 'native.enc' and '", encodings[ii], "' not identical"
      )
    )
  }
})

test_that("read_naaccr can handle a custom format", {
  new_format <- rbind(
    naaccr_format_18[1:5],
    record_format(
      name = "1 very % unusual name `",
      item = -2,
      start_col = 45, # spans two numeric fields
      end_col = 55,
      type = "integer",
      alignment = "left",
      padding = " ",
      name_literal = "blah"
    )
  )
  recs <- read_naaccr(
    "../data/synthetic-naaccr-18-incidence.txt",
    format = new_format
  )
  expect_identical(names(recs), new_format[["name"]])
  expect_is(recs[["1 very % unusual name `"]], "integer")
})

test_that("read_naaccr reads empty files into a 0-row tabel with all columns", {
  tf <- tempfile()
  on.exit(if (file.exists(tf)) file.remove(tf), add = TRUE)
  file.create(tf)
  fields <- c(
    "ageAtDiagnosis", "dateOfBirth", "censusOccCode19702000",
    "estrogenReceptorSummary", "secondaryDiagnosis1", "latitude"
  )
  plain <- read_naaccr_plain(tf, version = 18, keep_fields = fields)
  expect_identical(dim(plain), c(0L, length(fields)))
  expect_named(plain, fields)
  processed <- read_naaccr(tf, version = 18, keep_fields = fields)
  expect_identical(dim(processed), c(0L, length(fields)))
  expect_named(processed, fields)
  expect_is(processed[["ageAtDiagnosis"]], "integer")
  expect_is(processed[["dateOfBirth"]], "Date")
  expect_is(processed[["censusOccCode19702000"]], "factor")
  expect_is(processed[["estrogenReceptorSummary"]], "logical")
  expect_is(processed[["secondaryDiagnosis1"]] ,"character")
  expect_is(processed[["latitude"]], "numeric")
})
