#' Create a connection specified in one of several ways
#' @param input Either a string with a file name (containing no \code{\\n}
#'   character), a \code{\link[base]{connection}} object, or the text records
#'   themselves as a character vector.
#' @return An open \code{connection} object
#' @seealso
#'   \code{\link[base]{connections}},
#'   \code{\link[base]{textConnections}}
as.connection <- function(input) {
  # Based on logic in utils::read.table
  if (is.character(input)) {
    input <- if (length(input) > 1L || grepl('\n', input[1L], fixed = TRUE)) {
      textConnection(input)
    } else {
      file(input, 'rt')
    }
  }
  if (!inherits(input, 'connection')) {
    stop("'input' must be a filepath, a connection, or a character vector")
  }
  if (!isOpen(input, 'read')) {
    open(input, 'rt')
  }
  input
}


#' Split record lines into fields
#' @param record_lines Character vector of entire NAACCR record lines.
#' @param start_cols   Integer vector of the first index of fields in the
#'   records. Must be the same length as \code{end_cols}.
#' @param end_cols     Integer vector of the last index of fields in the
#'   records. Must be the same length as \code{start_cols}.
#' @param col_names    Character vector of field names.  Must be the same length
#'   as \code{start_cols}.
#' @return A \code{data.frame} with the columns specified by \code{start_cols},
#'   \code{end_cols}, and \code{col_names}. All columns are character vectors,
#'   and values of just spaces in the records are replaced with \code{NA}.
#' @noRd
parse_records <- function(record_lines,
                          start_cols,
                          end_cols,
                          col_names = NULL) {
  if (length(start_cols) != length(end_cols)) {
    stop("start_cols and end_cols must be the same length")
  }
  if (!is.null(col_names) && length(start_cols) != length(col_names)) {
    stop("start_cols and end_cols must be the same length")
  }
  item_matrix <- mapply(
    starts = start_cols,
    ends   = end_cols,
    FUN = function(starts, ends) {
      values <- stringi::stri_sub(record_lines, starts, ends)
      stringi::stri_subset_regex(values, "^\\s+") <- NA
      values
    },
    SIMPLIFY = FALSE
  )
  names(item_matrix) <- col_names
  as.data.table(item_matrix, stringsAsFactors = FALSE)
}


#' Updated field names to newest version
#' @param old_names Character vector column names from any NAACCR version.
#' @return A character vector the same length as \code{old_names} of the names
#'   from the most recent NAACCR format.
#' @import data.table
#' @noRd
name_recent <- function(old_names) {
  named_items <- naaccr_items[
    list(r_name = old_names),
    list(item = item[[1L]]),
    on      = "r_name",
    nomatch = NA,
    by      = .EACHI
  ]

  naaccr_items[
    naaccr_version == max(naaccr_version)
  ][
    list(item = named_items[["item"]]),
    r_name,
    on      = "item",
    nomatch = NA
  ]
}


#' Read records from a NAACCR file
#' @param input Either a string with a file name (containing no \code{\\n}
#'   character), a \code{\link[base]{connection}} object, or the text records
#'   themselves as a character vector.
#' @param naaccr_version An integer specifying which NAACCR format should be
#'   used to parse the records.
#' @return A \code{data.frame} of the records. The columns included depend on
#'   the NAACCR record format version. All columns are character vectors.
#' @import data.table
#' @import stringi
#' @export
read_naaccr <- function(input, naaccr_version = NULL) {
  if (!inherits(input, "connection")) {
    input <- as.connection(input)
    on.exit(
      if (isOpen(input)) close(input),
      add = TRUE
    )
  }
  if (is.null(naaccr_version)) {
    naaccr_version <- max(naaccr_items[['naaccr_version']])
  }
  lookup_key <- list(naaccr_version)
  input_items <- naaccr_items[
    lookup_key,
    on = 'naaccr_version'
  ]
  # Read all record types as the longest type, with padding
  record_lines <- readLines(input)
  line_lengths <- nchar(record_lines)
  record_lines <- stringi::stri_pad_right(
    record_lines,
    width = max(line_lengths) - line_lengths
  )
  records <- parse_records(
    record_lines = record_lines,
    start_cols   = input_items[["start_col"]],
    end_cols     = input_items[["end_col"]],
    col_names    = as.character(input_items[["item"]])
  )
  setDT(records)
  setnames(records, name_recent(names(records)))
  records
}
