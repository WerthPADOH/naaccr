#' NAACCR record table class
#' Subclass of \code{data.frame} for working with NAACCR records
#' @param input Either a string with a file name (containing no \code{\\n}
#'   character), a \code{\link[base]{connection}} object, or the text records
#'   themselves as a character vector.
#' @param ... Arguments of the form \code{tag = value}, where \code{tag} is a
#'   valid NAACCR data item name and \code{value} is the vector of the item's
#'   values.
#' @param naaccr_version An integer specifying which NAACCR format should be
#'   used to parse the records. Only used if \code{input} is given.
#' @export
naaccr_record <- function(input, ..., naaccr_version = NULL) {
  if (is.null(naaccr_version)) {
    naaccr_version <- max(naaccr_items[['naaccr_version']])
  }
  input_data <- if (!missing(input)) {
    read_naaccr(input, naaccr_version)
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


#' @rdname as.naaccr_record
#' @export
as.naaccr_record.data.frame <- function(x, ...) {
  latest_items <- naaccr_items[naaccr_version == max(naaccr_version)]
  normalized_names <- gsub('[^a-z0-9]+', ' ', tolower(names(x)))
  matched_items    <- latest_items[normalized_names, on = 'matching_name']
  record <- as.data.table(x)
  setnames(record, matched_items[['r_name']])
  missing_columns <- setdiff(latest_items[['r_name']], names(record))
  set(
    record,
    i     = NULL,
    j     = missing_columns,
    value = rep(NA_character_, nrow(record))
  )
  class(record) <- c('naaccr_record', class(record))
  record
}
