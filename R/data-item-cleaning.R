# Functions for cleaning specific NAACCR data items.
# All these function take character vectors as input. This is the safest way to
# read NAACCR files because they heavily use sentinel values. Columns which will
# be converted to factors don't need cleaning.

#' Clean free-form text
#'
#' @param age A character vector of ages following the coding scheme of
#'   \code{ageAtDiagnosis}.
#' @param city A character vector of city names.
#' @param block A character vector of Census block group codes.
#' @param icd A character vector of ICD-7, ICD-8, ICD-9, and/or ICD-10 codes.
#' @param icd_cm A character vector of ICD-9-CM codes.
#' @param count A character vector of counts (integer characters only).
#' @param county A character vector of county FIPS codes.
#' @param fin A character vector of facility identification numbers (FIN).
#' @param location A character vector of house numbers and street names.
#' @param phone A character vector of telephone numbers. No spaces or
#'   punctuation, only numbers.
#' @param physician A character vector of medical license number or
#'   facility-generated codes.
#' @param postal A character vector of postal codes.
#' @param ssn A character vector of Social Security identification numbers.
#' @param text A character vector of free-form text values.
#' @param tract A character vector of Census tract group codes.
#' @param field_width Integer giving the width of the field. Used for determing
#'   the "all 9s" code for missing.
#' @param keep_unknown Replace values for "unknown" with \code{NA}?
#' @return
#'   All \code{unknown_\*} functions return a \code{logical} vector the same
#'   length as their input. Values of \code{TRUE} mean the respective element in
#'   the input stands for "unknown" or "not applicable."
#'
#'   All \code{clean_\*} functions return a vector the same length as the input.
#'   If \code{keep_unknown} is \code{TRUE}, codes meaning unknown or not
#'   applicable (determined with the matching \code{unknown_\*} function)
#'   are replaced with \code{NA}.
#'   The cleaning process and the returned vector's class depend on the function:
#'
#'   \tabular{lll}{
#'     Function \tab Returned \tab Cleaning process\cr
#'
#'     \code{clean_address_city} \tab \code{character} \tab
#'       Leading and trailing whitespace is removed.
#'       If \code{keep_unknown} is \code{FALSE}, blanks and \code{"UNKNOWN"} are
#'       replaced with \code{NA}.\cr
#'
#'     \code{clean_address_number_and_street} \tab \code{character} \tab
#'       Leading and trailing whitespace is removed.
#'       If \code{keep_unknown} is \code{FALSE}, blanks and \code{"UNKNOWN"} are
#'       replaced with \code{NA}.\cr
#'
#'     \code{clean_age} \tab \code{integer} \tab
#'       If \code{keep_unknown} is \code{FALSE}, codes above \code{120} are
#'       replaced with \code{NA}.\cr
#'
#'     \code{clean_census_block} \tab \code{character} \tab
#'       Leading and trailing whitespace is removed.
#'       If \code{keep_unknown} is \code{FALSE}, blanks and values representing
#'       unknown Census Block Groups are replaced with \code{NA}.\cr
#'
#'     \code{clean_census_tract} \tab \code{character} \tab
#'       Leading and trailing whitespace is removed.
#'       If \code{keep_unknown} is \code{FALSE}, blanks and values representing
#'       unknown Census Tracts are replaced with \code{NA}.\cr
#'
#'     \code{clean_count} \tab \code{integer} \tab
#'       Negative values are replaced with \code{NA}.
#'       If \code{keep_unknown} is \code{FALSE}, values that are just the digit
#'       \code{9} repeated for the entire width of the field are replaced with
#'       \code{NA}.\cr
#'
#'     \code{clean_county_fips} \tab \code{character} \tab
#'       Leading and trailing whitespace is removed.
#'       If \code{keep_unknown} is \code{FALSE}, blanks and values representing
#'       unknown counties are replaced with \code{NA}.\cr
#'
#'     \code{clean_facility_id} \tab \code{character} \tab
#'       Leading and trailing whitespace is removed.
#'       If \code{keep_unknown} is \code{FALSE}, blanks and values representing
#'       unknown facilities are replaced with \code{NA}.\cr
#'
#'     \code{clean_icd_9_cm} \tab \code{character} \tab
#'       Leading and trailing whitespace is removed.
#'       If \code{keep_unknown} is \code{FALSE}, blanks and the ICD-9-CM code
#'       for "unknown" (\code{"00000"}) are replaced with \code{NA}.\cr
#'
#'     \code{clean_icd_code} \tab \code{character} \tab
#'       Leading and trailing whitespace is removed.
#'       If \code{keep_unknown} is \code{FALSE}, blanks and the ICD codes for
#'       "unknown" (\code{"0000"}, \code{"7777"} and \code{"7797"}) are replaced
#'       with \code{NA}.\cr
#'
#'     \code{clean_physician_id} \tab \code{character} \tab
#'       Leading and trailing whitespace is removed.
#'       If \code{keep_unknown} is \code{FALSE}, blanks and values representing
#'       unknown physicians or non-applicable are replaced with \code{NA}.\cr
#'
#'     \code{clean_postal} \tab \code{character} \tab
#'       Leading and trailing whitespace is removed.
#'       If \code{keep_unknown} is \code{FALSE}, blanks and values representing
#'       uncertain postal codes are replaced with \code{NA}.\cr
#'
#'     \code{clean_ssn} \tab \code{character} \tab
#'       Leading and trailing whitespace is removed.
#'       If \code{keep_unknown} is \code{FALSE}, blanks and values representing
#'       unknown Social Security ID numbers are replaced with \code{NA}.\cr
#'
#'     \code{clean_telephone} \tab \code{character} \tab
#'       Leading and trailing whitespace is removed.
#'       If \code{keep_unknown} is \code{FALSE}, blanks and values representing
#'       unknown numbers or patients without a number are replaced with
#'       \code{NA}.\cr
#'
#'     \code{clean_text} \tab \code{character} \tab
#'       Leading and trailing whitespace is removed.
#'       If \code{keep_unknown} is \code{FALSE}, blank values are replaced with
#'       \code{NA}.\cr
#'   }
#' @export
#' @name cleaners
unknown_text <- function(text) {
  is.na(text) | !nzchar(text)
}


#' @import stringi
#' @export
#' @rdname cleaners
clean_text <- function(text, keep_unknown = FALSE) {
  trimmed <- stri_trim_both(text)
  if (!keep_unknown) {
    trimmed[unknown_text(trimmed)] <- NA_character_
  }
  trimmed
}


#' @export
#' @rdname cleaners
unknown_age <- function(age) {
  is.na(age) | age > 120L
}


#' @export
#' @rdname cleaners
clean_age <- function(age, keep_unknown = FALSE) {
  age_int <- as.integer(age)
  age_int[age_int < 0L] <- NA_integer_
  if (!keep_unknown) {
    age_int[unknown_age(age_int)] <- NA_integer_
  }
  age_int
}


#' @import stringi
#' @export
#' @rdname cleaners
unknown_address_city <- function(city) {
  stri_trans_toupper(city) %in% c(NA, '', 'UNKNOWN')
}


#' @import stringi
#' @export
#' @rdname cleaners
clean_address_city <- function(city, keep_unknown = FALSE) {
  city <- stri_trim_both(city)
  if (!keep_unknown) {
    city[unknown_address_city(city)] <- NA_character_
  }
  city
}


#' @import stringi
#' @export
#' @rdname cleaners
unknown_address_number_and_street <- function(location) {
  stri_trans_toupper(location) %in% c(NA, '', 'UNKNOWN')
}


#' @import stringi
#' @export
#' @rdname cleaners
clean_address_number_and_street <- function(location, keep_unknown = FALSE) {
  location <- stri_trim_both(location)
  if (!keep_unknown) {
    location[unknown_address_number_and_street(location)] <- NA_character_
  }
  location
}


#' @export
#' @rdname cleaners
unknown_postal <- function(postal) {
  postal %in% c(NA, '', '888888888', '999999999', '999999')
}


#' @import stringi
#' @export
#' @rdname cleaners
clean_postal <- function(postal, keep_unknown = FALSE) {
  if (is.numeric(postal)) {
    postal <- format(as.integer(postal), scientific = FALSE)
  }
  postal <- stri_trim_both(postal)
  if (!keep_unknown) {
    postal[unknown_postal(postal)] <- NA_character_
  }
  postal
}


#' @import stringi
#' @export
#' @rdname cleaners
unknown_census_block <- function(block) {
  is.na(block) | stri_detect_regex(block, "[^1-9]")
}


#' @import stringi
#' @export
#' @rdname cleaners
clean_census_block <- function(block, keep_unknown = FALSE) {
  if (is.numeric(block)) {
    block <- format(as.integer(block), scientific = FALSE)
  }
  block <- stri_trim_both(block)
  if (!keep_unknown) {
    block[unknown_census_block(block)] <- NA_character_
  }
  block
}


#' @export
#' @rdname cleaners
unknown_census_tract <- function(tract) {
  is_tract <- data.table::between(tract, '000100', '949999')
  is_bna <- data.table::between(tract, '950100', '998999')
  is.na(tract) | (!is_tract & !is_bna)
}


#' @import stringi
#' @import data.table
#' @export
#' @rdname cleaners
clean_census_tract <- function(tract, keep_unknown = FALSE) {
  if (is.numeric(tract)) {
    tract <- format(as.integer(tract), scientific = FALSE)
  }
  tract <- stri_trim_both(tract)
  if (!keep_unknown) {
    tract[unknown_census_tract(tract)] <- NA_character_
  }
  tract
}


#' @import stringi
#' @export
#' @rdname cleaners
unknown_county_fips <- function(county) {
  county <- stri_trim_both(county)
  is.na(county) |
    !nzchar(county) |
    stri_detect_regex(county, "[^0-9]") |
    county %in% c("998", "999")
}


#' @import stringi
#' @export
#' @rdname cleaners
clean_county_fips <- function(county, keep_unknown = FALSE) {
  if (is.numeric(county)) {
    county <- format(as.integer(county), scientific = FALSE)
  }
  county <- stri_trim_both(county)
  if (!keep_unknown) {
    county[unknown_county_fips(county)] <- NA_character_
  }
  county
}


#' @export
#' @rdname cleaners
unknown_icd_9_cm <- function(icd_cm) {
  icd_cm %in% c(NA, '', '00000')
}


#' @import stringi
#' @export
#' @rdname cleaners
clean_icd_9_cm <- function(icd_cm, keep_unknown = FALSE) {
  if (is.numeric(icd_cm)) {
    icd_cm <- format(as.integer(icd_cm), scientific = FALSE)
  }
  icd_cm <- stri_trim_both(icd_cm)
  if (!keep_unknown) {
    icd_cm[unknown_icd_9_cm(icd_cm)] <- NA_character_
  }
  icd_cm
}


#' @export
#' @rdname cleaners
unknown_icd_code <- function(icd) {
  icd %in% c(NA, '', '0000', '7777', '7797')
}


#' @import stringi
#' @export
#' @rdname cleaners
clean_icd_code <- function(icd, keep_unknown = FALSE) {
  if (is.numeric(icd)) {
    icd <- format(as.integer(icd), scientific = FALSE)
  }
  icd <- stri_trim_both(icd)
  if (!keep_unknown) {
    icd[unknown_icd_code(icd)] <- NA_character_
  }
  icd
}


#' @export
#' @rdname cleaners
unknown_facility_id <- function(fin) {
  fin %in% c(NA, '', '0000000000', '0099999999')
}


#' @import stringi
#' @export
#' @rdname cleaners
clean_facility_id <- function(fin, keep_unknown = FALSE) {
  if (is.numeric(fin)) {
    fin <- format(as.integer(fin), scientific = FALSE)
  }
  fin <- stri_trim_both(fin)
  if (!keep_unknown) {
    fin[unknown_facility_id(fin)] <- NA_character_
  }
  fin
}


#' @export
#' @rdname cleaners
unknown_physician_id <- function(physician) {
  physician %in% c(NA, '', '00000000', '99999999')
}


#' @import stringi
#' @export
#' @rdname cleaners
clean_physician_id <- function(physician, keep_unknown = FALSE) {
  if (is.numeric(physician)) {
    physician <- format(as.integer(physician), scientific = FALSE)
  }
  physician <- stri_trim_both(physician)
  if (!keep_unknown) {
    physician[unknown_physician_id(physician)] <- NA_character_
  }
  physician
}


#' @import stringi
#' @export
#' @rdname cleaners
unknown_telephone <- function(phone) {
  phone <- stri_trim_both(phone)
  is.na(phone) |
    !nzchar(phone) |
    stri_detect_regex(phone, "[^0-9]")
}


#' @import stringi
#' @export
#' @rdname cleaners
clean_telephone <- function(phone, keep_unknown = FALSE) {
  if (is.numeric(phone)) {
    phone <- format(as.integer(phone), scientific = FALSE)
  }
  phone <- stri_trim_both(phone)
  # See ?"stringi-search-charclass"
  punct_space <- "[\\p{Wspace}[:Pd:][:Ps:][:Pe:][:Pc:][:Po:][:Pi:][:Pf:]]"
  phone <- stri_replace_all_fixed(phone, punct_space, "")
  if (!keep_unknown) {
    phone[unknown_telephone(phone)] <- NA_character_
  }
  phone
}


#' @import stringi
#' @export
#' @rdname cleaners
unknown_count <- function(count, field_width) {
  na_code <- stri_dup("9", field_width)
  count %in% c(NA, na_code)
}


#' @import stringi
#' @export
#' @rdname cleaners
clean_count <- function(count, field_width, keep_unknown = FALSE) {
  count <- as.integer(count)
  if (!keep_unknown) {
    count[unknown_count(count, field_width)] <- NA_integer_
  }
  count
}


#' @export
#' @rdname cleaners
unknown_ssn <- function(ssn) {
  ssn %in% c(NA, "", "999999999")
}


#' @import stringi
#' @export
#' @rdname cleaners
clean_ssn <- function(ssn, keep_unknown = FALSE) {
  if (is.numeric(ssn)) {
    ssn <- format(as.integer(ssn), scientific = FALSE)
  }
  ssn <- stri_trim_both(ssn)
  if (!keep_unknown) {
    ssn[unknown_ssn(ssn)] <- NA_character_
  }
  ssn
}
