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
#' @param name_literal (Optional) Item name in plain language.
#'
#' @return An object of class \code{"record_format"} which has the columns
#'   \code{number}, \code{start_col}, and \code{end_col} (all integer vectors).
#' @examples
#'   my_fields <- record_format(
#'     xml_name  = c("foo", "bar")
#'     item      = c(2163, 1180),
#'     start_col = c(975, 1381),
#'     end_col   = c(975, 1435)
#'   )
#'   my_format <- rbind(naaccr_version_16, my_fields)
#' @import data.table
#' @export
record_format <- function(name,
                          item,
                          start_col,
                          end_col,
                          type,
                          name_literal = NULL) {
  record_format <- data.table(
    name         = as.character(name),
    item         = as.integer(item),
    start_col    = as.integer(start_col),
    end_col      = as.integer(end_col),
    type         = as.character(type),
    name_literal = as.character(name_literal)
  )
  setattr(record_format, "class", c("record_format", class(record_format)))
  record_format
}


#' @param x Object to be coerced to a \code{record_format), usually a
#'   \code{data.frame) or \code{list).
#' @rdname record_format
as.record_format <- function(x, ...) {
  if (inherits(x, "record_format")) {
    return(x)
  }
  xlist <- as.list(x)
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
#' A \code{data.table) defining the fields for all versions of NAACCR's
#' fixed-width record file format.
#'
#' Columns:
#' \describe{
#'   \item{\code{name)}{(\code{character) XML item name.}
#'   \item{\code{item)}{(\code{integer)) Item number.}
#'   \item{\code{start_col)}{(\code{integer)) First column of the field.}
#'   \item{\code{end_col)}{(\code{integer)) Last column of the field.}
#'   \item{\code{name_literal)}{(\code{character)) Item name in plain language.}
#' }
#'
#' @format A \code{data.table) with 3,281 rows and 6 columns.
#' @rdname naaccr_format
#' @export
naaccr_format <- readRDS("inst/extdata/naaccr_format.rds")[
  ,
  as.record_format(.SD),
  keyby = "version"
]

