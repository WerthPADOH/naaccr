# Functions for interpreting NAACCR data items.
# All these function take character vectors as input. This is the safest way to
# read NAACCR files because they heavily use sentinel values. Columns which will
# be converted to factors don't need cleaning.

#' Interpret NAACCR-style booleans
#' @param flag Character vector of flags.
#' @param false_value The flag value to interpret as \code{FALSE}. If \code{"0"}
#'   (default), then \code{"1"} is interpreted as \code{TRUE}. If \code{"1"},
#'   then \code{"2"} is interpreted as \code{TRUE}.
#' @return A \code{logical} vector with the interpreted values of \code{flag}.
#'   Any original values not seen as \code{TRUE} or \code{FALSE} are converted
#'   to \code{NA}.
#' @examples
#'   x <- c("0", "1", "2", "9", NA)
#'   naaccr_boolean(x)
#'   naaccr_boolean(x, false_value = "1")
#' @export
naaccr_boolean <- function(flag, false_value = c('0', '1')) {
  if (is.logical(flag)) {
    return(flag)
  }
  if (is.numeric(flag)) {
    flag <- format(as.integer(flag), scientific = FALSE)
  }
  if (is.numeric(false_value)) {
    false_value <- format(as.integer(false_value), scientific = FALSE)
  }
  false_value <- match.arg(false_value)
  bool <- rep_len(NA, length(flag))
  true_value <- switch(false_value, '0' = '1', '1' = '2')
  bool[flag == false_value] <- FALSE
  bool[flag == true_value]  <- TRUE
  bool
}


#' Interpret basic over-ride flags
#' @param flag Character vector of over-ride flags. Its values should only
#'   include \code{""} (blank), \code{"1"}, and possibly \code{NA}.
#' @return A \code{logical} vector with the interpreted values of \code{flag}.
#'   The interpretation follows these rules: \code{"1"} goes to \code{TRUE}
#'   (reviewed and confirmed as reported), \code{""} (blank) goes to
#'   \code{FALSE} (not reviewed or reviewed and corrected), and all other values
#'   go to \code{NA}.
#' @examples
#'   naaccr_override(c("", "1", NA, "9"))
#' @export
naaccr_override <- function(flag) {
  if (is.numeric(flag)) {
    warning("Provided flag is numeric, so FALSE overrides cannot be identified")
    flag <- format(flag, scientific = FALSE)
  }
  invalid <- !(flag %in% c("1", "", NA))
  if (any(invalid)) {
    warning("Replacing values of flag other than '1' and '' with NA")
    flag[invalid] <- NA
  }
  bool <- rep_len(NA, length(flag))
  bool[flag == '1'] <- TRUE
  bool[flag == '']  <- FALSE
  bool
}


#' Parse NAACCR-formatted dates
#' @param date Character vector of dates in NAACCR format (\code{"YYYYMMDD"}).
#' @return A \code{Date} vector. Any incomplete or invalid dates are converted
#'   to \code{NA}. The original strings can be retrieved with the
#'   \code{\link{naaccr_encode}} function.
#' @examples
#'   input <- c("20151031", "201408  ", "99999999")
#'   d <- naaccr_date(input)
#'   d
#'   naaccr_encode(d, "dateOfDiagnosis")
#' @importFrom stringi stri_pad_right
#' @export
naaccr_date <- function(date) {
  if (!is.character(date) && !is.factor(date)) {
    out <- as.Date(date)
    names(out) <- names(date)
    atts <- attributes(date)
    if ("original" %in% names(atts)) {
      attr(out, "original") <- atts[["original"]]
    }
    return(out)
  }
  original <- stri_pad_right(date, width = 8L, pad = " ")
  out <- as.Date(date, format = "%Y%m%d")
  attr(out, "original") <- original
  out
}


#' Parse NAACCR-formatted datetimes
#' @param datetime Character vector of datetimes in HL7 OBR-7 format
#'   (\code{"YYYYMMDDHHMMSS"}) or the ISO 8601 format for datetimes accurate to
#'   the second (\code{YYYY-MM-DDThh:mm:ss+zz:zz}).
#'   Values containing a hyphen (\code{"-"}) will be assumed to follow ISO 8601,
#'   and other values will be assumed to follow HL7 OBR-7.
#' @inheritParams base::as.POSIXct
#' @return A \code{POSIXct} vector. Any incomplete or invalid datetimes are
#'   converted to \code{NA}. The original strings can be retrieved with the
#'   \code{\link{naaccr_encode}} function.
#' @examples
#'   input <- c("20151031100856", "20140822    ", "99999999")
#'   d <- naaccr_datetime(input)
#'   d
#'   naaccr_encode(d, "pathDateSpecCollect1")
#' @importFrom stringi stri_pad_right
#' @importFrom stringi stri_detect_fixed
#' @importFrom stringi stri_replace_last_regex
#' @export
naaccr_datetime <- function(datetime, tz = "") {
  if (!is.character(datetime) && !is.factor(datetime)) {
    out <- as.POSIXct(datetime)
    names(out) <- names(datetime)
    atts <- attributes(datetime)
    if ("original" %in% names(atts)) {
      attr(out, "original") <- atts[["original"]]
    }
    return(out)
  }
  out <- rep_len(as.POSIXct(NA, tz = tz), length(datetime))
  original <- datetime
  datetime <- trimws(datetime)
  iso <- stri_detect_fixed(datetime, "-")
  iso[is.na(iso)] <- FALSE
  # ISO datetimes
  # The zeros in the default time are intentional.
  # If a datetime is missing year, month, or day, it should fail.
  default_iso <- "0000-00-00T00:00:00+00:00"
  missing_iso <- stri_sub(default_iso, from = stri_length(datetime[iso]) + 1)
  datetime[iso] <- stri_join(datetime[iso], missing_iso)
  # NAACCR uses a colon in time zone offsets, but R does not
  datetime[iso] <- stri_replace_last_regex(
    datetime[iso], "(?<=[+-]\\d{2}):(?=\\d{2}$)", ""
  )
  out[iso] <- as.POSIXct(datetime[iso], format = "%Y-%m-%dT%H:%M:%S%z", tz = tz)
  # HL7 datetimes
  datetime[!iso] <- stri_pad_right(datetime[!iso], width = 14L, pad = "0")
  out[!iso] <- as.POSIXct(datetime[!iso], format = "%Y%m%d%H%M%S", tz = tz)
  attr(out, "original") <- original
  out
}
