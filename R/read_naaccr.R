#' Create a connection specified in one of several ways
#' @param input Either a string with a file name (containing no \code{\\n}
#'   character), a \code{\link[base]{connection}} object, or the text records
#'   themselves as a character vector.
#' @return A \code{connection} object
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
  if (!isOpen(input, 'rt')) {
    open(input, 'rt')
  }
  input
}


#' Read records from a NAACCR file
#' @param input Either a string with a file name (containing no \code{\\n}
#'   character), a \code{\link[base]{connection}} object, or the text records
#'   themselves as a character vector.
#' @param naaccr_version An integer specifying which NAACCR format should be
#'   used to parse the records.
#' @return A \code{data.frame} of the records.
#' @import readr
#' @import data.table
read_naaccr <- function(input, naaccr_version = NULL) {
  input <- as.connection(input)
  on.exit(
    if (isOpen(input)) close(input),
    add = TRUE
  )
  if (is.null(naaccr_version)) {
    naaccr_version <- max(naaccr_items[['naaccr_version']])
  }
  # NAACCR record types differ in line length
  line1 <- readLines(input, 1L)
  line_length <- nchar(line1)
  lookup_key <- list(naaccr_version)
  input_items <- naaccr_items[
    lookup_key,
    on = 'naaccr_version'
  ][
    end_col <= line_length
  ][
    order(start_col)
  ]

  col_positions <- input_items[
    start_col > cummax(data.table::shift(end_col, fill = 0L)),
    readr::fwf_positions(
      start     = start_col,
      end       = end_col,
      col_names = r_name
    )
  ]
  pushBack(input, line1)
  readr::read_fwf(
    file          = input,
    col_positions = col_positions,
    col_types     = readr::cols(.default = readr::col_character()),
    na            = ''
  )
}
