#' Read records from a NAACCR file
#' @import readr
#' @import data.table
read_naaccr <- function(file, naaccr_version = NULL) {
  if (is.null(naaccr_version)) {
    naaccr_version <- max(naaccr_items[['naaccr_version']])
  }
  # NAACCR record types differ in line length
  line1 <- readLines(file, 1L)
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
      col_names = gsub('\\W+', '_', name)
    )
  ]

  if (inherits(file, 'connection')) {
    if (isOpen(file)) {
      pushBack(file, line1)
    }
    on.exit(
      if (isOpen(file)) close(file),
      add = TRUE
    )
  }
  readr::read_fwf(
    file          = file,
    col_positions = col_positions,
    col_types     = readr::cols(.default = readr::col_character()),
    na            = ''
  )
}
