#' Convert a factor-classed field to NAACCR codes
#' @param x Factor vector.
#' @param field Character string naming the field.
#' @noRd
naaccr_unfactor <- function(x, field) {
  if (length(field) != 1L) {
    stop("field should be single string")
  }
  field_scheme <- field_code_scheme[list(xml_name = field), on = "xml_name"]
  if (nrow(field_scheme) != 1L) {
    stop(field, " matched ", nrow(field_scheme), " schema")
  }
  codes <- field_codes[field_scheme, on = "scheme"]
  codes[
    list(label = as.character(x)),
    on = "label"
  ][[
    "code"
  ]]
}


#' Recombine values and flags into a single vector with sentinel values
#' @param value Numeric vector.
#' @param flag Factor vector of sentinel flags.
#' @param field Character string naming the field.
#' @param width Integer giving the field width.
#' @param type Character string describing how to format the values in the
#'   NAACCR file. Either \code{"integer"} or \code{"numeric"}.
#' @noRd
naaccr_unsentinel <- function(value,
                              flag,
                              field,
                              width,
                              type = c("integer", "numeric")) {
  type <- match.arg(type)
  if (length(field) != 1L) {
    stop("field should be single string")
  }
  field_scheme <- field_sentinel_scheme[list(xml_name = field), on = "xml_name"]
  if (nrow(field_scheme) != 1L) {
    stop(field, " matched ", nrow(field_scheme), " schema")
  }
  sentinels <- field_sentinels[field_scheme, on = "scheme"]
  is_flagged <- !is.na(flag)
  out <- rep_len(NA_character_, length(value))
  out[!is_flagged] <- switch(type,
    integer = format_integer(value[!is_flagged], width),
    numeric = format_decimal(value[!is_flagged], width)
  )
  sents <- sentinels[
    list(label = as.character(flag[is_flagged])),
    on = "label"
  ][[
    "sentinel"
  ]]
  out[is_flagged] <- sents
  out
}


#' Format a decimal number for a NAACCR fixed-width file
#' @param x Numeric vector.
#' @param width Integer giving the field width.
#' @import stringi
#' @noRd
format_decimal <- function(x, width) {
  expanded <- formatC(x, width = width, format = "f")
  sliced <- substr(expanded, 1L, width)
  dot_end <- endsWith(sliced, ".")
  sliced[dot_end] <- stri_sub(sliced[dot_end], 1L, nchar(sliced[dot_end]) - 1L)
  sliced[!is.finite(x)] <- NA
  trimws(sliced)
}


#' Format an integer for a NAACCR fixed-width file
#' @param x Integer vector
#' @param width Integer giving the field width
#' @noRd
format_integer <- function(x, width) {
  expanded <- formatC(x, width = width, format = "d")
  expanded[!is.finite(x)] <- NA
  trimws(expanded)
}


#' Write records in NAACCR format
#'
#' Write records from a \code{\link{naaccr_record}} object to a connection in
#' fixed-width format, according to a specific version of the NAACCR format.
#'
#' @param records A \code{naaccr_record} object.
#' @param con Either a character string naming a file or a
#'   \code{\link[base:connections]{connection}} open for writing.
#' @param version An integer specifying the NAACCR format version for parsing
#'   the records. Use this or \code{format}, not both. If both \code{version}
#'   and \code{format} are \code{NULL} (the default), the most recent version is
#'   used.
#' @param format A \code{\link{record_format}} object for writing the records.
#' @import stringi
#' @export
write_naaccr <- function(records, con, version = NULL, format = NULL) {
  if (is.null(format)) {
    if (length(version) > 1L) {
      stop("'version' must a single integer")
    } else if (is.null(version)) {
      version <- max(naaccr_format[["version"]])
    }
    version <- as.integer(version)
    version_key <- list(version = version)
    format <- naaccr_format[version_key, on = "version"]
  }
  line_length <- max(format[["end_col"]])
  write_format <- format[
    list(name = names(records)),
    on      = "name",
    nomatch = 0L
  ]
  set(
    write_format,
    j = "width",
    value = write_format[["end_col"]] - write_format[["start_col"]] + 1L
  )
  blank_line <- stri_pad_left("", width = line_length, pad = " ")
  text_lines <- rep(blank_line, nrow(records))
  for (column in write_format[["name"]]) {
    field_def <- write_format[list(name = column), on = "name"]
    values <- records[[column]]
    if (startsWith(field_def[["type"]], "sentineled")) {
      flags <- records[[paste0(column, "Flag")]]
    }
    value_text <- switch(field_def[["type"]],
      factor             = naaccr_unfactor(values, column),
      sentineled_integer = naaccr_unsentinel(
        values, flags, column, field_def[["width"]], "integer"
      ),
      sentineled_numeric = naaccr_unsentinel(
        values, flags, column, field_def[["width"]], "numeric"
      ),
      Date               = strftime(values, format = "%Y%m%d"),
      datetime           = strftime(values, format = "%Y%m%d%H%M%S"),
      numeric            = format_decimal(values, field_def[["width"]]),
      count              = format_integer(values, field_def[["width"]]),
      integer            = format_integer(values, field_def[["width"]]),
      boolean01          = ifelse(values, "1", "0"),
      boolean12          = ifelse(values, "2", "1"),
      as.character(values)
    )
    too_wide <- stri_width(value_text) > field_def[["width"]]
    if (any(too_wide, na.rm = TRUE)) {
      value_text[too_wide] <- NA
      warning(
        sum(too_wide), " values of '", column,
        "' field were too wide and set to NA"
      )
    }
    if (!is.na(field_def[["alignment"]])) {
      pad_side <- switch(field_def[["alignment"]],
        left  = "right",
        right = "left"
      )
      value_text <- stri_pad(
        str   = value_text,
        width = field_def[["width"]],
        side  = pad_side,
        pad   = field_def[["padding"]]
      )
    }
    value_text[is.na(value_text)] <- stri_pad_left(
      "", width = field_def[["width"]], pad = " "
    )
    stri_sub(text_lines, field_def[["start_col"]], field_def[["end_col"]]) <- {
      value_text
    }
  }
  writeLines(text_lines, con)
}
