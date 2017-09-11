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


parse_records <- function(records, start_cols, end_cols, col_names = NULL) {
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
      values <- stringi::stri_sub(records, starts, ends)
      stringi::stri_subset_regex(values, "^\\s+") <- NA
      values
    },
    SIMPLIFY = FALSE
  )
  names(item_matrix) <- col_names
  as.data.frame(item_matrix, stringsAsFactors = FALSE)
}


#' Read records from a NAACCR file
#' @param input Either a string with a file name (containing no \code{\\n}
#'   character), a \code{\link[base]{connection}} object, or the text records
#'   themselves as a character vector.
#' @param naaccr_version An integer specifying which NAACCR format should be
#'   used to parse the records.
#' @return A \code{data.frame} of the records.
#' @import data.table
#' @import stringi
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
  ][
    order(start_col)
  ][
    start_col > cummax(data.table::shift(end_col, fill = 0L))
  ]
  # Read all record types as the longest type, with padding
  record_lines <- readLines(input)
  line_lengths <- nchar(record_lines)
  record_lines <- stringi::stri_pad_right(
    record_lines,
    width = max(line_lengths) - line_lengths
  )
  parse_records(
    records    = record_lines,
    start_cols = input_items[["start_col"]],
    end_cols   = input_items[["end_col"]],
    col_names  = input_items[["r_name"]]
  )
}
