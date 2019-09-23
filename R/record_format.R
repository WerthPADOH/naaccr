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


#' Define custom fields for NAACCR records
#'
#' Create a \code{record_format} object, which is used to read NAACCR records.
#'
#' To define registry-specific fields in addition to the standard fields, create
#' a \code{record_format} object for the registry-specific fields and combine it
#' with one of the formats provided with the package using \code{rbind}.
#'
#' @param name Item name appropriate for a \code{data.frame} column name.
#' @param item NAACCR item number.
#' @param start_col First column of the field in a fixed-width record.
#' @param end_col Last column of the field in a fixed-width record.
#' @param type Name of the column class.
#' @param alignment Alignment of the field in fixed-width files. Either
#'   \code{"left"} (default) or \code{"right"}.
#' @param padding Single-character strings to use for padding in fixed-width
#'   files.
#' @param name_literal (Optional) Item name in plain language.
#' @param x Object to be coerced to a \code{record_format}, usually a
#'   \code{data.frame} or \code{list}.
#' @param ... Other arguments passed to \code{record_format}.
#'
#' @return An object of class \code{"record_format"} which has the following
#'   columns:
#'   \describe{
#'     \item{\code{name}}{
#'       (\code{character}) XML field name.
#'     }
#'     \item{\code{item}}{
#'       (\code{integer}) Field item number.
#'     }
#'     \item{\code{start_col}}{
#'       (\code{integer}) First column of the field in a fixed-width text file.
#'     }
#'     \item{\code{end_col}}{
#'       (\code{integer}) Last column of the field in a fixed-width text file.
#'     }
#'     \item{\code{type}}{
#'       (\code{character}) R class for the column vector.
#'     }
#'     \item{\code{alignment}}{
#'       (\code{character}) Alignment of the field's values in a fixed-width
#'       text file.
#'     }
#'     \item{\code{padding}}{
#'       (\code{character}) String used for padding field values in a
#'       fixed-width text file.
#'     }
#'     \item{\code{name_literal}}{
#'       (\code{character}) Field name in plain language.
#'     }
#'   }
#'
#' @section Format Types:
#'
#'   The levels \code{type} can take, along with the functions used to process
#'   them when reading a file:
#'
#'   \describe{
#'     \item{\code{address}}{
#'       (\code{\link{clean_address_number_and_street}})
#'       Street number and street name parts of an address.
#'     }
#'     \item{\code{age}}{
#'       (\code{\link{clean_age}})
#'       Age in years.
#'     }
#'     \item{\code{boolean01}}{
#'       (\code{\link{naaccr_boolean}}, with \code{false_value = "0"})
#'       True/false, where \code{"0"} means false and \code{"1"} means true.
#'     }
#'     \item{\code{boolean12}}{
#'       (\code{\link{naaccr_boolean}}, with \code{false_value = "1"})
#'       True/false, where \code{"1"} means false and \code{"2"} means true.
#'     }
#'     \item{\code{census_block}}{
#'       (\code{\link{clean_census_block}})
#'       Census Block ID number.
#'     }
#'     \item{\code{census_tract}}{
#'       (\code{\link{clean_census_tract}})
#'       Census Tract ID number.
#'     }
#'     \item{\code{character}}{
#'       (\code{\link{clean_text}})
#'       Miscellaneous text.
#'     }
#'     \item{\code{city}}{
#'       (\code{\link{clean_address_city}})
#'       City name.
#'     }
#'     \item{\code{count}}{
#'       (\code{\link{clean_count}})
#'       Integer count.
#'     }
#'     \item{\code{county}}{
#'       (\code{\link{clean_county_fips}})
#'       County FIPS code.
#'     }
#'     \item{\code{Date}}{
#'       (\code{\link{as.Date}}, with \code{format = "%Y%m%d"})
#'       NAACCR-formatted date (YYYYMMDD).
#'     }
#'     \item{\code{datetime}}{
#'       (\code{\link{as.POSIXct}}, with \code{format = "%Y%m%d%H%M%S"})
#'       NAACCR-formatted datetime (YYYYMMDDHHMMSS)
#'     }
#'     \item{\code{facility}}{
#'       (\code{\link{clean_facility_id}})
#'       Facility ID number.
#'     }
#'     \item{\code{icd_9}}{
#'       (\code{\link{clean_icd_9_cm}})
#'       ICD-9-CM code.
#'     }
#'     \item{\code{icd_code}}{
#'       (\code{\link{clean_icd_code}})
#'       ICD-9 or ICD-10 code.
#'     }
#'     \item{\code{integer}}{
#'       (\code{\link{as.integer}})
#'       Miscellaneous whole number.
#'     }
#'     \item{\code{numeric}}{
#'       (\code{\link{as.numeric}})
#'       Miscellaneous decimal number.
#'     }
#'     \item{\code{override}}{
#'       (\code{\link{naaccr_override}})
#'       Field describing why another field's value was over-ridden.
#'     }
#'     \item{\code{physician}}{
#'       (\code{\link{clean_physician_id}})
#'       Physician ID number.
#'     }
#'     \item{\code{postal}}{
#'       (\code{\link{clean_postal}})
#'       Postal code for an address (a.k.a. ZIP code in the United States).
#'     }
#'     \item{\code{ssn}}{
#'       (\code{\link{clean_ssn}})
#'       Social Security Number.
#'     }
#'     \item{\code{telephone}}{
#'       (\code{\link{clean_telephone}})
#'       10-digit telephone number.
#'     }
#'   }
#'
#' @examples
#'   my_fields <- record_format(
#'     name      = c("foo", "bar"),
#'     item      = c(2163, 1180),
#'     start_col = c(975, 1381),
#'     end_col   = c(975, 1435),
#'     type      = c("numeric", "facility")
#'   )
#'   my_format <- rbind(naaccr_format_16, my_fields)
#' @import data.table
#' @export
record_format <- function(name,
                          item,
                          start_col,
                          end_col,
                          type,
                          alignment    = "left",
                          padding      = " ",
                          name_literal = NULL) {
  # Allow 0-row formats, because why not?
  n_rows <- max(
    length(name), length(item), length(start_col), length(end_col),
    length(type), length(name_literal)
  )
  if (n_rows == 0L) {
    alignment    <- character(0L)
    padding      <- character(0L)
    name_literal <- character(0L)
  } else if (is.null(name_literal)) {
    name_literal <- NA_character_
  }
  # Check for valid values
  alignment <- as.character(alignment)
  not_left_right <- !(alignment %in% c("left", "right"))
  if (any(not_left_right, na.rm = TRUE)) {
    stop("'alignment' must only contain values of \"left\" or \"right\"")
  }
  padding   <- as.character(padding)
  padding_width <- nchar(padding)
  if (any(padding_width > 1L, na.rm = TRUE)) {
    stop("'padding' must only contain single-character values")
  }
  # Create the format
  fmt <- data.table(
    name         = as.character(name),
    item         = as.integer(item),
    start_col    = as.integer(start_col),
    end_col      = as.integer(end_col),
    alignment    = as.character(alignment),
    type         = factor(as.character(type), sort(names(type_converters))),
    padding      = as.character(padding),
    name_literal = as.character(name_literal)
  )
  if (anyNA(fmt[["type"]])) {
    stop(
      "'type' must be one of ",
      paste0("'", levels(fmt[["type"]]), "'", collapse = ", ")
    )
  }
  setattr(fmt, "class", c("record_format", class(fmt)))
  fmt
}


#' @inheritParams record_format
#' @rdname record_format
as.record_format <- function(x, ...) {
  if (inherits(x, "record_format")) {
    return(x)
  }
  xlist <- as.list(x)
  xlist <- utils::modifyList(xlist, list(...), keep.null = TRUE)
  call_args <- args(record_format)
  arg_names <- names(as.list(call_args))
  arg_names <- arg_names[nzchar(arg_names)]
  do.call(record_format, xlist[arg_names])
}


#' @noRd
rbind.record_format <- function(..., stringsAsFactors = FALSE) {
  combined <- rbindlist(list(...))
  as.record_format(combined)
}


#' Field definitions from all NAACCR format versions
#'
#' A \code{data.table} object defining the fields for each version of NAACCR's
#' fixed-width record file format.
#'
#' @description See \code{\link{record_format}}.
#'
#' @rdname naaccr_format
"naaccr_format_12"

#' @rdname naaccr_format
"naaccr_format_13"

#' @rdname naaccr_format
"naaccr_format_14"

#' @rdname naaccr_format
"naaccr_format_15"

#' @rdname naaccr_format
"naaccr_format_16"

#' @rdname naaccr_format
"naaccr_format_18"
