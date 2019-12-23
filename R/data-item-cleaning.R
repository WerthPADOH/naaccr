# Functions for cleaning specific NAACCR data items.
# All these function take character vectors as input. This is the safest way to
# read NAACCR files because they heavily use sentinel values. Columns which will
# be converted to factors don't need cleaning.

#' Clean free-form text
#'
#' @param text A character vector of free text values.
#' @param keep_unknown Replace values for "unknown" with \code{NA}?
#' @return An character vector with leading and trailing whitespace removed.
#'   If \code{keep_unknown} is \code{FALSE}, blank values are replaced with
#'   \code{NA}.
#' @export
clean_text <- function(text, keep_unknown = FALSE) {
  trimmed <- trimws(text)
  if (!keep_unknown) {
    trimmed[!nzchar(trimmed)] <- NA_character_
  }
  trimmed
}

#' Clean patient ages
#' @param age \code{Age_at_Diagnosis} values.
#' @inheritParams clean_text
#' @return An integer vector of ages.
#'   If \code{keep_unknown} is \code{FALSE}, values representing unknown ages
#'   are replaced with \code{NA}.
#' @export
clean_age <- function(age, keep_unknown = FALSE) {
  age_int <- as.integer(age)
  if (!keep_unknown) {
    age_int[age_int < 0L | age_int > 120L] <- NA_integer_
  }
  age_int
}


#' Clean city names
#' @param city A character vector of city names.
#' @inheritParams clean_text
#' @return A character vector with leading and trailing whitespace removed.
#'   If \code{keep_unknown} is \code{FALSE}, blanks and "UNKNOWN" are replaced
#'   with \code{NA}.
#' @export
clean_address_city <- function(city, keep_unknown = FALSE) {
  city <- trimws(city)
  if (!keep_unknown) {
    city[city %in% c('', 'UNKNOWN')] <- NA_character_
  }
  city
}


#' Clean house number and street values
#' @param location A character vector of house numbers and street names.
#' @inheritParams clean_text
#' @return A character vector with leading and trailing whitespace removed.
#'   If \code{keep_unknown} is \code{FALSE}, blanks and "UNKNOWN" are replaced
#'   with \code{NA}.
#' @export
clean_address_number_and_street <- function(location, keep_unknown = FALSE) {
  location <- trimws(location)
  if (!keep_unknown) {
    location[location %in% c('', 'UNKNOWN')] <- NA_character_
  }
  location
}


#' Clean postal codes
#' @param postal A character vector of postal codes.
#' @inheritParams clean_text
#' @return A character vector with leading and trailing whitespace removed.
#'   If \code{keep_unknown} is \code{FALSE}, blanks and values representing
#'   uncertain postal codes are replaced with \code{NA}.
#' @export
clean_postal <- function(postal, keep_unknown = FALSE) {
  if (is.numeric(postal)) {
    postal <- format(as.integer(postal), scientific = FALSE)
  }
  postal <- trimws(postal)
  if (!keep_unknown) {
    postal[postal %in% c('', '888888888', '999999999', '999999')] <- NA_character_
  }
  postal
}


#' Clean Census block group codes
#' @param block A character vector of Census block group codes.
#' @inheritParams clean_text
#' @return A character vector with leading and trailing whitespace removed.
#'   If \code{keep_unknown} is \code{FALSE}, blanks and values representing
#'   unknown block groups are replaced with \code{NA}.
#' @export
clean_census_block <- function(block, keep_unknown = FALSE) {
  if (is.numeric(block)) {
    block <- format(as.integer(block), scientific = FALSE)
  }
  block <- trimws(block)
  if (!keep_unknown) {
    block[!grepl("^[1-9]$", block)] <- NA_character_
  }
  block
}


#' Clean Census tract group codes
#' @param tract A character vector of Census tract group codes.
#' @inheritParams clean_text
#' @return A character vector with leading and trailing whitespace removed.
#'   If \code{keep_unknown} is \code{FALSE}, blanks and values representing
#'   unknown Census Tracts are replaced with \code{NA}.
#' @import data.table
#' @export
clean_census_tract <- function(tract, keep_unknown = FALSE) {
  if (is.numeric(tract)) {
    tract <- format(as.integer(tract), scientific = FALSE)
  }
  tract <- trimws(tract)
  if (!keep_unknown) {
    is_tract <- data.table::between(tract, '000100', '949999')
    is_bna   <- data.table::between(tract, '950100', '998999')
    tract[!is_tract & !is_bna] <- NA_character_
  }
  tract
}


#' Clean county FIPS codes
#' @param county A character vector of county FIPS codes.
#' @inheritParams clean_text
#' @return A character vector with leading and trailing whitespace removed.
#'   If \code{keep_unknown} is \code{FALSE}, blanks and values representing
#'   unknown counties are replaced with \code{NA}.
#' @import stringi
#' @export
clean_county_fips <- function(county, keep_unknown = FALSE) {
  if (is.numeric(county)) {
    county <- format(as.integer(county), scientific = FALSE)
  }
  county <- trimws(county)
  if (!keep_unknown) {
    stri_subset_regex(county, "^\\d{3}$", negate = TRUE) <- NA_character_
    county[!nzchar(county)] <- NA_character_
  }
  county
}


#' Clean ICD-9-CM codes
#' @param code A character vector of ICD-9-CM codes.
#' @inheritParams clean_text
#' @return A character vector with leading and trailing whitespace removed.
#'   If \code{keep_unknown} is \code{FALSE}, blanks and the ICD-9-CM code for
#'   "unknown" (\code{"00000"}) are replaced with \code{NA}.
#' @export
clean_icd_9_cm <- function(code, keep_unknown = FALSE) {
  if (is.numeric(code)) {
    code <- format(as.integer(code), scientific = FALSE)
  }
  code <- trimws(code)
  if (!keep_unknown) {
    code[code %in% c('', '00000')] <- NA_character_
  }
  code
}


#' Clean cause of death codes
#' @param code A character vector of ICD-7, ICD-8, ICD-9, and/or ICD-10 codes.
#' @inheritParams clean_text
#' @return A character vector with leading and trailing whitespace removed.
#'   If \code{keep_unknown} is \code{FALSE}, blanks and the ICD codes for
#'   "unknown" (\code{"0000"}, \code{"7777"} and \code{"7797"}) are replaced
#'   with \code{NA}.
#' @export
clean_icd_code <- function(code, keep_unknown = FALSE) {
  if (is.numeric(code)) {
    code <- format(as.integer(code), scientific = FALSE)
  }
  code <- trimws(code)
  if (!keep_unknown) {
    code[code %in% c('', '0000', '7777', '7797')] <- NA_character_
  }
  code
}


#' Clean facility identification numbers
#' @param fin A character vector of facility identification numbers (FIN).
#' @inheritParams clean_text
#' @return A character vector with leading and trailing whitespace removed.
#'   If \code{keep_unknown} is \code{FALSE}, blanks and values representing
#'   unknown facilities are replaced with \code{NA}.
#' @export
clean_facility_id <- function(fin, keep_unknown = FALSE) {
  if (is.numeric(fin)) {
    fin <- format(as.integer(fin), scientific = FALSE)
  }
  fin <- trimws(fin)
  if (!keep_unknown) {
    fin[fin %in% c('', '0000000000', '0099999999')] <- NA_character_
  }
  fin
}


#' Clean physician identification numbers
#' @param physician A character vector of medical license number or
#'   facility-generated codes.
#' @inheritParams clean_text
#' @return A character vector with leading and trailing whitespace removed.
#'   If \code{keep_unknown} is \code{FALSE}, blanks and values representing
#'   unknown physicians or non-applicable are replaced with \code{NA}.
#' @export
clean_physician_id <- function(physician, keep_unknown = FALSE) {
  if (is.numeric(physician)) {
    physician <- format(as.integer(physician), scientific = FALSE)
  }
  physician <- trimws(physician)
  if (!keep_unknown) {
    physician[physician %in% c('', '00000000', '99999999')] <- NA_character_
  }
  physician
}


#' Clean telephone numbers
#' @param number A character vector of telephone numbers. No spaces or
#'   punctuation, only numbers.
#' @inheritParams clean_text
#' @return A character vector with leading and trailing whitespace removed.
#'   If \code{keep_unknown} is \code{FALSE}, blanks and values representing
#'   unknown numbers or patients without a number are replaced with \code{NA}.
#' @export
clean_telephone <- function(number, keep_unknown = FALSE) {
  if (is.numeric(number)) {
    number <- format(as.integer(number), scientific = FALSE)
  }
  number <- trimws(number)
  number <- stri_replace_all_fixed(number, "[[:punct:][:space:]]", "")
  if (!keep_unknown) {
    number[grep("^[09]+$", number)] <- NA_character_
    number[!nzchar(number)] <- NA_character_
    number[grep("\\D", number)] <- NA_character_
  }
  number
}


#' Clean counts
#'
#' Replaces any values of all 9's with \code{NA}
#' (if \code{keep_unknown} is \code{TRUE}) and converts the rest to integers.
#'
#' @param count A character vector of counts (integer characters only).
#' @param width Integer giving the character width of the field.
#' @inheritParams clean_text
#' @return Integer vector of \code{count}.
#'   If \code{keep_unknown} is \code{FALSE}, values representing unknown counts
#'   are replaced with \code{NA}.
#' @import stringi
#' @export
clean_count <- function(count, width, keep_unknown = FALSE) {
  count <- as.integer(count)
  if (!keep_unknown) {
    na_code <- as.integer(10^width - 1)
    count[count == na_code] <- NA_integer_
  }
  count
}


#' Clean Social Security ID numbers
#' @param number A character vector of Social Security identification numbers.
#'   No spaces or punctuation, only numbers.
#' @inheritParams clean_text
#' @return A character vector with leading and trailing whitespace removed.
#'   If \code{keep_unknown} is \code{FALSE}, blanks and values representing
#'   unknown Social Security ID numbers are replaced with \code{NA}.
#' @export
clean_ssn <- function(number, keep_unknown = FALSE) {
  if (is.numeric(number)) {
    number <- format(as.integer(number), scientific = FALSE)
  }
  number <- trimws(number)
  if (!keep_unknown) {
    number[number %in% c("", "999999999")] <- NA_character_
  }
  number
}
