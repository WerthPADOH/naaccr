library(testthat)
library(naaccr)


context("naaccr_factor")

test_that("naaccr_factor converts the input to a factor", {
  races <- sprintf("%02d", 1:99)
  race_factor <- naaccr_factor(races, "race4")
  expect_is(race_factor, "factor")
  expect_equal(length(race_factor), length(races))
  expect_true(is.na(race_factor[99L]))

  countries <- list(
    code = c("ZZA", "ZZU", "XNI", "FRA"),
    name = c("Asia, NOS", "unknown", "North American Islands", "France")
  )
  country_factor <- naaccr_factor(
    countries[["code"]], "addrAtDxCountry", keep_unknown = TRUE
  )
  expect_identical(as.character(country_factor), countries[["name"]])
})

test_that("Applying naaccr_factor or naaccr_sentinel again makes no change", {
  races <- sprintf("%02d", 1:99)
  f <- naaccr_factor(races, "race1")
  expect_identical(f, naaccr_factor(f, "race1"))

  gis_qual <- c("00", "01", "02", "98", "99", NA)
  g <- naaccr_factor(gis_qual, "gisCoordinateQuality", keep_unknown = TRUE)
  expect_identical(g, naaccr_factor(g, "gisCoordinateQuality", keep_unknown = TRUE))

  ln_size <- c("00.0", "20.0", "XX.1", "XX.8", "XX.9", "99.0")
  s <- split_sentineled(ln_size, "lnSize")
  expect_identical(s[["lnSize"]], split_sentineled(ln_size, "lnSize")[["lnSize"]])
})

test_that("naaccr_factor warns for non-fields", {
  expect_warning(naaccr_factor("a", "foo"))
})

test_that("Users can keep or omit unknowns from levels", {
  no_unknown  <- naaccr_factor("9", "laterality", keep_unknown = FALSE)
  expect_true(is.na(no_unknown))
  expect_false("unknown" %in% levels(no_unknown))
  has_unknown <- naaccr_factor("9", "laterality", keep_unknown = TRUE)
  expect_false(is.na(has_unknown))
  expect_true("unknown" %in% levels(has_unknown))
})

test_that("split_sentineled returns a data.frame of the values and flags", {
  values <- c(sprintf("%02d", 0:50), "X1", "X7", "X9", 51:99)
  result <- split_sentineled(values, "numberOfCoresExamined")
  expect_is(result, "data.frame")
  expect_identical(dim(result), c(length(values), 2L))
  expect_named(result, c("numberOfCoresExamined", "numberOfCoresExaminedFlag"))
  expect_is(result[["numberOfCoresExamined"]], "numeric")
  expect_is(result[["numberOfCoresExaminedFlag"]], "factor")
  missing_value <- is.na(result[["numberOfCoresExamined"]])
  missing_flag  <- is.na(result[["numberOfCoresExaminedFlag"]])
  expect_true(all(missing_value | missing_flag))
})

test_that("split_sentineled returns double-NA for invalid codes with warning", {
  expect_warning(result <- split_sentineled("QQ", "gleasonScoreClinical"))
  expect_true(is.na(result[["gleasonScoreClinical"]]))
  expect_true(is.na(result[["gleasonScoreClinicalFlag"]]))
})

test_that("split_sentineled is robust to global options", {
  old_opt <- options(scipen = -10)
  on.exit(options(old_opt), add = TRUE)
  s_num <- split_sentineled(c(1, 20, 88), "sequenceNumberCentral")
  expect_identical(s_num[["sequenceNumberCentral"]], c(1, 20, NA))
  expect_identical(is.na(s_num[["sequenceNumberCentralFlag"]]), c(TRUE, TRUE, FALSE))
  s_char <- split_sentineled(c("01", "20", "88"), "sequenceNumberCentral")
  expect_identical(s_num, s_char)
})

test_that("All required code/sentinel schemes exist", {
  specified_schemes <- unique(naaccr:::field_code_scheme[["scheme"]])
  defined_schemes   <- unique(naaccr:::field_codes[["scheme"]])
  undefined <- setdiff(specified_schemes, defined_schemes)
  expect_identical(
    undefined, character(0),
    info = paste("Undefined schemes:", paste0(undefined, collapse = ", "))
  )

  specified_schemes <- unique(naaccr:::field_sentinel_scheme[["scheme"]])
  defined_schemes   <- unique(naaccr:::field_sentinels[["scheme"]])
  undefined <- setdiff(specified_schemes, defined_schemes)
  expect_identical(
    undefined, character(0),
    info = paste("Undefined schemes:", paste0(undefined, collapse = ", "))
  )
})

test_that("No unused code/sentinel schemes exist", {
  specified_schemes <- unique(naaccr:::field_code_scheme[["scheme"]])
  defined_schemes   <- unique(naaccr:::field_codes[["scheme"]])
  unused <- setdiff(defined_schemes, specified_schemes)
  expect_identical(
    unused, character(0),
    info = paste("Unused schemes:", paste0(unused, collapse = ", "))
  )

  specified_schemes <- unique(naaccr:::field_sentinel_scheme[["scheme"]])
  defined_schemes   <- unique(naaccr:::field_sentinels[["scheme"]])
  unused <- setdiff(defined_schemes, specified_schemes)
  expect_identical(
    unused, character(0),
    info = paste("Unused schemes:", paste0(unused, collapse = ", "))
  )
})

test_that("unknown_to_na removes levels if and only if they are 'unknown'", {
  v <- naaccr_factor(c("1", "4", "9"), field = "sex", keep_unknown = TRUE)
  v2 <- unknown_to_na(v, field = "sex")
  expect_identical(setdiff(levels(v), levels(v2)), "unknown")
  expect_identical(is.na(v2), c(FALSE, FALSE, TRUE))

  w <- naaccr_factor(c("0", "8", "9"), field = "her2IshSummary", keep_unknown = TRUE)
  w2 <- unknown_to_na(w, field = "her2IshSummary")
  expect_identical(
    setdiff(levels(w), levels(w2)),
    c("test ordered, results unknown", "not applicable", "unknown")
  )
  expect_identical(is.na(w2), c(FALSE, TRUE, TRUE))
})

test_that("unknown_to_na works on naaccr_record objects", {
  r <- naaccr_record(
    autopsy = c("2", "9"),
    ageAtDiagnosis = c("001", "100"),
    psaLabValue = c("123.4", "XXX.1"),
    sex = c("2", "9"),
    keep_unknown = TRUE
  )
  r2 <- unknown_to_na(r)
  expect_identical(is.na(r2[["autopsy"]]), c(FALSE, TRUE))
  expect_identical(is.na(r2[["sex"]]), c(FALSE, TRUE))
  expect_identical(
    r[, c("ageAtDiagnosis", "psaLabValue")],
    r2[, c("ageAtDiagnosis", "psaLabValue")]
  )
})

test_that("All factor and sentinel labels are appropriate characters", {
  # Country names are the most likely violations, if encoding is mishandled
  country_fields <- c(
    "addrAtDxCountry", "addrCurrentCountry", "birthplaceCountry",
    "followupContactCountry", "placeOfDeathCountry"
  )
  countries <- unlist(field_levels_all[country_fields])
  validation <- "^[\\pL' ,().-]+$" # \\pL := Unicode letter from any language
  invalid <- grep(validation, countries, invert = TRUE, value = TRUE, perl = TRUE)
  expect_true(
    length(invalid) == 0L,
    info = paste0(
      "Some values not matching pattern:\n",
      paste0(head(invalid), collapse = "\n")
    )
  )
  # All other values should be ASCII
  non_country_fields <- setdiff(names(field_levels_all), country_fields)
  non_countries <- unlist(field_levels_all[non_country_fields])
  ascii <- iconv(non_countries, from = "UTF-8", to = "ASCII")
  invalid <- non_countries[is.na(ascii)]
  expect_true(
    length(invalid) == 0L,
    info = paste0(
      "Some values with non-ASCII characters:\n",
      paste0(names(head(invalid)), ": ", head(invalid), collapse = "\n")
    )
  )
})
