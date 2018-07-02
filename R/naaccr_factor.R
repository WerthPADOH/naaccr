# Factorizing columns

#' Replace NAACCR codes with understandable factors
#' @param x Vector (usually character) of codes.
#' @param field String giving the XML name of the NAACCR field to code.
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
  }
}


naaccr_factor_country <- function(x, full_names = TRUE, ...) {
  country_labels <- if (isTRUE(full_names)) {
    country_codes[["name"]]
  } else if (isFALSE(full_names)) {
    country_codes[["code"]]
  }
  factor(x, levels = country_codes[["code"]], labels = country_labels, ...)
}
