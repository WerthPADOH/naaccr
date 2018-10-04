# Factorizing columns

#' Replace NAACCR codes with understandable factors
#' @param x Vector (usually character) of codes.
#' @param field String giving the XML name of the NAACCR field to code.
#' @param ... Additional arguments passed onto \code{\link[base]{factor}}.
#' @param full_names Logical indicating whether the levels should be the full
#'   country names. If \code{FALSE}, the three-character ISO code is used.
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
#' @import data.table
#' @export
naaccr_factor <- function(x, field, ...) {
  if (length(field) != 1L) {
    stop("field should be single string")
  }
  country_fields <- c(
    "addrAtDxCountry", "birthplaceCountry", "addrCurrentCountry",
    "followupContactCountry", "placeOfDeathCountry"
  )
  if (field %in% country_fields) {
    naaccr_factor_country(x, ...)
  } else if (field %in% field_code_scheme[["xml_name"]]) {
    field_scheme <- field_code_scheme[list(xml_name = field), on = "xml_name"]
    codes <- field_codes[field_scheme, on = "scheme"]
    setorderv(codes, "code")
    factor(x, levels = codes[["code"]], labels = codes[["label"]], ...)
  } else {
    warning('"', field, '" not a coded field')
    out <- as.character(x)
    names(out) <- names(x)
    out
  }
}


#' @export
#' @rdname naaccr_factor
naaccr_factor_country <- function(x, full_names = TRUE, ...) {
  country_labels <- if (isTRUE(full_names)) {
    country_codes[["name"]]
  } else if (isFALSE(full_names)) {
    country_codes[["code"]]
  }
  factor(x, levels = country_codes[["code"]], labels = country_labels, ...)
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
  if (field %in% field_sentinel_scheme[["xml_name"]]) {
    field_scheme <- field_sentinel_scheme[list(field), on = "xml_name"]
    sents <- field_sentinels[field_scheme, on = "scheme"]
    setorderv(sents, "sentinel")
    x <- as.character(x)
    x[!nzchar(x)] <- NA
    is_continuous <- !(x %in% sents[["sentinel"]]) & nzchar(x, keepNA = TRUE)
    x_num <- as.numeric(replace(x, !is_continuous, NA))
    x_sent <- factor(x, sents[["sentinel"]], sents[["label"]])
    out <- data.frame(x_num, x_sent)
    names(out) <- c(field, paste0(field, "Flag"))
    out
  } else {
    warning('"', field, '" not a sentineld field')
    out <- data.frame(x)
    names(out) <- field
    out
  }
}
