library(testthat)
library(naaccr)
library(XML)


context("write_naaccr")


write_naaccr_to_vector <- function(records, version = 18) {
  tc <- textConnection(NULL, open = "w")
  on.exit(close(tc))
  write_naaccr(records, tc, version)
  textConnectionValue(tc)
}


test_that("write_naaccr gives a warning for overly wide values", {
  records <- data.frame(
    patientIdNumber = c("1234567890", "2", "1234567890", "12345678", ""),
    stringsAsFactors = FALSE
  )
  expect_warning(
    write_naaccr_to_vector(records),
    "\\b2\\b.*patientIdNumber.*too wide"
  )
})

test_that("write_naaccr weaves sentineled values and flags", {
  literals <- c("  ", "10", "95", "97", "98", "88", "90", "99")
  records <- split_sentineled(literals, "regionalNodesPositive")
  output <- write_naaccr_to_vector(records)
  regionalNodesPositive <- substr(output, 998, 999)
  expect_identical(regionalNodesPositive, literals)
})

test_that("write_naaccr recodes factors", {
  literals <- c("1", "3", "5", " ", "6", "4", "2")
  records <- data.frame(
    maritalStatusAtDx = naaccr_factor(literals, "maritalStatusAtDx")
  )
  output <- write_naaccr_to_vector(records)
  maritalStatusAtDx <- substr(output, 206, 206)
  expect_identical(maritalStatusAtDx, literals)
})

test_that("write_naaccr correctly formats dates and times", {
  records <- data.frame(
    dateOfDiagnosis = as.Date(
      c("2011-08-05", "2017-12-31", NA),
      format = "%Y-%m-%d"
    ),
    pathDateSpecCollect1 = as.POSIXct(
      c("2013-12-11 10:09:08", "2001-09-07 16:58:53", NA),
      format = "%Y-%m-%d %H:%M:%S"
    )
  )
  output <- write_naaccr_to_vector(records)
  dates <- substr(output,  544,  551)
  times <- substr(output, 6200, 6213)
  expect_identical(dates, c("20110805", "20171231", "        "))
  expect_identical(times, c("20131211100908", "20010907165853", "              "))
})

test_that("write_naaccr -> read_naaccr will give the same values", {
  records_16 <- read_naaccr("../data/synthetic-naaccr-16-incidence.txt", 16)
  tf16 <- tempfile()
  write_naaccr(records_16, tf16, 16)
  records_16_2 <- read_naaccr(tf16, 16)
  expect_equivalent(records_16, records_16_2)
  file.remove(tf16)

  records_18 <- read_naaccr("../data/synthetic-naaccr-18-incidence.txt", 18)
  tf18 <- tempfile()
  write_naaccr(records_18, tf18, 18)
  records_18_2 <- read_naaccr(tf18, 18)
  expect_equivalent(records_18, records_18_2)
  file.remove(tf18)
})

test_that("write_naaccr can handle custom formats", {
  new_format <- naaccr_format_16[
    list(name = c("recordType", "patientIdNumber", "reserved00")),
    on = "name"
  ][
    name == "reserved00",
    ":="(
      name = "newField",
      item = -2,
      type = "Date",
      alignment = "left",
      padding = " ",
      name_literal = "new new new"
    )
  ]
  recs <- read_naaccr(
    "../data/synthetic-naaccr-16-incidence.txt",
    version = 16,
    keep_fields = c("recordType", "patientIdNumber", "reserved00")
  )
  recs[["newField"]] <- as.Date("1900-01-01") + seq_len(nrow(recs))
  tf <- tempfile()
  on.exit(file.remove(tf), add = TRUE)
  write_naaccr(recs, tf, format = new_format)
  recs_2 <- read_naaccr(tf, format = new_format)
  for (column in names(recs_2)) {
    expect_equivalent(recs_2[[column]], recs[[column]])
  }
})


write_naaccr_xml_to_vector <- function(records, version = NULL, format = NULL) {
  tc <- textConnection(NULL, open = "w")
  on.exit(close(tc), add = TRUE)
  write_naaccr_xml(records, tc, version = version, format = format)
  textConnectionValue(tc)
}


get_ids <- function(node) {
  xmlAttrs(node)[["naaccrId"]]
}


test_that("write_naaccr_xml includes all and only items in format and records", {
  records <- naaccr_record(
    ageAtDiagnosis = 65,
    patientIdNumber = 999,
    recordType = "A",
    foo = "bar"
  )

  xml_text <- write_naaccr_xml_to_vector(records, version = 18)
  tree <- xmlParse(xml_text, asText = TRUE)
  ids <- xpathSApply(tree, "//x:Item", get_ids, namespaces = "x")
  expect_setequal(ids, c("ageAtDiagnosis", "patientIdNumber", "recordType"))

  subfmt <- naaccr_format_18[name == "patientIdNumber"]
  xml_text <- write_naaccr_xml_to_vector(records, format = subfmt)
  tree <- xmlParse(xml_text, asText = TRUE)
  ids <- xpathSApply(tree, "//x:Item", get_ids, namespaces = "x")
  expect_setequal(ids, "patientIdNumber")
})

test_that("write_naaccr_xml puts items under correct parent node", {
  records <- read_naaccr("../data/synthetic-naaccr-18-incidence.txt", version = 18)
  subfmt <- naaccr_format_18[name %in% names(records)]
  item_tiers <- split(subfmt[["name"]], subfmt[["parent"]])
  xml_text <- write_naaccr_xml_to_vector(records, format = subfmt)
  tree <- xmlParse(xml_text, asText = TRUE)

  naaccr_ids <- xpathSApply(tree, "//x:NaaccrData/x:Item", get_ids, namespaces = "x")
  expect_setequal(naaccr_ids, item_tiers[["NaaccrData"]])

  patient_ids <- xpathSApply(tree, "//x:Patient/x:Item", get_ids, namespaces = "x")
  expect_setequal(patient_ids, item_tiers[["Patient"]])

  tumor_ids <- xpathSApply(tree, "//x:Tumor/x:Item", get_ids, namespaces = "x")
  expect_setequal(tumor_ids, item_tiers[["Tumor"]])
})
