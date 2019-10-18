# Factorizing columns

#' Replace labels for unknown with NA
#' @param x Either a factor created with \code{\link{naaccr_factor}}, or a
#'   \code{\link{naaccr_record}} object.
#' @param field String giving the XML name of the NAACCR field to code.
#' @param ... Further arguments passed to or from other methods.
#' @return If \code{x} was a \code{factor}, then the result is a vector with the
#'   values of \code{x}, except all levels which effectively mean "unknown" are
#'   replaced with \code{NA}.
#'   The returned factor won't have those in its levels, either.
#'
#'   If \code{x} is a \code{naaccr_record} object, then the result is the
#'   \code{naaccr_record} created by applying this function to all columns of
#'   \code{x}.
#' @examples
#'   r <- naaccr_record(
#'     sex = c("1", "2", "9"),
#'     kras = c("8", "9", "3"),
#'     keep_unknown = TRUE
#'   )
#'   r
#'   unknown_to_na(r[["sex"]], field = "sex")
#'   unknown_to_na(r)
#' @export
unknown_to_na <- function(x, ...) {
  UseMethod("unknown_to_na")
}

#' @rdname unknown_to_na
#' @export
unknown_to_na.naaccr_record <- function(x, ...) {
  code_fields <- intersect(names(x), field_code_scheme[["name"]])
  x[code_fields] <- mapply(
    FUN = unknown_to_na,
    x = x[code_fields],
    field = code_fields,
    SIMPLIFY = FALSE
  )
  x
}

#' @import data.table
#' @rdname unknown_to_na
#' @export
unknown_to_na.factor <- function(x, field, ...) {
  if (length(field) != 1L) {
    stop("field should be single string")
  }
  field_scheme <- field_code_scheme[
    list(name = field),
    on = "name",
    nomatch = 0L
  ][[
    "scheme"
  ]]
  if (length(field_scheme) == 0L) {
    warning('"', field, '" not a coded field')
    return(x)
  }
  level_info <- field_codes[
    list(scheme = field_scheme, label = levels(x)),
    on = c("scheme", "label")
  ]
  known_levels <- levels(x)[!level_info[["means_missing"]]]
  factor(x, levels = known_levels, ordered = is.ordered(x))
}

#' Replace NAACCR codes with understandable factors
#' @param x Vector (usually character) of codes.
#' @param field String giving the XML name of the NAACCR field to code.
#' @param keep_unknown Logical indicating whether values of "unknown" should be
#'   a level in the factor or \code{NA}.
#' @param ... Additional arguments passed onto \code{\link[base]{factor}}.
#' @return
#'   A \code{factor} vector version of \code{x}. The levels are short
#'   descriptions instead of the basic NAACCR codes. Codes which stood for
#'   "unknown" with no further information are replaced with \code{NA}.
#'
#'   If \code{field} names a text or site-specific field, a \code{character}
#'   vector will be returned instead.
#' @examples
#'   naaccr_factor(c("20", "43", "99"), "radRegionalRxModality")
#'   naaccr_factor(c("USA", "GER", "XEN"), "addrAtDxCountry")
#'   # Default: NA for unknowns,
#'   naaccr_factor(c("1", "8", "9"), "tumorGrowthPattern")
#'   naaccr_factor(c("1", "8", "9"), "tumorGrowthPattern", keep_unknown = TRUE)
#' @import data.table
#' @export
naaccr_factor <- function(x, field, keep_unknown = FALSE, ...) {
  if (length(field) != 1L) {
    stop("field should be single string")
  }
  if (field %in% field_code_scheme[["name"]]) {
    field_scheme <- field_code_scheme[list(name = field), on = "name"]
    codes <- field_codes[field_scheme, on = "scheme"]
    out <- factor(
      x,
      levels = c(codes[["code"]], codes[["label"]]),
      labels = rep(codes[["label"]], 2L),
      ...
    )
    if (isFALSE(keep_unknown)) {
      out <- unknown_to_na(out, field = field)
    }
  } else {
    warning('"', field, '" not a coded field')
    out <- as.character(x)
    names(out) <- names(x)
  }
  out
}


#' Separate a field's continuous and sentinel values
#'
#' Separate a sentineled field's values into two vectors: one with the
#' continuous data and one with the sentinel values.
#'
#' @inheritParams naaccr_factor
#' @return
#'   If \code{field} is a sentineled field, a \code{data.frame} with two
#'   columns. The first is a \code{numeric} version of the continuous values
#'   from \code{x}. Its name is the value of \code{field}. The second is a
#'   \code{factor} with levels representing the sentinel values. For all
#'   non-missing values in the numeric vector, the respective value in the
#'   factor is \code{NA}. If a value of \code{x} was not valid, the respective
#'   row will be \code{NA} for the continuous and flag values.
#'
#'   If \code{field} is not a sentineled field, a data.frame with just \code{x}
#'   is returned with a warning.
#' @examples
#'   node_codes <- c("10", "20", "90", "95", "99", NA)
#'   s <- split_sentineled(node_codes, "regionalNodesPositive")
#'   print(s)
#'   s[is.na(s[["regionalNodesPositive"]]), "regionalNodesPositiveFlag"]
#' @export
split_sentineled <- function(x, field) {
  if (length(field) != 1L) {
    stop("field should be single string")
  }
  if (!(field %in% field_sentinel_scheme[["name"]])) {
    warning('"', field, '" not a sentineld field')
    out <- data.frame(x)
    names(out) <- field
    return(out)
  }
  UseMethod("split_sentineled")
}


#' @export
#' @noRd
split_sentineled.default <- function(x, field) {
  field_scheme <- field_sentinel_scheme[list(field), on = "name"]
  sents <- field_sentinels[field_scheme, on = "scheme"]
  x <- as.character(x)
  x <- trimws(x)
  is_empty <- !nzchar(x)
  x[is_empty] <- NA
  is_sentinel <- x %in% sents[["sentinel"]]
  is_continuous <- !is_sentinel & grepl("^\\d+(\\.\\d+)?$", x, perl = TRUE)
  is_invalid <- !is_empty & !is_sentinel & !is_continuous & !is.na(x)
  if (any(is_invalid)) {
    warning("Non-blank invalid codes set to NA: ", field)
  }
  x_num <- as.numeric(replace(x, !is_continuous, NA))
  x_sent <- factor(x, sents[["sentinel"]], sents[["label"]])
  out <- data.frame(x_num, x_sent)
  names(out) <- c(field, paste0(field, "Flag"))
  out
}


#' @export
#' @noRd
split_sentineled.numeric <- function(x, field) {
  xchar <- naaccr_encode(x, field = field)
  split_sentineled(x = xchar, field = field)
}


#' Unpack tumor sequence number data
#'
#' Separate the multiple types of information in \code{sequenceNumberCentral}
#' and \code{sequenceNumberHospital} into multiple columns.
#'
#' @param x Vector (usually character) of sequence number codes.
#' @return A \code{data.frame} with three columns:
#'   \describe{
#'     \item{sequenceNumber}{
#'       (\code{integer}) The number of the tumor in chronological sequence for
#'       the patient.
#'     }
#'     \item{reportable}{
#'       (\code{logical}) If \code{TRUE}, then the tumor is required to be
#'       reported by SEER/NPCR standards. If \code{FALSE}, it is either
#'       non-malignant or defined as reportable by the registry.
#'     }
#'     \item{onlyTumor}{
#'       (\code{logical}) If \code{TRUE}, this is the only known
#'        SEER/NPCR-reportable or the only known non-SEER/NPCR-reportable tumor
#'        for the patient.
#'     }
#'     \item{sequenceFlag}{
#'       (\code{factor}) Special flags, such as unknowns or changes in reporting
#'       requirements. Created using \code{\link{split_sentineled}}.
#'     }
#'   }
#' @seealso \code{\link{split_sentineled}}
#' @import data.table
#' @export
split_sequence_number <- function(x) {
  out <- split_sentineled(x, "sequenceNumberCentral")
  setDT(out)
  setnames(out, c("sequenceNumber", "sequenceFlag"))
  # Avoid R Check warnings for unbound variables
  sequenceNumber <- npcrReportable <- onlyTumor <- flag <- NULL
  out[
    between(sequenceNumber, 0L, 59L) |
      flag == "unknown, malignant",
    npcrReportable := TRUE
  ][
    between(sequenceNumber, 60L, 87L) |
      flag %in% c("unknown, non-malignant", "cervix carcinoma in situ"),
    npcrReportable := FALSE
  ][
    npcrReportable == FALSE,
    sequenceNumber := sequenceNumber - 60L
  ][
    ,
    onlyTumor := sequenceNumber == 0L
  ][
    onlyTumor == TRUE,
    sequenceNumber := 1L
  ][
    between(sequenceNumber, 89L, 97L),
    ":="(sequenceNumber = NA_integer_, npcrReportable = NA, onlyTumor = NA)
  ]
  setcolorder(out, c("sequenceNumber", "npcrReportable", "onlyTumor", "sequenceFlag"))
  setDF(out)
  out
}


#' List of possible values for a field
#'
#' These lists gives the levels for each categorical or flag field from the
#' NAACCR formats. It is intended to help researchers
#'
#' \code{field_levels} does not include levels representing "unknown."
#' \code{field_levels_all} does include the "unknown" levels.
#'
#' @format A named \code{list}, where the names are for categorical fields or
#'   sentinel flags, and the values are the possible levels for each field.
"field_levels"

#' @rdname field_levels
"field_levels_all"
