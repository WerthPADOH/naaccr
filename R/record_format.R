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
#' for analysis by the \code{\link{naaccr_record}},
#' \code{\link{as.naaccr_record}} and \code{\link{read_naaccr}} functions.
#' Each row of a \code{record_format} describes how to read and interpret one
#' field.
#'
#' @param name Item name appropriate for a \code{data.frame} column name.
#' @param item NAACCR item number.
#' @param start_col First column of the field in a fixed-width record.
#' @param end_col Last column of the field in a fixed-width record.
#' @param type Name of the column class. See the Field Types section for
#'   predefined types with a default \code{cleaner} and \code{unknown_finder}.
#' @param alignment Alignment of the field in fixed-width files. Either
#'   \code{"left"} (default) or \code{"right"}.
#' @param padding Single-character strings to use for padding in fixed-width
#'   files. Default is a blank (\code{" "}).
#' @param name_literal (Optional) Item name in plain language.
#' @param cleaner (Optional) List of functions to handle special cases of
#'   cleaning field data (e.g., convert all values to uppercase).
#'   Values of \code{NULL} (the default) mean the default cleaning function for
#'   the \code{type} is used.
#'   The value can also be the name of a function to retrieve with
#'   \code{\link[methods:methodUtilities]{getFunction}}.
#'   See Details.
#' @param unknown_finder (Optional) List of functions to detect when codes mean
#'   the actual values are unknown or not applicable.
#'   Values of \code{NULL} (the default) mean the default unknown finding
#'   function for the \code{type} is used.
#'   The value can also be the name of a function to retrieve with
#'   \code{\link[methods:methodUtilities]{getFunction}}.
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
#' To have an unknown finding function change nothing, use \code{\link[base:NA]{is.na}}.
#'
#' See Standard Field Types below for the default cleaning and unknown finding
#' functions for each \code{type}.
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
#' @section How a Record Format is Used:
#'
#'   The \code{\link{naaccr_record}}, \code{\link{read_naaccr}} and
#'   \code{\link{as.naaccr_record}} functions use a record format to determine
#'   how to read, interpret and prepare the data for NAACCR fields.
#'
#'   In general, each field goes through this process:
#'
#'   \enumerate{
#'     \item For \code{read_naaccr}, find the data in the file between
#'       \code{start_col} and \code{end_col}, and read it in as character values.
#'       Otherwise, take the values from the \code{name} column.
#'     \item Apply the \code{cleaner} function and replace the field values with
#'       the result.
#'     \item If \code{keep_unknown} is \code{FALSE} for the function creating
#'       the records data set, apply the \code{unknown_finder} function, and
#'       replace all values that returned \code{TRUE} with \code{NA}.
#'     \item If the field is from a format included with this package and has
#'       the \code{"factor"} type, it will be replaced with the results of
#'       \code{\link{naaccr_factor}}.
#'     \item If the field is from a format included with this package and has
#'       the \code{"sentineled_integer"} or \code{"sentineled_numeric"} type,
#'       it will be replaced with the results of
#'       \code{\link{split_sentineled}} function.
#'   }
#'
#' @section Extending a NAACCR Format:
#'
#'   To define registry-specific fields in addition to the standard fields,
#'   create a \code{record_format} object for the registry-specific fields and
#'   combine it with one of the \link[=naaccr_format]{NAACCR record formats}
#'   provided with the package using \code{rbind}.
#'
#'   Fields with type \code{"factor"} are converted to factors by default if
#'   they are in a format included in this package. If you want to add a new
#'   factor field, define your own \code{cleaner} function to create a
#'   \code{factor} vector from the character values. Also define an
#'   \code{unknown_finder} function to flag which levels stand for "unknown."
#'   Feel free to still use the \code{"factor"} type to help organize your format.
#'
#'   Defining custom fields with the \code{"sentineled_integer"} or
#'   \code{"sentineled_numeric"} types is not as easy. The \code{cleaner}
#'   function should only return a single vector. For now, consider writing your
#'   own function to create \code{naaccr_record} data sets that looks for
#'   sentineled fields and splits their continuous and categorical values into
#'   multiple columns. You can still specify the fields' types as
#'   \code{"sentineled_integer"} and \code{"sentineled_numeric"} to help your
#'   code handle the fields.
#'
#' @section Field Types:
#'
#'   The \code{type} column of a format serves two purposes.
#'   First, it lets users understand and program around the type of data each
#'   field holds.
#'   Second, if the type is one of the default values listed below,
#'   \code{record_format} will replace \code{NULL} values for \code{cleaner} and
#'   \code{unknown_finder} with good defaults.
#'
#'   Note the \code{factor}, \code{sentineled_integer} and
#'   \code{sentineled_numeric} have \dQuote{\enc{naïve}{naive}} default cleaning
#'   and unknown-finding functions. Because each field of those types is very
#'   different from the rest, they are read as simply as possible and then dealt
#'   with individually in \code{as.naaccr_record}.
#'
#'   \tabular{llll}{
#'     Standard type \tab Description \tab Default cleaner \tab Default unknown finder\cr
#'     \code{integer}
#'       \tab Miscellaneous whole number.
#'       \tab \code{\link{as.integer}}
#'       \tab \code{\link{is.na}}\cr
#'     \code{numeric}
#'       \tab Miscellaneous decimal number.
#'       \tab \code{\link{as.numeric}}
#'       \tab \code{\link{is.na}}\cr
#'     \code{character}
#'       \tab Miscellaneous text.
#'       \tab \code{\link{clean_text}}
#'       \tab \code{\link{unknown_text}}\cr
#'     \code{factor}
#'       \tab Categorical values. See \code{\link{naaccr_factor}}.
#'       \tab \code{\link{identity}}
#'       \tab \code{\link{is.na}}\cr
#'     \code{sentineled_integer}
#'       \tab Mix of integer and categorical values. See \code{\link{split_sentineled}}.
#'       \tab \code{\link{identity}}
#'       \tab \code{\link{is.na}}\cr
#'     \code{sentineled_numeric}
#'       \tab Mix of numeric and categorical values. See \code{\link{split_sentineled}}.
#'       \tab \code{\link{identity}}
#'       \tab \code{\link{is.na}}\cr
#'     \code{age}
#'       \tab Age in years.
#'       \tab \code{\link{clean_age}}
#'       \tab \code{\link{unknown_age}}\cr
#'     \code{icd_code}
#'       \tab ICD-9 or ICD-10 code.
#'       \tab \code{\link{clean_icd_code}}
#'       \tab \code{\link{unknown_icd_code}}\cr
#'     \code{postal}
#'       \tab Postal code for an address (a.k.a. ZIP code in the United States).
#'       \tab \code{\link{clean_postal}}
#'       \tab \code{\link{unknown_postal}}\cr
#'     \code{city}
#'       \tab City name.
#'       \tab \code{\link{clean_address_city}}
#'       \tab \code{\link{unknown_address_city}}\cr
#'     \code{address}
#'       \tab Street number and street name parts of an address.
#'       \tab \code{\link{clean_address_number_and_street}}
#'       \tab \code{\link{unknown_address_number_and_street}}\cr
#'     \code{facility}
#'       \tab Facility ID number.
#'       \tab \code{\link{clean_facility_id}}
#'       \tab \code{\link{unknown_facility_id}}\cr
#'     \code{census_block}
#'       \tab Census Block ID number.
#'       \tab \code{\link{clean_census_block}}
#'       \tab \code{\link{unknown_census_block}}\cr
#'     \code{census_tract}
#'       \tab Census Tract ID number.
#'       \tab \code{\link{clean_census_tract}}
#'       \tab \code{\link{unknown_census_tract}}\cr
#'     \code{icd_9}
#'       \tab ICD-9-CM code.
#'       \tab \code{\link{clean_icd_9_cm}}
#'       \tab \code{\link{unknown_icd_9_cm}}\cr
#'     \code{county}
#'       \tab County FIPS code.
#'       \tab \code{\link{clean_county_fips}}
#'       \tab \code{\link{unknown_county_fips}}\cr
#'     \code{physician}
#'       \tab Physician ID number.
#'       \tab \code{\link{clean_physician_id}}
#'       \tab \code{\link{unknown_physician_id}}\cr
#'     \code{override}
#'       \tab Field describing why another field's value was over-ridden.
#'       \tab \code{\link{naaccr_override}}
#'       \tab \code{\link{is.na}}\cr
#'     \code{boolean01}
#'       \tab True/false, where \code{"0"} means false and \code{"1"} means true.
#'       \tab \code{\link{naaccr_boolean}}
#'       \tab \code{\link{is.na}}\cr
#'     \code{telephone}
#'       \tab 10-digit telephone number.
#'       \tab \code{\link{clean_telephone}}
#'       \tab \code{\link{unknown_telephone}}\cr
#'     \code{count}
#'       \tab Integer count.
#'       \tab \code{\link{clean_count}}
#'       \tab \code{\link{unknown_count}}\cr
#'     \code{ssn}
#'       \tab Social Security Number.
#'       \tab \code{\link{clean_ssn}}
#'       \tab \code{\link{unknown_ssn}}\cr
#'     \code{boolean12}
#'       \tab True/false, where \code{"1"} means false and \code{"2"} means true.
#'       \tab \code{\link{naaccr_boolean}}
#'       \tab \code{\link{is.na}}\cr
#'     \code{Date}
#'       \tab NAACCR-formatted date (YYYYMMDD).
#'       \tab \code{\link{naaccr_date}}
#'       \tab \code{\link{is.na}}\cr
#'     \code{datetime}
#'       \tab NAACCR-formatted datetime (YYYYMMDDHHMMSS)
#'       \tab \code{\link{naaccr_datetime}}
#'       \tab \code{\link{is.na}}
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
#'   # Define a custom factor field
#'   test_factor <- function(x) {
#'     ordered(x, c("0", "1", "2", "9"), c("negative", "low", "high", "unknown"))
#'   }
#'   test_unknown <- function(x) {
#'     is.na(x) | x == "unknown"
#'   }
#'   factor_fmt <- record_format(
#'     name           = "testResult",
#'     item           = 2700,
#'     start_col      = 2195,
#'     end_col        = 2195,
#'     type           = "factor",
#'     cleaner        = list(test_factor),
#'     unknown_finder = list(test_unknown)
#'   )
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
    need_by_type <- split(which(need_fun), fmt[["type"]][need_fun])
    need_by_type[lengths(need_by_type) == 0L] <- NULL
    for (tt in names(need_by_type)) {
      need_indices <- need_by_type[[tt]]
      default <- type_converters[list(type = tt), on = "type"][[fun_col]][[1L]]
      if (is.null(default)) {
        default <- list(identity)
      }
      default_list <- rep_len(list(default), length(need_indices))
      mem_addr <- vapply(default_list, address, character(1))
      stopifnot(all(mem_addr == mem_addr[1]))
      # Fill in field_width for functions that need it
      def_args <- formals(default)
      if ("field_width" %in% names(def_args)) {
        widths <- fmt[["end_col"]][need_indices] - fmt[["start_col"]][need_indices] + 1L
        default_list <- lapply(
          X = widths,
          FUN = function(w) {
            def_args[["field_width"]] <- w
            formals(default) <- def_args
            default
          }
        )
      }
      set(x = fmt, i = need_indices, j = fun_col, value = default_list)
    }
  }
  setattr(fmt, "class", c("record_format", class(fmt)))
  fmt
}


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
  if (length(extra_cols) > 0L) {
    set(x = fmt, j = extra_cols, value = xlist[extra_cols])
  }
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
#' @name naaccr_format
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
