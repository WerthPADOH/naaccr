#' Analysis-ready NAACCR records
#'
#' Subclass of \code{data.frame} for doing analysis with NAACCR records.
#'
#' While \code{\link{read_naaccr}} creates a \code{data.frame} of only NAACCR
#' fields as \code{character} columns, \code{naaccr_record} creates a
#' \code{data.frame} ready for analysis: columns are of appropriate classes,
#' coded values are replaced with factors, and unknowns are replaced with
#' \code{NA}.
#'
#' @param input Either a string with a file name (containing no \code{\\n}
#'   character), a \code{\link[base]{connection}} object, or the
#'   text records themselves as a character vector.
#' @param ... Arguments of the form \code{tag = value}, where \code{tag} is a
#'   valid NAACCR data item name and \code{value} is the vector of the item's
#'   values.
#' @param version An integer specifying which NAACCR format should be
#'   used to parse the records. Only used if \code{input} is given.
#' @return A \code{data.frame} with columns named using the NAACCR XML scheme.
#' @export
naaccr_record <- function(input, ..., version = NULL) {
  input_data <- if (!missing(input)) {
    read_naaccr(input, version)
  } else {
    character_values <- lapply(list(...), as.character)
    as.data.frame(character_values, stringsAsFactors = FALSE)
  }
  as.naaccr_record(input_data)
}


#' Coerce to a naaccr_record dataset
#' Convert objects into \code{naaccr_record} objects, if a method exists.
#' @param x An R object.
#' @param ... Additional arguments passed to or from methods.
#' @return An object of class \code{\link{naaccr_record}}
#' @seealso \code{\link{naaccr_record}}
#' @export
as.naaccr_record <- function(x, ...) {
  UseMethod('as.naaccr_record')
}


#' @rdname as.naaccr_record
#' @export
as.naaccr_record.list <- function(x, ...) {
  x_df <- as.data.frame(x, stringsAsFactors = FALSE)
  as.naaccr_record(x_df)
}


#' Assignment by reference if needed
#'
#' Only attempt to apply \code{set} on a \code{data.table} if something will
#' actually be set.
#'
#' @param x,i,j,value Passed onto \code{\link[data.table]{set}}.
#' @return \code{x} is modified by reference and returned invisibly.
#' @import data.table
#' @noRd
safe_set <- function(x, i = NULL, j, value) {
  is_non_empty_i <- is.null(i) | length(i) > 0
  is_non_empty_j <- length(j) > 0
  if (is_non_empty_i && is_non_empty_j) {
    set(x, i, j, value)
  }
  invisible(x)
}


#' @rdname as.naaccr_record
#' @import data.table
#' @export
as.naaccr_record.data.frame <- function(x, ...) {
  latest_items <- naaccr_items[naaccr_version == max(naaccr_version)]
  matched_items <- latest_items[list(names(x)), on = 'xml_name']
  record <- as.data.table(x)
  setnames(record, matched_items[['xml_name']])
  missing_columns <- setdiff(latest_items[['xml_name']], names(record))
  safe_set(record, j = missing_columns, value = NA_character_)

  type_columns <- split(item_types[['name']], item_types[['type']])
  type_converters <- list(
    integer      = as.integer,
    numeric      = as.numeric,
    boolean      = naaccr_boolean,
    override     = naaccr_override,
    sentineled   = as.numeric,
    postal       = clean_postal,
    city         = clean_address_city,
    address      = clean_address_number_and_street,
    facility     = clean_facility_id,
    census_block = clean_census_block,
    census_tract = clean_census_tract,
    icd_9        = clean_icd_9_cm,
    county       = clean_county_fips,
    physician    = clean_physician_id,
    Date         = function(x) {
      as.Date(x, format = '%Y%m%d')
    },
    datetime     = function(x) {
      x <- stri_trim_both(x)
      x <- stri_pad_right(x, width = 14L, pad = "0", use_length = TRUE)
      as.POSIXct(x, format = "%Y%m%d%H%M%S")
    }
  )
  for (type in names(type_converters)) {
    columns <- intersect(type_columns[[type]], names(record))
    if (length(columns) > 0L) {
      converter_fun <- type_converters[[type]]
      for (column in columns) {
        safe_set(record, j = column, value = converter_fun(record[[column]]))
      }
    }
  }
  for (column in intersect(type_columns[["sentineled"]], names(record))) {
    safe_set(
      x     = record,
      j     = column,
      value = naaccr_sentineled(record[[column]], field = column)
    )
  }
  record[
    ,
    ':='(
      ageAtDiagnosis = clean_age(ageAtDiagnosis),
      cancerStatus   = naaccr_boolean(cancerStatus, false_value = '1'),
      autopsy        = c(`1` = TRUE, `2` = FALSE)[autopsy],
      causeOfDeath   = clean_cause_of_death(causeOfDeath)
    )
  ][
    radNoOfTreatmentVol == 999,
    radNoOfTreatmentVol := NA
  ][
    socialSecurityNumber == '999999999',
    socialSecurityNumber := NA
  ][
    telephone %in% c("0000000000", "9999999999"),
    telephone := NA
  ]
  record <- setDF(record)
  class(record) <- c('naaccr_record', class(record))
  record
}
