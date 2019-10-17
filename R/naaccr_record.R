#' Analysis-ready NAACCR records
#'
#' Subclass of \code{data.frame} for doing analysis with NAACCR records.
#'
#' \code{naaccr_record} creates a \code{data.frame} of cancer incidence records
#' ready for analysis:
#' columns are of appropriate classes, coded values are replaced with factors,
#' and unknowns are replaced with \code{NA}.
#'
#' @param ... Arguments of the form \code{tag = value}, where \code{tag} is a
#'   valid NAACCR data item name and \code{value} is the vector of the item's
#'   values from the NAACCR format.
#' @param keep_unknown Logical indicating whether values of "unknown" should be
#'   a level in the factor or \code{NA}.
#' @param version An integer specifying the NAACCR format version for parsing
#'   the records. Use this or \code{format}, not both.
#' @param format A \code{\link{record_format}} object for parsing the records.
#' @return A \code{data.frame} with columns named using the NAACCR XML scheme.
#' @import data.table
#' @export
naaccr_record <- function(...,
                          keep_unknown = FALSE,
                          version = NULL,
                          format = NULL) {
  input_data <- as.data.table(lapply(list(...), as.character))
  as.naaccr_record(
    x = input_data,
    keep_unknown = keep_unknown,
    version = version,
    format = format
  )
}


#' Coerce to a naaccr_record dataset
#' Convert objects into \code{naaccr_record} objects, if a method exists.
#' @param x An R object.
#' @param ... Additional arguments passed to or from methods.
#' @inheritParams naaccr_record
#' @return An object of class \code{\link{naaccr_record}}
#' @seealso \code{\link{naaccr_record}}
#' @export
as.naaccr_record <- function(x,
                             keep_unknown = FALSE,
                             version = NULL,
                             format = NULL,
                             ...) {
  if (inherits(x, "naaccr_record")) return(x)
  UseMethod('as.naaccr_record')
}


#' @rdname as.naaccr_record
#' @export
as.naaccr_record.list <- function(x,
                                  keep_unknown = FALSE,
                                  version = NULL,
                                  format = NULL,
                                  ...) {
  x_df <- as.data.frame(x, stringsAsFactors = FALSE)
  as.naaccr_record(x_df)
}


#' @noRd
sequence_number_columns <- matrix(
  c(
    "sequenceNumberCentral", "npcrReportableCentral",
    "onlyTumorCentral", "sequenceNumberCentralFlag",
    "sequenceNumberHospital", "npcrReportableHospital",
    "onlyTumorHospital", "sequenceNumberHospitalFlag"
  ),
  ncol = 2,
  dimnames = list(
    c("number", "reportable", "only", "flag"),
    c("central", "hospital")
  )
)


#' @rdname as.naaccr_record
#' @import data.table
#' @export
as.naaccr_record.data.frame <- function(x,
                                        keep_unknown = FALSE,
                                        version = NULL,
                                        format = NULL,
                                        ...) {
  convert_format <- if (!is.null(version)) {
    key_data <- list(version = version)
    naaccr_format[key_data, on = "version"]
  } else if (!is.null(format)) {
    format
  } else {
    latest_version <- max(naaccr_format[["version"]])
    naaccr_format[list(version = latest_version), on = "version"]
  }
  all_items <- convert_format[
    list(name = names(x)),
    on = "name",
  ][
    ,
    .SD[1],
    by = "item"
  ]
  record <- if (is.data.table(x)) copy(x) else as.data.table(x)
  count_items <- all_items[list(type = "count"), on = "type", nomatch = 0L]
  for (ii in seq_len(nrow(count_items))) {
    column <- count_items[["name"]][ii]
    width <- count_items[["end_col"]][ii] - count_items[["start_col"]][ii] + 1L
    set(x = record, j = column, value = clean_count(record[[column]], width))
  }
  coded_fields <- intersect(all_items[["name"]], field_code_scheme[["name"]])
  for (column in coded_fields) {
    set(
      x     = record,
      j     = column,
      value = naaccr_factor(
        x            = record[[column]],
        field        = column,
        keep_unknown = keep_unknown
      )
    )
  }
  sentinel_fields <- intersect(all_items[["name"]], field_sentinel_scheme[["name"]])
  sentinel_fields <- setdiff(
    sentinel_fields,
    c("sequenceNumberCentral", "sequenceNumberHospital")
  )
  for (column in sentinel_fields) {
    flag_column <- paste0(column, "Flag")
    if (flag_column %in% names(record)) {
      warning(flag_column, " already exists in dataset, will not be overwritten")
    }
    set(
      x     = record,
      j     = c(column, flag_column),
      value = split_sentineled(record[[column]], field = column)
    )
  }
  for (ii in seq_len(ncol(sequence_number_columns))) {
    number_name <- sequence_number_columns[["number", ii]]
    if (number_name %in% all_items[["name"]]) {
      set(
        x = record,
        j = sequence_number_columns[, ii],
        value = split_sequence_number(record[[number_name]])
      )
    }
  }
  unresolved <- setdiff(all_items[["name"]], c(count_items[["name"]], coded_fields))
  name <- NULL
  type_groups <- all_items[
    list(name = unresolved),
    on = "name"
  ][
    ,
    list(fields = list(name)),
    by = "type"
  ]
  set(type_groups, j = "type", value = as.character(type_groups[["type"]]))
  for (ii in seq_len(nrow(type_groups))) {
    type <- type_groups[["type"]][[ii]]
    converter_fun <- type_converters[[type]]
    columns <- type_groups[["fields"]][[ii]]
    for (column in columns) {
      set(x = record, j = column, value = converter_fun(record[[column]]))
    }
  }
  # Have each "Flag" column following the one it describes
  possible_names <- paste0(
    rep(stri_subset_regex(names(record), "Flag$", negate = TRUE), each = 2),
    c("", "Flag")
  )
  stopifnot(!anyDuplicated(possible_names))
  valid_names <- possible_names[possible_names %in% names(record)]
  setcolorder(record, valid_names)
  record <- setDF(record)
  class(record) <- c('naaccr_record', class(record))
  record
}
