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
                              width = NULL,
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
    integer = format_integer(as.integer(value)[!is_flagged]),
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
#' @importFrom stringi stri_sub
#' @noRd
format_decimal <- function(x, width) {
  x <- as.numeric(x)
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
#' @noRd
format_integer <- function(x) {
  x <- as.integer(x)
  expanded <- formatC(x, format = "d")
  non_finite <- !is.finite(x)
  if (any(non_finite & !is.na(x))) {
    warning("Setting non-finite values to missing")
  }
  expanded[non_finite] <- ""
  trimws(expanded)
}


#' This function is meant to be used in naaccr_encode. All other functions in
#' this package should use naaccr_encode instead.
#' @param x Date vector
#' @noRd
format_date <- function(x) {
  original <- attr(x, "original")
  if (is.character(x)) {
    x <- naaccr_date(x)
  } else if (!inherits(x, "Date")) {
    x <- as.Date(x)
  }
  expanded <- format(x, format = "%Y%m%d")
  is_na <- is.na(x)
  if (!is.null(original)) {
    expanded[is_na] <- original[is_na]
  }
  expanded[is.na(expanded)] <- ""
  trimws(expanded)
}


#' This function is meant to be used in naaccr_encode. All other functions in
#' this package should use naaccr_encode instead.
#' @param x POSIXct vector
#' @inheritParams write_naaccr
#' @importFrom stringi stri_replace_last_regex stri_detect_regex stri_length stri_join
#' @noRd
format_datetime_hl7 <- function(x) {
  original <- attr(x, "original")
  if (is.character(x)) {
    x <- naaccr_datetime(x)
  } else if (!inherits(x, "Date")) {
    x <- as.POSIXct(x)
  }
  expanded <- format(x, format = "%Y%m%d%H%M%S")
  if (!is.null(original)) {
    original <- trimws(original)
    expanded[is.na(expanded)] <- original[is.na(expanded)]
    # If an incomplete datetime string was the input, return that when the
    # POSIXct value hasn't been changed
    was_vague <- which(
      !is.na(original) &
        !stri_detect_regex(original, "^(\\d{14}|\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}[+-]\\d{2}:\\d{2})$")
    )
    reread <- naaccr_datetime(original[was_vague], tz = attr(x, "tzone"))
    same_value <- which(x[was_vague] == reread)
    expanded[was_vague][same_value] <- original[was_vague][same_value]
    # Convert any ISO strings to HL7
    is_iso <- which(stri_length(expanded) > 4L & substr(expanded, 5, 5) == "-")
    iso_str <- expanded[is_iso]
    expanded[is_iso] <- stri_join(
      substr(iso_str, 1, 4), substr(iso_str, 6, 7),
      substr(iso_str, 9, 10), substr(iso_str, 12, 13),
      substr(iso_str, 15, 16), substr(iso_str, 18, 19)
    )
  }
  expanded <- trimws(expanded)
  expanded[is.na(expanded)] <- ""
  expanded
}


#' This function is meant to be used in naaccr_encode. All other functions in
#' this package should use naaccr_encode instead.
#' @param x POSIXct vector
#' @inheritParams write_naaccr
#' @importFrom stringi stri_replace_last_regex stri_detect_regex stri_join
#' @noRd
format_datetime_iso <- function(x) {
  original <- attr(x, "original")
  if (is.character(x)) {
    x <- naaccr_datetime(x)
  } else if (!inherits(x, "Date")) {
    x <- as.POSIXct(x)
  }
  expanded <- format(x, format = "%Y-%m-%dT%H:%M:%S%z")
  # R doesn't put colons in formatted time zone offsets, but NAACCR requires it
  expanded <- stri_replace_last_regex(expanded, "([+-]\\d{2})(\\d{2})$", "$1:$2")
  if (!is.null(original)) {
    original <- trimws(original)
    expanded[is.na(expanded)] <- original[is.na(expanded)]
    # If an incomplete datetime string was the input, return that when the
    # POSIXct value hasn't been changed
    was_vague <- which(
      !is.na(original) &
        !stri_detect_regex(original, "^(\\d{14}|\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}[+-]\\d{2}:\\d{2})$")
    )
    reread <- naaccr_datetime(original[was_vague], tz = attr(x, "tzone"))
    same_value <- which(x[was_vague] == reread)
    expanded[was_vague][same_value] <- original[was_vague][same_value]
    # Convert any HL7 strings to ISO
    is_hl7 <- which(stri_detect_regex(expanded, "^\\d{5}"))
    hl7_str <- expanded[is_hl7]
    expanded[is_hl7] <- stri_join(
      substr(hl7_str, 1, 4), "-", substr(hl7_str, 5, 6), "-",
      substr(hl7_str, 7, 8), "T", substr(hl7_str, 9, 10), ":",
      substr(hl7_str, 11, 12), ":", substr(hl7_str, 13, 14)
    )
    expanded <- stri_replace_last_regex(expanded, "[T:+-]+$", "")
  }
  expanded <- trimws(expanded)
  expanded[is.na(expanded)] <- ""
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
#' @importClassesFrom data.table data.table
#' @importFrom stringi stri_pad_right stri_pad_left stri_width
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
  width <- field_def[["width"]]
  if (field_def[["type"]] == "datetime" && width == 14L) {
    codes <- format_datetime_hl7(x)
  } else if (field_def[["type"]] == "datetime" && width == 25L) {
    codes <- format_datetime_iso(x)
  } else {
    codes <- switch(as.character(field_def[["type"]]),
      factor = naaccr_unfactor(x, field),
      sentineled_integer = naaccr_unsentinel(x, flag, field, type = "integer"),
      sentineled_numeric = naaccr_unsentinel(x, flag, field, width, type = "numeric"),
      Date = format_date(x),
      numeric = format_decimal(x, width),
      count = format_integer(x),
      integer = format_integer(x),
      boolean01 = ifelse(x, "1", "0"),
      boolean12 = ifelse(x, "2", "1"),
      override = ifelse(x, "1", ""),
      as.character(x)
    )
  }
  codes <- as.character(codes)
  # Blank padding is only for fixed-width, so that will be handled by that
  # writing function.
  # But non-blank padding is required for any format.
  if (field_def[["padding"]] != " ") {
    non_blank <- trimws(codes) != "" & !is.na(codes)
    if (field_def[["alignment"]] == "left") {
      codes[non_blank] <- stri_pad_right(
        codes[non_blank],
        width = width,
        pad = field_def[["padding"]]
      )
    } else if (field_def[["alignment"]] == "right") {
      codes[non_blank] <- stri_pad_left(
        codes[non_blank],
        width = width,
        pad = field_def[["padding"]]
      )
    }
  }
  if (!is.na(width)) {
    too_wide <- stri_width(codes) > width
    if (any(too_wide, na.rm = TRUE)) {
      codes[too_wide] <- ""
      warning(
        sum(too_wide), " values of '", field,
        "' field were too wide and set to blanks"
      )
    }
  }
  codes[is.na(codes) | !nzchar(trimws(codes))] <- ""
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
  is_sentinel <- format[["type"]] %in% c("sentineled_integer", "sentineled_numeric")
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
  if (!is.data.table(format)) format <- as.data.table(format)
  type <- NULL # Avoid unmatched variable name warning in R Check
  format[
    list(name = fields),
    on = "name",
    nomatch = 0L
  ][
    ,
    type := as.character(type)
  ]
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
#' @importFrom stringi stri_dup stri_pad_right stri_pad_left "stri_sub_all<-"
#' @importClassesFrom data.table data.table
#' @importFrom data.table is.data.table as.data.table copy setorderv transpose
#' @export
write_naaccr <- function(records, con, version = NULL, format = NULL, encoding = "UTF-8") {
  records <- if (is.data.table(records)) copy(records) else as.data.table(records)
  write_format <- if (is.null(version) && is.null(format)) {
    naaccr_format_18
  } else {
    choose_naaccr_format(version = version, format = format)
  }
  write_format <- prepare_writing_format(write_format, names(records))
  setorderv(write_format, "start_col")
  line_length <- max(write_format[["end_col"]])
  if (is.null(attr(write_format, "version")) && !is.null(version)) {
    if (is.numeric(version)) {
      version <- formatC(version, format = "d")
    } else {
      version <- as.character(version)
    }
    attr(write_format, "version") <- version
  }
  records <- encode_records(records, write_format)
  # Pad to field width
  name <- NULL # Avoid unmatched variable name warning in R Check
  width <- NULL
  alignment <- NULL
  padding <- NULL
  fmt_with_width <- write_format[
    !is.na(width),
    list(name, width, alignment, padding)
  ]
  for (ii in seq_len(nrow(fmt_with_width))) {
    fname <- fmt_with_width[["name"]][ii]
    values <- records[[fname]]
    fwidth <- fmt_with_width[["width"]][ii]
    falign <- fmt_with_width[["alignment"]][ii]
    fpad <- fmt_with_width[["padding"]][ii]
    # Missing values shouldn't be padded with anything other than blanks,
    # because it would make them non-missing (e.g., "000" for missing age is bad)
    is_na <- trimws(values) == "" & !is.na(values)
    values[is_na] <- stri_dup(" ", fwidth)
    if (falign == "left") {
      values[!is_na] <- stri_pad_right(values[!is_na], width = fwidth, pad = fpad)
    } else if (falign == "right") {
      values[!is_na] <- stri_pad_left(values[!is_na], width = fwidth, pad = fpad)
    } else {
      stop("Field ", fname, ' has invalid alignment value in format: "', falign, '"')
    }
    set(records, j = fname, value = values)
  }
  blank_line <- stri_pad_left("", width = line_length, pad = " ")
  text_lines <- rep(blank_line, nrow(records))
  starts <- write_format[, "start_col", with = FALSE]
  ends <- write_format[, "end_col", with = FALSE]
  text_values <- transpose(records[, write_format[["name"]], with = FALSE])
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


#' @importFrom stringi stri_isempty stri_trim_both
#' @importFrom data.table transpose
#' @noRd
compose_items_xml <- function(dataset) {
  node_list <- data.table::transpose(dataset)
  vapply(
    X = node_list,
    FUN = function(values) {
      non_blank <- !stri_isempty(stri_trim_both(values)) & !is.na(values)
      nodes_text <- stri_join(
        '<Item naaccrId="', names(dataset)[non_blank], '">', values[non_blank], "</Item>",
        collapse = ""
      )
      if (length(nodes_text) == 0L) nodes_text <- ""
      nodes_text
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
#' @importClassesFrom data.table data.table
#' @importFrom data.table setDT as.data.table is.data.table copy set ":=" .SD .EACHI
#' @importFrom stringi stri_trim_both stri_replace_all_fixed stri_join
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
  ver_nums <- unique(records[["naaccrRecordVersion"]])
  ver_nums <- ver_nums[!is.na(ver_nums)]
  if (is.null(version) && is.null(format) && length(ver_nums) > 0L) {
    if (length(ver_nums) > 1L) {
      warning("Multiple NAACCR versions specified in records. Using most recent.")
    }
    version <- max(ver_nums)
  }
  write_format <- choose_naaccr_format(version = version, format = format)
  write_format <- prepare_writing_format(write_format, names(records))
  # Determine XML namespace from given format or version
  if (is.null(base_dictionary)) {
    if (!is.null(format)) {
      for (v in sort(names(naaccr_formats), decreasing = TRUE)) {
        vfmt <- naaccr_formats[[v]]
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
      if (nchar(version) == 2L) version <- paste0(version, "0")
      base_dictionary <- paste0(
        "http://naaccr.org/naaccrxml/naaccr-dictionary-", version, ".xml"
      )
    }
  }
  records <- if (is.data.table(records)) copy(records) else as.data.table(records)
  records <- encode_records(records, write_format)
  for (ii in seq_along(records)) {
    cleaned <- stri_trim_both(records[[ii]])
    cleaned <- stri_replace_all_fixed(cleaned, "&", "&amp;")
    cleaned <- stri_replace_all_fixed(
      cleaned, c("<", ">", '"', "'"), c("&lt;", "&gt;", "&quot;", "&apos;"),
      vectorize_all = FALSE
    )
    set(records, j = ii, value = cleaned)
  }
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
