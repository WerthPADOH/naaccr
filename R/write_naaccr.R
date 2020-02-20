#' Convert a factor-classed field to NAACCR codes
#' @param x Factor vector.
#' @param field Character string naming the field.
#' @noRd
naaccr_unfactor <- function(x, field) {
  if (length(field) != 1L || !is.character(field)) {
    stop("field should be single string")
  }
  field_scheme <- field_code_scheme[list(name = field), on = "name"]
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
  if (length(field) != 1L || !is.character(field)) {
    stop("field should be single string")
  }
  field_scheme <- field_sentinel_scheme[list(name = field), on = "name"]
  if (nrow(field_scheme) != 1L) {
    stop(field, " matched ", nrow(field_scheme), " schema")
  }
  sentinels <- field_sentinels[field_scheme, on = "scheme"]
  is_flagged <- if (is.null(flag)) rep(FALSE, length(value)) else !is.na(flag)
  out <- rep_len(NA_character_, length(value))
  out[!is_flagged] <- switch(type,
    integer = format_integer(as.integer(value)[!is_flagged], width),
    numeric = format_decimal(as.numeric(value)[!is_flagged], width)
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


#' This function is meant to be used in naaccr_encode. All other functions in
#' this package should use naaccr_encode instead.
#' @param x Numeric vector.
#' @param width Integer giving the field width.
#' @import stringi
#' @noRd
format_decimal <- function(x, width) {
  x <- as.numeric(x)
  if (is.na(width)) width <- NULL
  expanded <- formatC(x, width = width, format = "f")
  non_finite <- !is.finite(x)
  if (any(non_finite & !is.na(x))) {
    warning("Setting non-finite values to missing")
  }
  expanded[non_finite] <- NA_character_
  sliced <- substr(expanded, 1L, width)
  dot_end <- endsWith(sliced, ".") & !is.na(sliced)
  sliced[dot_end] <- stri_sub(sliced[dot_end], 1L, nchar(sliced[dot_end]) - 1L)
  trimws(sliced)
}


#' This function is meant to be used in naaccr_encode. All other functions in
#' this package should use naaccr_encode instead.
#' @param x Integer vector
#' @param width Integer giving the field width
#' @import stringi
#' @noRd
format_integer <- function(x, width) {
  x <- as.integer(x)
  if (is.na(width)) width <- NULL
  expanded <- formatC(x, width = width, format = "d")
  non_finite <- !is.finite(x)
  if (any(non_finite & !is.na(x))) {
    warning("Setting non-finite values to missing")
  }
  expanded[non_finite] <- NA_character_
  trimws(expanded)
}


#' This function is meant to be used in naaccr_encode. All other functions in
#' this package should use naaccr_encode instead.
#' @param x Date vector
#' @noRd
format_date <- function(x) {
  original <- attr(x, "original")
  expanded <- format(x, format = "%Y%m%d")
  is_na <- is.na(x)
  expanded[is_na] <- if (!is.null(original)) {
    original[is_na]
  } else {
    "        "
  }
  expanded[is.na(expanded)] <- "        "
  expanded
}


#' This function is meant to be used in naaccr_encode. All other functions in
#' this package should use naaccr_encode instead.
#' @param x POSIXct vector
#' @noRd
format_datetime <- function(x) {
  original <- attr(x, "original")
  expanded <- format(x, format = "%Y%m%d%H%M%S")
  is_na <- is.na(x)
  expanded[is_na] <- if (!is.null(original)) {
    original[is_na]
  } else {
    "              "
  }
  expanded[is.na(expanded)] <- "              "
  # Account for when zeros are added in naaccr_datetime
  if (!is.null(original)) {
    ends_blanks <- which(endsWith(original, " "))
    zeroed <- gsub(" ", "0", original[ends_blanks], fixed = TRUE)
    zero_swapped <- which(
      x[ends_blanks] == as.POSIXct(zeroed, format = "%Y%m%d%H%M%S")
    )
    expanded[ends_blanks][zero_swapped] <- original[ends_blanks][zero_swapped]
  }
  expanded
}


#' Format a value as a string according to the NAACCR format
#' @param x Vector of values.
#' @param field Character string naming the field.
#' @param flag Character vector of flags for the field. Only needed if the
#'   field contains sentinel values.
#' @inheritParams write_naaccr
#' @return Character vector of the values as they would be encoded in a
#'   NAACCR-formatted text file.
#' @seealso \code{\link{split_sentineled}}
#' @examples
#'   r <- naaccr_record(
#'     ageAtDiagnosis = c("089", "000", "200"),
#'     dateOfDiagnosis = c("20070402", "201709  ", "        ")
#'   )
#'   r
#'   mapply(FUN = naaccr_encode, x = r, field = names(r))
#' @import data.table
#' @import stringi
#' @export
naaccr_encode <- function(x, field, flag = NULL, version = NULL, format = NULL) {
  format <- choose_naaccr_format(version = version, format = format)
  field_def <- format[list(name = field), on = "name", nomatch = 0L]
  if (nrow(field_def) == 0L) {
    warning("No format for field '", field, "'; defaulting to character")
    if (is.numeric(x)) {
      return(format(x, scientific = FALSE))
    } else {
      return(as.character(x))
    }
  }
  width <- field_def[["end_col"]] - field_def[["start_col"]] + 1L
  codes <- switch(as.character(field_def[["type"]]),
    factor = naaccr_unfactor(x, field),
    sentineled_integer = naaccr_unsentinel(x, flag, field, width, "integer"),
    sentineled_numeric = naaccr_unsentinel(x, flag, field, width, "numeric"),
    Date = format_date(x),
    datetime = format_datetime(x),
    numeric = format_decimal(x, width),
    count = format_integer(x, width),
    integer = format_integer(x, width),
    boolean01 = ifelse(x, "1", "0"),
    boolean12 = ifelse(x, "2", "1"),
    override = ifelse(x, "1", ""),
    as.character(x)
  )
  codes <- as.character(codes)
  too_wide <- stri_width(codes) > width
  if (any(too_wide, na.rm = TRUE)) {
    codes[too_wide] <- ""
    warning(
      sum(too_wide), " values of '", field,
      "' field were too wide and set to blanks"
    )
  }
  is_missing <- is.na(codes) | !nzchar(trimws(codes))
  if (!is.na(field_def[["alignment"]])) {
    pad_side <- switch(as.character(field_def[["alignment"]]),
      left = "right",
      right = "left"
    )
    codes[!is_missing] <- stri_pad(
      str = codes[!is_missing],
      width = width,
      side = pad_side,
      pad = field_def[["padding"]]
    )
  }
  codes[is_missing] <- stri_dup(" ", width)
  codes
}


#' Replace values in a record dataset with format-adhering values
#' @noRd
encode_records <- function(records, format) {
  # Combine the "reportable" and "only tumor" fields back into sequence number
  for (ii in seq_len(ncol(sequence_number_columns))) {
    number_name <- sequence_number_columns[["number", ii]]
    if (number_name %in% format[["name"]] && number_name %in% names(records)) {
      only_name <- sequence_number_columns[["only", ii]]
      only_tumor <- which(records[[only_name]])
      set(x = records, i = only_tumor, j = number_name, value = 0L)
      reportable_name <- sequence_number_columns[["reportable", ii]]
      non_reportable <- which(!records[[reportable_name]])
      set(
        x = records,
        i = non_reportable,
        j = number_name,
        value = records[["name"]][non_reportable] + 60L
      )
    }
  }
  is_sentinel <- startsWith(format[["type"]], "sentineled")
  sent_cols <- format[["name"]][is_sentinel]
  flag_cols <- paste0(sent_cols, "Flag")
  non_sent_cols <- format[["name"]][!is_sentinel]
  if (length(non_sent_cols)) {
    set(
      x = records,
      j = non_sent_cols,
      value = mapply(
        FUN = naaccr_encode,
        x = records[, non_sent_cols, with = FALSE],
        field = non_sent_cols,
        MoreArgs = list(format = format),
        SIMPLIFY = FALSE
      )
    )
  }
  if (length(sent_cols)) {
    set(
      x = records,
      j = sent_cols,
      value = mapply(
        FUN = naaccr_encode,
        x = records[, sent_cols, with = FALSE],
        field = sent_cols,
        flag = records[, flag_cols, with = FALSE],
        MoreArgs = list(format = format),
        SIMPLIFY = FALSE
      )
    )
  }
  records
}


#' @noRd
prepare_writing_format <- function(format, fields) {
  type <- NULL # Avoid unmatched variable name warning in R Check
  fmt <- format[
    list(name = fields),
    on = "name",
    nomatch = 0L
  ][
    ,
    type := as.character(type)
  ]
  set(
    fmt,
    j = "width",
    value = fmt[["end_col"]] - fmt[["start_col"]] + 1L
  )
  fmt
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
#' @param encoding String specifying the character encoding for the output file.
#' @import stringi
#' @export
write_naaccr <- function(records, con, version = NULL, format = NULL, encoding = "UTF-8") {
  records <- if (is.data.table(records)) copy(records) else as.data.table(records)
  write_format <- choose_naaccr_format(version = version, format = format)
  write_format <- prepare_writing_format(write_format, names(records))
  setorderv(write_format, "start_col")
  line_length <- max(write_format[["end_col"]])
  records <- encode_records(records, write_format)
  blank_line <- stri_pad_left("", width = line_length, pad = " ")
  text_lines <- rep(blank_line, nrow(records))
  starts <- write_format[, "start_col", with = FALSE]
  ends <- write_format[, "end_col", with = FALSE]
  text_values <- data.table::transpose(records[, write_format[["name"]], with = FALSE])
  stri_sub_all(text_lines, from = starts, to = ends) <- text_values
  writeLines(text_lines, con)
}


#' @noRd
select_first_cautiously <- function(x, warning_name = NULL) {
  ux <- unique(x[!is.na(x)])
  if (length(ux) == 0L) return(NULL)
  if (length(ux) > 1L) {
    if (!is.null(warning_name)) {
      warning_name <- paste0(" for ", warning_name)
    }
    warning("Multiple values found", warning_name, "; using just the first")
    ux <- ux[1]
  }
  ux
}


#' XML-ize a dataset of NAACCR fields, with one node per row
#' @importFrom XML newXMLNode
#' @noRd
group_values <- function(dataset, node_name) {
  items <- vapply(
    X = names(dataset),
    FUN = function(field) {
      lapply(
        X = dataset[[field]],
        FUN = newXMLNode,
        name = "Item",
        attrs = c(naaccrId = field)
      )
    },
    FUN.VALUE = vector("list", nrow(dataset))
  )
  if (!is.matrix(items)) {
    items <- matrix(items, nrow = nrow(dataset))
  }
  out <- vector("list", nrow(dataset))
  for (ii in seq_along(out)) {
    out[[ii]] <- newXMLNode(node_name, .children = items[ii, , drop = TRUE])
  }
  out
}


#' @import stringi
#' @import data.table
#' @noRd
compose_items_xml <- function(dataset) {
  node_list <- data.table::transpose(dataset)
  vapply(
    X = node_list,
    FUN = function(values) {
      stri_join(
        '<Item naaccrId="', names(dataset), '">', values, "</Item>",
        collapse = ""
      )
    },
    FUN.VALUE = character(1L)
  )
}


#' Write records to a NAACCR-formatted XML file
#' @inheritParams write_naaccr
#' @param base_dictionary URI for the dictionary defining the NAACCR data items.
#'   If this is \code{NULL} and either \code{version} is not \code{NULL} or
#'   \code{format} is one of the standard NAACCR formats, then the URI from
#'   NAACCR's website for that version's dictionary will be used.
#' @param user_dictionary URI for the dictionary defining the user-specified
#'   data items.  If \code{NULL} (default), it won't be included in the XML.
#' @return Invisibly returns the
#'   \code{\link[=XMLInternalDocument-class]{XMLInternalDocument}} object which
#'   was written to \code{con}.
#' @import data.table
#' @export
write_naaccr_xml <- function(records,
                             con,
                             version = NULL,
                             format = NULL,
                             base_dictionary = NULL,
                             user_dictionary = NULL,
                             encoding = "UTF-8") {
  if (is.character(con)) {
    con <- file(con, "w", encoding = encoding)
    on.exit(try(close(con)), add = TRUE)
  }
  write_format <- choose_naaccr_format(version = version, format = format)
  write_format <- prepare_writing_format(write_format, names(records))
  # Determine XML namespace from given format or version
  if (is.null(base_dictionary)) {
    if (!is.null(format)) {
      for (v in sort(unique(naaccr_format[["version"]]), decreasing = TRUE)) {
        vfmt <- as.record_format(naaccr_format[list(version = v), on = "version"])
        setDT(vfmt)
        format <- as.data.table(format)
        same_fmt <- setequal(vfmt[["item"]], format[["item"]])
        if (isTRUE(same_fmt)) {
          version <- v
          break()
        }
      }
    }
    if (!is.null(version)) {
      base_dictionary <- sprintf(
        "http://naaccr.org/naaccrxml/naaccr-dictionary-%2d0.xml", version
      )
    }
  }
  records <- if (is.data.table(records)) copy(records) else as.data.table(records)
  records <- encode_records(records, write_format)
  tiered_items <- split(write_format[["name"]], write_format[["parent"]])
  time_gen <- format(Sys.time(), "%Y-%m-%dT%H:%M:%S")
  time_gen <- paste0(substr(time_gen, 1, 22), ":", substr(time_gen, 23, 24))
  naaccr_data_tag <- paste0(
    "<NaaccrData xmlns = \"http://naaccr.org/naaccrxml\"",
    " baseDictionaryUri = \"", base_dictionary, "\"",
    " userDictionaryUri = \"", user_dictionary, "\"",
    " specificationVersion = \"1.4\"",
    " timeGenerated = \"", time_gen, "\">"
  )
  if (length(tiered_items[["NaaccrData"]])) {
    naaccr_data <- unique(records[, tiered_items[["NaaccrData"]], with = FALSE])
    naaccr_data_items <- compose_items_xml(naaccr_data)
  } else {
    naaccr_data_items <- NULL
  }
  writeLines(c(naaccr_data_tag, naaccr_data_items), con)
  if (!("patientIdNumber" %in% names(records))) {
    set(records, j = "patientIdNumber", value = seq_len(nrow(records)))
  }
  patient_vars <- union("patientIdNumber", tiered_items[["Patient"]])
  patients <- unique(records[, patient_vars, with = FALSE])
  patient_items <- NULL
  if (length(tiered_items[["Patient"]])) {
    patients[
      ,
      patient_items := compose_items_xml(.SD),
      .SDcols = tiered_items[["Patient"]]
    ]
  } else {
    set(patients, j = "patient_items", value = "")
  }
  records[
    patients,
    on = patient_vars,
    {
      if (length(tiered_items[["Tumor"]])) {
        tumor_items <- compose_items_xml(.SD[, tiered_items[["Tumor"]], with = FALSE])
        tumors <- stri_join("<Tumor>", tumor_items, "</Tumor>")
      } else {
        tumors <- NULL
      }
      writeLines(c("<Patient>", patient_items, tumors, "</Patient>"), con = con)
    },
    by = .EACHI,
  ]
  writeLines("</NaaccrData>", con = con)
  NULL
}
