#' @noRd
naaccr_boolean12 <- function(x) naaccr_boolean(x, false_value = '1')


#' Wrapper to create "keep unknown" versions of functions
#' @noRd
keep_unknown <- function(fun) {
  formals(fun)[["keep_unknown"]] <- TRUE
  fun
}


#' `type`: name of the field type (see record_format)
#' `fun`: normal function used to parse the field (factors and sentinels are
#'   special).
#' `fun_unknown`: function used to parse the field when `keep_unknown = TRUE`
#'   for the reading/parsing function.
#' @noRd
type_converters <- rbindlist(list(
  list(type = "integer", fun = list(as.integer), fun_unknown = list(as.integer)),
  list(type = "numeric", fun = list(as.numeric), fun_unknown = list(as.numeric)),
  list(type = "character", fun = list(clean_text), fun_unknown = list(keep_unknown(clean_text))),
  list(type = "factor", fun = list(identity), fun_unknown = list(identity)),
  list(type = "sentineled_integer", fun = list(identity), fun_unknown = list(identity)),
  list(type = "sentineled_numeric", fun = list(identity), fun_unknown = list(identity)),
  list(type = "age", fun = list(clean_age), fun_unknown = list(keep_unknown(clean_age))),
  list(type = "icd_code", fun = list(clean_icd_code), fun_unknown = list(keep_unknown(clean_icd_code))),
  list(type = "postal", fun = list(clean_postal), fun_unknown = list(keep_unknown(clean_postal))),
  list(type = "city", fun = list(clean_address_city), fun_unknown = list(keep_unknown(clean_address_city))),
  list(type = "address", fun = list(clean_address_number_and_street), fun_unknown = list(keep_unknown(clean_address_number_and_street))),
  list(type = "facility", fun = list(clean_facility_id), fun_unknown = list(keep_unknown(clean_facility_id))),
  list(type = "census_block", fun = list(clean_census_block), fun_unknown = list(keep_unknown(clean_census_block))),
  list(type = "census_tract", fun = list(clean_census_tract), fun_unknown = list(keep_unknown(clean_census_tract))),
  list(type = "icd_9", fun = list(clean_icd_9_cm), fun_unknown = list(keep_unknown(clean_icd_9_cm))),
  list(type = "county", fun = list(clean_county_fips), fun_unknown = list(keep_unknown(clean_county_fips))),
  list(type = "physician", fun = list(clean_physician_id), fun_unknown = list(keep_unknown(clean_physician_id))),
  list(type = "override", fun = list(naaccr_override), fun_unknown = list(naaccr_override)),
  list(type = "boolean01", fun = list(naaccr_boolean), fun_unknown = list(naaccr_boolean)),
  list(type = "telephone", fun = list(clean_telephone), fun_unknown = list(keep_unknown(clean_telephone))),
  list(type = "count", fun = list(clean_count), fun_unknown = list(keep_unknown(clean_count))),
  list(type = "ssn", fun = list(clean_ssn), fun_unknown = list(keep_unknown(clean_ssn))),
  list(type = "boolean12", fun = list(naaccr_boolean12), fun_unknown = list(naaccr_boolean12)),
  list(type = "Date", fun = list(naaccr_date), fun_unknown = list(naaccr_date)),
  list(type = "datetime", fun = list(naaccr_datetime), fun_unknown = list(naaccr_datetime))
))


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
#'   files. Default is a blank (\code{" "}).
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
#'       (\code{factor}) R class for the column vector.
#'     }
#'     \item{\code{alignment}}{
#'       (\code{factor}) Alignment of the field's values in a fixed-width
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
#'   The object returned by \code{as.record_format} will also have any extra
#'   information from \code{x}. For example, if \code{x} is a \code{list},
#'   elements beyond the columns listed above will be an additional column in
#'   the output.
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
#'       (\code{\link{as.Date}}, with \code{format = "\%Y\%m\%d"})
#'       NAACCR-formatted date (YYYYMMDD).
#'     }
#'     \item{\code{datetime}}{
#'       (\code{\link{as.POSIXct}}, with \code{format = "\%Y\%m\%d\%H\%M\%S"})
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
#'   # Uses the data.table method of rbind
#'   my_format <- rbind(naaccr_format_16, my_fields, fill = TRUE)
#' @import data.table
#' @export
record_format <- function(name,
                          item,
                          start_col,
                          end_col,
                          type,
                          alignment    = NULL,
                          padding      = NULL,
                          name_literal = NULL) {
  # Allow 0-row formats, because why not?
  n_rows <- max(
    length(name), length(item), length(start_col), length(end_col),
    length(type), length(alignment), length(padding), length(name_literal)
  )
  if (n_rows == 0L) {
    alignment    <- character(0L)
    padding      <- character(0L)
    name_literal <- character(0L)
  } else {
    if (is.null(alignment)) alignment <- rep_len("left", n_rows)
    if (is.null(padding)) padding <- rep_len(" ", n_rows)
    if (is.null(name_literal)) name_literal <- rep_len(NA_character_, n_rows)
  }
  padding <- as.character(padding)
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
    type         = factor(as.character(type), sort(type_converters[["type"]])),
    alignment    = factor(as.character(alignment), c("left", "right")),
    padding      = as.character(padding),
    name_literal = as.character(name_literal)
  )
  if (anyNA(fmt[["alignment"]])) {
    stop("'alignment' must only contain values of \"left\" or \"right\"")
  }
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
#' @importFrom utils modifyList
#' @importFrom methods formalArgs
#' @export
as.record_format <- function(x, ...) {
  if (inherits(x, "record_format")) {
    return(x)
  }
  xlist <- as.list(x)
  xlist <- utils::modifyList(xlist, list(...), keep.null = TRUE)
  used_names <- intersect(formalArgs(record_format), names(xlist))
  fmt <- do.call(record_format, xlist[used_names])
  extra_cols <- setdiff(names(xlist), names(fmt))
  set(x = fmt, j = extra_cols, value = xlist[extra_cols])
  fmt
}


#' Field definitions from all NAACCR format versions
#'
#' A \code{\link{record_format}} table defining the fields for each version of
#' NAACCR's fixed-width record file format.
#'
#' @format
#'   \describe{
#'     \item{\code{naaccr_format_12}}{
#'       An object of class \code{record_format} with 509 rows and 17 columns.
#'     }
#'     \item{\code{naaccr_format_13}}{
#'       An object of class \code{record_format} with 529 rows and 17 columns.
#'     }
#'     \item{\code{naaccr_format_14}}{
#'       An object of class \code{record_format} with 529 rows and 17 columns.
#'     }
#'     \item{\code{naaccr_format_15}}{
#'       An object of class \code{record_format} with 536 rows and 17 columns.
#'     }
#'     \item{\code{naaccr_format_16}}{
#'       An object of class \code{record_format} with 587 rows and 17 columns.
#'     }
#'     \item{\code{naaccr_format_18}}{
#'       An object of class \code{record_format} with 791 rows and 17 columns.
#'     }
#'   }
#'
#'   Each table has the usual columns found in any \code{\link{record_format}}
#'   and these additional details:
#'
#'   \describe{
#'     \item{\code{default}}{
#'       (\code{character}) Default value for the field.
#'     }
#'     \item{\code{parent}}{
#'       (\code{character}) Parent XML element for the field, according to the
#'       NAACCR XML format definition.
#'     }
#'     \item{\code{section}}{
#'       (\code{character}) General category of the field.
#'       Possible values include \code{"Demographic"} and \code{"Pathology"}.
#'     }
#'     \item{\code{source}}{
#'       (\code{character}) Organization which defines the field.
#'     }
#'     \item{\code{year_added}}{
#'       (\code{integer}) First year the field was included in a NAACCR format.
#'     }
#'     \item{\code{version_added}}{
#'       (\code{integer}) First NAACCR format version to include the field.
#'     }
#'     \item{\code{year_retired}}{
#'       (\code{integer}) First year the field was no longer included in a
#'       NAACCR format.
#'     }
#'     \item{\code{version_retired}}{
#'       (\code{integer}) First NAACCR format to no longer include the field.
#'     }
#'   }
#'
#' @seealso \code{\link{record_format}}.
#'
#' @rdname naaccr_format
#' @export
"naaccr_format_12"

#' @rdname naaccr_format
#' @export
"naaccr_format_13"

#' @rdname naaccr_format
#' @export
"naaccr_format_14"

#' @rdname naaccr_format
#' @export
"naaccr_format_15"

#' @rdname naaccr_format
#' @export
"naaccr_format_16"

#' @rdname naaccr_format
#' @export
"naaccr_format_18"


#' Internal function for other functions to resolve format
#' @noRd
choose_naaccr_format <- function(version = NULL, format = NULL, keep_fields = NULL) {
  if (is.null(version) && is.null(format)) {
    version <- max(naaccr_format[["version"]])
  } else if (!is.null(version) && !is.null(format)) {
    stop("Specify 'version' or 'format', not both")
  }
  if (!is.null(version)) {
    key_data <- list(version = as.integer(version))
    fmt <- naaccr_format[key_data, on = "version"]
  } else {
    fmt <- format
  }
  if (!is.null(keep_fields)) {
    fmt <- fmt[list(name = as.character(keep_fields)), on = "name"]
  }
  as.record_format(fmt)
}
