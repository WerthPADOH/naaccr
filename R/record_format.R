#' @noRd
naaccr_boolean12 <- function(x) naaccr_boolean(x, false_value = '1')


#' Wrapper setting keep_unknown = TRUE for cleaner functions
#' @noRd
keep_unknown <- function(fun) {
  fun_args <- formals(fun)
  fun_args[["keep_unknown"]] <- TRUE
  formals(fun) <- fun_args
  fun
}


#' Default cleaner and unknown finder functions for each field type
#' See the docs of record_format below for details
#' @noRd
type_converters <- rbindlist(list(
  list(type = "integer", cleaner = list(as.integer), unknown_finder = list(is.na)),
  list(type = "numeric", cleaner = list(as.numeric), unknown_finder = list(is.na)),
  list(type = "character", cleaner = list(keep_unknown(clean_text)), unknown_finder = list(unknown_text)),
  list(type = "factor", cleaner = list(identity), unknown_finder = list(is.na)),
  list(type = "sentineled_integer", cleaner = list(identity), unknown_finder = list(is.na)),
  list(type = "sentineled_numeric", cleaner = list(identity), unknown_finder = list(is.na)),
  list(type = "age", cleaner = list(keep_unknown(clean_age)), unknown_finder = list(unknown_age)),
  list(type = "icd_code", cleaner = list(keep_unknown(clean_icd_code)), unknown_finder = list(unknown_icd_code)),
  list(type = "postal", cleaner = list(keep_unknown(clean_postal)), unknown_finder = list(unknown_postal)),
  list(type = "city", cleaner = list(keep_unknown(clean_address_city)), unknown_finder = list(unknown_address_city)),
  list(type = "address", cleaner = list(keep_unknown(clean_address_number_and_street)), unknown_finder = list(unknown_address_number_and_street)),
  list(type = "facility", cleaner = list(keep_unknown(clean_facility_id)), unknown_finder = list(unknown_facility_id)),
  list(type = "census_block", cleaner = list(keep_unknown(clean_census_block)), unknown_finder = list(unknown_census_block)),
  list(type = "census_tract", cleaner = list(keep_unknown(clean_census_tract)), unknown_finder = list(unknown_census_tract)),
  list(type = "icd_9", cleaner = list(keep_unknown(clean_icd_9_cm)), unknown_finder = list(unknown_icd_9_cm)),
  list(type = "county", cleaner = list(keep_unknown(clean_county_fips)), unknown_finder = list(unknown_county_fips)),
  list(type = "physician", cleaner = list(keep_unknown(clean_physician_id)), unknown_finder = list(unknown_physician_id)),
  list(type = "override", cleaner = list(naaccr_override), unknown_finder = list(is.na)),
  list(type = "boolean01", cleaner = list(naaccr_boolean), unknown_finder = list(is.na)),
  list(type = "telephone", cleaner = list(keep_unknown(clean_telephone)), unknown_finder = list(unknown_telephone)),
  list(type = "count", cleaner = list(keep_unknown(clean_count)), unknown_finder = list(unknown_count)),
  list(type = "ssn", cleaner = list(keep_unknown(clean_ssn)), unknown_finder = list(unknown_ssn)),
  list(type = "boolean12", cleaner = list(naaccr_boolean12), unknown_finder = list(is.na)),
  list(type = "Date", cleaner = list(naaccr_date), unknown_finder = list(is.na)),
  list(type = "datetime", cleaner = list(naaccr_datetime), unknown_finder = list(is.na))
))


#' Define custom fields for NAACCR records
#'
#' Create a \code{record_format} object, which is used to prepare NAACCR records
#' for analysis. Each row of a \code{record_format} describes how to read and
#' interpret one field.
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
#' @param cleaner (Optional) List of functions to handle special cases of
#'   cleaning field data (e.g., convert all values to uppercase).
#'   Values of \code{NULL} (the default) mean the default cleaning function for
#'   the \code{type} is used.
#'   See Details.
#' @param unknown_finder (Optional) List of functions to detect when codes mean
#'   the actual values are unknown or not applicable.
#'   Values of \code{NULL} (the default) mean the default unknown finding
#'   function for the \code{type} is used.
#'   See Details.
#' @param x Object to be coerced to a \code{record_format}, usually a
#'   \code{data.frame} or \code{list}.
#' @param ... Other arguments passed to \code{record_format}.
#'
#' The functions in \code{cleaner} and \code{unknown_finder} should each accept
#' a character vector of values from their respective fields and return a vector
#' with the same length as the input.
#' The vector returned by a \code{cleaner} function can be of any class and
#' should be easy to use in an analysis.
#' To have a cleaning or function change nothing, use \code{\link[base]{identity}}.
#' To have an unknown finding function change nothing, use \code{\link[base]{is.na}}.
#'
#' See Standard Field Types below for the default cleaning and unknown finding
#' functions for each \code{type}.
#'
#' @section Extending a NAACCR Format:
#'
#'   To define registry-specific fields in addition to the standard fields,
#'   create a \code{record_format} object for the registry-specific fields and
#'   combine it with one of the \link{naaccr_format}{NAACCR record formats}
#'   provided with the package using \code{rbind}.
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
#'     \item{\code{cleaner}}{
#'       (\code{list} of \code{function} objects) Function to prepare the
#'       field's values for analysis.
#'     }
#'     \item{\code{unknown_finder}}{
#'       (\code{list} of \code{function} objects) Function to detect codes
#'       meaning the actual values are missing or unknown for the field.
#'     }
#'   }
#'
#'   The object returned by \code{as.record_format} will also have any extra
#'   information from \code{x}. For example, if \code{x} is a \code{list},
#'   elements beyond the columns listed above will be an additional column in
#'   the output.
#'
#' @section Standard Field Types:
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
#' @seealso \code{\link{cleaners}}
#' @examples
#'   # Add custom fields to a standard format
#'   # record_format objects use the data.table method for rbind
#'   my_fields <- record_format(
#'     name      = c("foo", "bar"),
#'     item      = c(2163, 1180),
#'     start_col = c(975, 1381),
#'     end_col   = c(975, 1435),
#'     type      = c("numeric", "facility")
#'   )
#'   my_format <- rbind(naaccr_format_16, my_fields, fill = TRUE)
#'
#'   # Convert an object with format details to a record_format
#'   rough_format <- list(
#'     name = c("bizz", "bang"),
#'     item = c("888", "999"),
#'     start_col = c(200.0, 300.0),
#'     end_col = c(205, 305),
#'     type = "numeric",
#'     padding = 0
#'   )
#'   safe_format <- as.record_format(rough_format)
#'   str(rough_format)
#'   str(safe_format)
#' @import data.table
#' @importFrom methods formalArgs
#' @export
record_format <- function(name,
                          item,
                          start_col,
                          end_col,
                          type,
                          alignment = NULL,
                          padding = NULL,
                          cleaner = NULL,
                          unknown_finder = NULL,
                          name_literal = NULL) {
  # Allow 0-row formats, because why not?
  n_rows <- max(
    length(name), length(item), length(start_col), length(end_col),
    length(type), length(alignment), length(padding), length(name_literal)
    ,
    length(cleaner)
  )
  if (n_rows == 0L) {
    alignment <- character(0L)
    padding <- character(0L)
    name_literal <- character(0L)
    cleaner <- list()
    unknown_finder <- list()
  } else {
    if (is.null(alignment)) alignment <- rep_len("left", n_rows)
    if (is.null(padding)) padding <- rep_len(" ", n_rows)
    if (is.null(name_literal)) name_literal <- rep_len(NA_character_, n_rows)
    if (is.null(cleaner)) cleaner <- vector("list", n_rows)
    if (is.null(unknown_finder)) unknown_finder <- vector("list", n_rows)
  }
  padding <- as.character(padding)
  padding_width <- nchar(padding)
  if (any(padding_width > 1L, na.rm = TRUE)) {
    stop("'padding' must only contain single-character values")
  }
  # Create the format
  fmt <- data.table(
    name = as.character(name),
    item = as.integer(item),
    start_col = as.integer(start_col),
    end_col = as.integer(end_col),
    type = factor(as.character(type), sort(type_converters[["type"]])),
    alignment = factor(as.character(alignment), c("left", "right")),
    padding = as.character(padding),
    cleaner = as.list(cleaner),
    unknown_finder = as.list(unknown_finder),
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
  for (fun_col in c("cleaner", "unknown_finder")) {
    need_fun <- vapply(fmt[[fun_col]], is.null, logical(1L))
    if (any(need_fun)) {
      types <- fmt[["type"]][need_fun]
      defaults <- type_converters[list(type = types), on = "type"][[fun_col]]
      no_default <- vapply(defaults, is.null, logical(1L))
      defaults[no_default] <- list(identity)
      # Fill in field_width for functions that need it
      for (ii in seq_along(defaults)) {
        d_fun <- defaults[[ii]]
        d_args <- formals(d_fun)
        if ("field_width" %in% names(d_args)) {
          d_args[["field_width"]] <- fmt[["end_col"]][ii] - fmt[["start_col"]][ii] + 1L
          formals(d_fun) <- d_args
          defaults[[ii]] <- d_fun
        }
      }
      set(x = fmt, i = which(need_fun), j = fun_col, value = defaults)
    }
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
