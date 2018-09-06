# Functions for cleaning specific NAACCR data items.
# All these function take character vectors as input. This is the safest way to
# read NAACCR files because they heavily use sentinel values. Columns which will
# be converted to factors don't need cleaning.

#' Clean patient ages
#' @param age \code{Age_at_Diagnosis} values.
#' @return An integer vector, with \code{NA} for unknown ages.
#' @export
clean_age <- function(age) {
  age_int <- as.integer(age)
  age[age_int < 0L | age_int > 120L] <- NA
  age
}


#' Clean city names
#' @param city A character vector of city names.
#' @return A character vector, with \code{NA} for unknown cities.
#' @export
clean_address_city <- function(city) {
  city <- trimws(city)
  city[city == 'UNKNOWN'] <- NA
  city
}


#' Clean house number and street values
#' @param city A character vector of house numbers and street names.
#' @return A character vector, with \code{NA} for unknown locations.
#' @export
clean_address_number_and_street <- function(location) {
  location <- trimws(location)
  location[location == 'UNKNOWN'] <- NA
  location
}


#' Clean postal codes
#' @param postal A character vector of postal codes.
#' @return A character vector, with \code{NA} for unknown postal codes.
#' @export
clean_postal <- function(postal) {
  postal <- trimws(postal)
  postal[postal %in% c('888888888', '999999999', '999999')] <- NA
  postal
}


#' Clean Census block group codes
#' @param block A character vector of Census block group codes.
#' @return A character vector, with \code{NA} for unknown block groups.
#' @import data.table
#' @export
clean_census_block <- function(block) {
  block_int <- as.integer(block)
  block[!data.table::between(block_int, 1L, 9L)] <- NA
  block
}


#' Clean Census tract group codes
#' @param tract A character vector of Census tract group codes.
#' @return A character vector, with \code{NA} for unknown tract groups.
#' @import data.table
#' @export
clean_census_tract <- function(tract) {
  tract <- trimws(tract)
  is_tract <- data.table::between(tract, '000100', '949999')
  is_bna   <- data.table::between(tract, '950100', '998999')
  tract[!is_tract & !is_bna] <- NA
  tract
}


#' Clean county FIPS codes
#' @param tract A character vector of county FIPS codes.
#' @return A character vector, with \code{NA} for unknown counties.
#' @export
clean_county_fips <- function(county) {
  county <- trimws(county)
  stri_subset_regex(county, "^\\d{3}$", negate = TRUE) <- NA
  county
}


#' Clean ICD-9-CM codes
#' @param code A character vector of ICD-9-CM codes.
#' @return \code{code}, but with values of \code{NA} instead of \code{"00000"}.
#' @export
clean_icd_9_cm <- function(code) {
  code <- trimws(code)
  code[code %in% c('', '00000')] <- NA
  code
}


#' Clean cause of death codes
#' @param code A character vector of ICD-7, ICD-8, ICD-9, and/or ICD-10 codes.
#' @return \code{code}, but with values of \code{"00000"}, \code{"7777"}, and
#'   \code{"7797"} replaced with \code{NA}.
#' @export
clean_cause_of_death <- function(code) {
  code <- trimws(code)
  code[stri_trim_both(code) %in% c('', '0000', '7777', '7797')] <- NA
  code
}


#' Clean facility identification numbers
#' @param fin A character vector of facility identification numbers (FIN),
#' @return \code{fin}, but with values of \code{NA} for codes meaning not
#'   reported or unkown.
#' @export
clean_facility_id <- function(fin) {
  fin <- trimws(fin)
  fin[fin %in% c('0000000000', '0099999999')] <- NA
  fin
}


#' Clean the "Multiplicity Counter" codes
#' @param count A character vector of "Multiplicity Counter" codes.
#' @return Integer vector of \code{count}, but with values of \code{NA} for
#'   codes meaning not reported or unkown.
#' @export
clean_multiplicity_counter <- function(count) {
  count_int <- as.integer(count)
  count_int[count_int < 0L | count_int > 87L] <- NA
  count_int
}


#' Clean physician identification numbers
#' @param physician A character vector of medical license number or
#'   facility-generated codes.
#' @return \code{physician}, but with values of \code{NA} for codes meaning not
#'   reported or unkown.
#' @export
clean_physician_id <- function(physician) {
  physician <- trimws(physician)
  physician[physician %in% c('00000000', '99999999')] <- NA
  physician
}
