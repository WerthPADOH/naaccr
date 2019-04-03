#' Analysis-ready NAACCR records
#'
#' Subclass of \code{data.frame} for doing analysis with NAACCR records.
#'
#' \code{naaccr_record} creates a \code{data.frame} of cancer incidence records
#' ready for analysis:
#' columns are of appropriate classes, coded values are replaced with factors,
#' and unknowns are replaced with \code{NA}.
#'
#' @param ... Arguments of the form \code{tag = value}, where \code{tag} is a
#'   valid NAACCR data item name and \code{value} is the vector of the item's
#'   values from the NAACCR format.
#' @param keep_unknown Logical indicating whether values of "unknown" should be
#'   a level in the factor or \code{NA}.
#' @param version An integer specifying which NAACCR format should be
#'   used to parse the records. Only used if \code{input} is given.
#' @return A \code{data.frame} with columns named using the NAACCR XML scheme.
#' @import data.table
#' @export
naaccr_record <- function(..., keep_unknown = FALSE, version = NULL) {
  input_data <- lapply(list(...), as.character)
  setDF(input_data)
  as.naaccr_record(input_data, keep_unknown = keep_unknown)
}


#' Coerce to a naaccr_record dataset
#' Convert objects into \code{naaccr_record} objects, if a method exists.
#' @param x An R object.
#' @param keep_unknown Logical indicating whether values of "unknown" should be
#'   a level in the factor or \code{NA}.
#' @param ... Additional arguments passed to or from methods.
#' @return An object of class \code{\link{naaccr_record}}
#' @seealso \code{\link{naaccr_record}}
#' @export
as.naaccr_record <- function(x, keep_unknown = FALSE, ...) {
  UseMethod('as.naaccr_record')
}


#' @rdname as.naaccr_record
#' @export
as.naaccr_record.list <- function(x, keep_unknown = FALSE, ...) {
  x_df <- as.data.frame(x, stringsAsFactors = FALSE)
  as.naaccr_record(x_df)
}


#' @noRd
type_converters <- list(
  integer      = as.integer,
  numeric      = as.numeric,
  character    = clean_text,
  age          = clean_age,
  icd_code     = clean_icd_code,
  postal       = clean_postal,
  city         = clean_address_city,
  address      = clean_address_number_and_street,
  facility     = clean_facility_id,
  census_block = clean_census_block,
  census_tract = clean_census_tract,
  icd_9        = clean_icd_9_cm,
  county       = clean_county_fips,
  physician    = clean_physician_id,
  override     = naaccr_override,
  sentineled   = as.numeric,
  boolean01    = naaccr_boolean,
  telephone    = clean_telephone,
  count        = clean_count,
  ssn          = clean_ssn,
  boolean12    = function(x) naaccr_boolean(x, false_value = '1'),
  Date         = function(x) as.Date(x, format = '%Y%m%d'),
  datetime     = function(x) {
    x <- stri_trim_both(x)
    x <- stri_pad_right(x, width = 14L, pad = "0", use_length = TRUE)
    as.POSIXct(x, format = "%Y%m%d%H%M%S")
  }
)


#' @rdname as.naaccr_record
#' @import data.table
#' @export
as.naaccr_record.data.frame <- function(x, keep_unknown = FALSE, ...) {
  all_items <- naaccr_format[
    list(name = names(x)),
    on = "name",
    .SD[1],
    by = "item"
  ]
  record <- as.data.table(x)
  type_columns <- split(all_items[['name']], all_items[['type']])
  sent_types <- c("sentineled_numeric", "sentineled_integer")
  type_columns[["sentineled"]] <- unlist(type_columns[sent_types])
  type_columns[sent_types] <- NULL
  simple_types <- setdiff(
    names(type_columns),
    c("factor", "sentineled", "count")
  )
  for (type in simple_types) {
    columns <- intersect(type_columns[[type]], names(record))
    converter_fun <- type_converters[[type]]
    for (column in columns) {
      set(record, j = column, value = converter_fun(record[[column]]))
    }
  }
  for (column in type_columns[["factor"]]) {
    set(
      x     = record,
      j     = column,
      value = naaccr_factor(
        x            = record[[column]],
        field        = column,
        keep_unknown = keep_unknown
      )
    )
  }
  for (column in type_columns[["sentineled"]]) {
    flag_column <- paste0(column, "Flag")
    if (flag_column %in% names(record)) {
      warning(flag_column, " already exists in dataset, will not be overwritten")
    }
    set(
      x     = record,
      j     = c(column, flag_column),
      value = split_sentineled(record[[column]], field = column)
    )
  }
  # Have each "Flag" column following the one it describes
  possible_names <- paste0(
    rep(stri_subset_regex(names(record), "Flag$", negate = TRUE), each = 2),
    c("", "Flag")
  )
  stopifnot(!anyDuplicated(possible_names))
  valid_names <- possible_names[possible_names %in% names(record)]
  setcolorder(record, valid_names)
  record <- setDF(record)
  class(record) <- c('naaccr_record', class(record))
  record
}
