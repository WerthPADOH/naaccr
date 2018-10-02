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
  false_value <- match.arg(false_value)
  bool <- rep_len(NA, length(flag))
  true_value <- if (false_value == '0') '1' else '2'
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
  bool <- rep_len(NA, length(flag))
  bool[flag == '1'] <- TRUE
  bool[flag == '']  <- FALSE
  bool
}
