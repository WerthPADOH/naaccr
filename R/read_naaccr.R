#' Create a connection specified in one of several ways
#' @param input Either a string with a file name (containing no \code{\\n}
#'   character), a \code{\link[base]{connection}} object, or the
#'   text records themselves as a character vector.
#' @return An open \code{connection} object
#' @seealso
#'   \code{\link[base]{connection}},
#'   \code{\link[base]{textConnection}}
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


#' @param record_lines Character vector of entire NAACCR record lines.
#' @param start_cols   Integer vector of the first index of fields in the
#'   records. Must be the same length as \code{end_cols}.
#' @param end_cols     Integer vector of the last index of fields in the
#'   records. Must be the same length as \code{start_cols}.
#' @param col_names    Character vector of field names.  Must be the same length
#' @return A \code{data.frame} with the columns specified by \code{start_cols},
#'   \code{end_cols}, and \code{col_names}. All columns are character vectors.
#' @noRd
#' @import stringi
#' @import data.table
split_fields <- function(record_lines,
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
    FUN      = stringi::stri_sub,
    from     = start_cols,
    to       = end_cols,
    MoreArgs = list(str = record_lines),
    SIMPLIFY = FALSE
  )
  setDT(item_matrix)
  setnames(item_matrix, col_names)
  for (column in names(item_matrix)) {
    set(
      item_matrix,
      j = column,
      value = stringi::stri_trim_both(item_matrix[[column]])
    )
  }
  item_matrix
}


#' Read NAACCR records
#'
#' Read and parse cancer incidence records according to a NAACCR format.
#' \code{read_naaccr} returns a data set suited for analysis in R, and
#' \code{read_naaccr_plain} returns a data set with the unchanged record values.
#'
#' Anyone who wants to analyze the records in R should use \code{read_naaccr}.
#' In the returned \code{data.frame}, columns are of appropriate classes, coded
#' values are replaced with factors, and unknowns are replaced with \code{NA}.
#'
#' \code{read_naaccr_plain} is a "format strict" way to read incidence records.
#' All values returned are the literal character values from the records.
#' The only processing done is that leading and trailing whitespace is trimmed.
#' This is useful if the values will be passed to other software that expects
#' the plain NAACCR values.
#'
#' @param input Either a string with a file name (containing no \code{\\n}
#'   character), a \code{\link[base]{connection}} object, or the text records
#'   themselves as a character vector.
#' @param version An integer specifying the NAACCR format version for parsing
#'   the records. Use this or \code{format}, not both.
#' @param format A \code{\link{record_format}} object for parsing the records.
#' @param keep_fields Character vector of XML field names to keep in the
#'   dataset. If \code{NULL} (default), all columns are kept.
#' @param skip An integer specifying the number of lines of the data file to
#'   skip before beginning to read data.
#' @param nrows A number specifying the maximum number of records to read.
#'   \code{Inf} (the default) means "all records."
#' @param buffersize Maximum number of lines to read at one time.
#' @return
#'   For \code{read_naaccr}, a \code{data.frame} of the records.
#'   The columns included depend on the NAACCR record format version.
#'   Columns are atomic vectors; there are too many to describe them all.
#'
#'   For \code{read_naaccr_plain}, a \code{data.frame} with the columns
#'   specified by \code{start_cols}, \code{end_cols}, and \code{col_names}.
#'   All columns are character vectors.
#' @note
#'   Some of the parameter text was shamelessly copied from the
#'   \code{\link[utils]{read.table}} and \code{\link[utils]{read.fwf}} help
#'   pages.
#' @seealso \code{\link{naaccr_record}}
#' @examples
#'   # This file has synthetic abstract records
#'   incfile <- system.file(
#'     "extdata", "synthetic-naaccr-18-abstract.txt",
#'     package = "naaccr"
#'   )
#'   fields <- c("ageAtDx", "sex", "sequenceNumberCentral")
#'   read_naaccr(incfile, version = 18, keep_fields = fields)
#'   recs <- read_naaccr_plain(incfile, version = 18, keep_fields = fields)
#'   recs
#'   # Note sequenceNumberCentral has been split in two: a number and a flag
#'   summary(recs[["sequenceNumberCentral"]])
#'   summary(recs[["sequenceNumberCentralFlag"]])
#' @import stringi
#' @import data.table
#' @rdname read_naaccr
#' @export
read_naaccr_plain <- function(input,
                              version = NULL,
                              format = NULL,
                              keep_fields = NULL,
                              skip = 0,
                              nrows = Inf,
                              buffersize = 10000) {
  if (!inherits(input, "connection")) {
    input <- as.connection(input)
    on.exit(
      if (isOpen(input)) close(input),
      add = TRUE
    )
  }
  if (!is.null(version)) {
    key_data <- list(version = version)
    read_format <- naaccr_format[key_data, on = "version"]
    setorderv(read_format, "item")
  } else if (!is.null(format)) {
    read_format <- format
  } else {
    stop("Must specify either version or format")
  }
  if (is.null(keep_fields)) {
    keep_fields <- read_format[["name"]]
  } else {
    read_format <- read_format[list(name = keep_fields), on = "name"]
  }
  read_format <- as.record_format(read_format)
  # Read all record types as the longest type, padding and then truncating
  # Break the reading into chunks because of the typically large files.
  # "Growing" vectors is inefficient, so allocate many new spaces when needed
  if (skip > 0L) {
    readLines(input, skip)
  }
  chunks <- if (is.finite(nrows)) {
    vector("list", ceiling(nrows / buffersize))
  } else {
    vector("list", 1000L)
  }
  index <- 0L
  rows_read <- 0L
  while (rows_read < nrows) {
    chunk_size <- min(buffersize, nrows - rows_read)
    record_lines <- readLines(input, n = chunk_size)
    if (length(record_lines) == 0L) {
      break
    }
    rows_read <- rows_read + length(record_lines)
    index <- index + 1L
    line_lengths <- stringi::stri_width(record_lines)
    record_width <- max(read_format[["end_col"]])
    record_lines <- stringi::stri_pad_right(
      record_lines,
      width = record_width - line_lengths
    )
    record_lines <- stringi::stri_sub(record_lines, 1L, record_width)
    chunks[[index]] <- split_fields(
      record_lines = record_lines,
      start_cols   = read_format[["start_col"]],
      end_cols     = read_format[["end_col"]],
      col_names    = read_format[["name"]]
    )
    if (index >= length(chunks)) {
      chunks <- c(chunks, vector("list", 1000L))
    }
  }
  records <- data.table::rbindlist(chunks)
  setcolorder(records, keep_fields)
  setDF(records)
  records
}


#' @rdname read_naaccr
#' @export
read_naaccr <- function(input,
                        version = NULL,
                        format = NULL,
                        keep_fields = NULL,
                        skip = 0,
                        nrows = Inf,
                        buffersize = 10000) {
  records <- read_naaccr_plain(
    input = input,
    version = version,
    format = format,
    keep_fields = keep_fields,
    skip = skip,
    nrows = nrows,
    buffersize = buffersize
  )
  as.naaccr_record(records)
}
