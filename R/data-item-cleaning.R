# Functions for cleaning specific NAACCR data items.
# All these function take character vectors as input. This is the safest way to
# read NAACCR files because they heavily use sentinel values. Columns which will
# be converted to factors don't need cleaning.

#' Clean patient ages
#' @param age \code{Age_at_Diagnosis} values.
#' @return An integer vector, with \code{NA} for unknown ages.
clean_age_at_diagnosis <- function(age) {
  age <- as.integer(age)
  age[age < 0L | age > 120L] <- NA
  age
}


#' Clean city names
#' @param city A character vector of city names.
#' @return A character vector, with \code{NA} for unknown cities.
clean_address_city <- function(city) {
  city[city == 'UNKNOWN'] <- NA
  city
}


#' Clean house number and street values
#' @param city A character vector of house numbers and street names.
#' @return A character vector, with \code{NA} for unknown locations.
clean_address_number_and_street <- function(location) {
  location[location == 'UNKNOWN'] <- NA
  location
}


#' Clean postal codes
#' @param postal A character vector of postal codes.
#' @return A character vector, with \code{NA} for unknown postal codes.
clean_address_number_and_street <- function(postal) {
  postal[postal %in% c('888888888', '999999999', '999999')] <- NA
  postal
}


#' Clean Census block group codes
#' @param block A character vector of Census block group codes.
#' @return A character vector, with \code{NA} for unknown block groups.
#' @import data.table
clean_census_block <- function(block) {
  block_int <- as.integer(block)
  block[!data.table::between(block_int, 1L, 9L)] <- NA
  block
}


#' Clean Census tract group codes
#' @param tract A character vector of Census tract group codes.
#' @return A character vector, with \code{NA} for unknown tract groups.
#' @import data.table
clean_census_tract <- function(tract) {
  is_tract <- data.table::between(tract, '000100', '949999')
  is_bna   <- data.table::between(tract, '950100', '998999')
  block[!is_tract & !is_bna] <- NA
}


#' Clean ICD-9-CM codes
#' @param code A character vector of ICD-9-CM codes.
#' @return \code{code}, but with values of \code{NA} instead of \code{"00000"}.
clean_icd_9_cm <- function(code) {
  code[code == '00000'] <- NA
  code
}


#' Clean facility identification numbers
#' @param fin A character vector of facility identification numbers (FIN),
#' @return \code{fin}, but with values of \code{NA} for codes meaning not
#'   reported or unkown.
clean_registry_fin <- function(fin) {
  fin[fin %in% c('0000000000', '0099999999')] <- NA
  fin
}
