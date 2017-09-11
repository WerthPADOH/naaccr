# Functions for interpreting NAACCR data items.
# All these function take character vectors as input. This is the safest way to
# read NAACCR files because they heavily use sentinel values. Columns which will
# be converted to factors don't need cleaning.

interpret_boolean <- function(flag) {
  bool <- rep_len(NA, length(flag))
  bool[flag == '0'] <- FALSE
  bool[flag == '1'] <- TRUE
  bool
}


#' Interpret NAACCR-formatted dates
#' @param date_literal Character vector of dates in the standard NAACCR format:
#'   \code{"YYYYMMDD"}.
#' @return An object of class \code{POSIXlt}. This allows incomplete dates to
#'   act as \code{NA} in most expressions but retain the known months or years.
#' @examples
#'   x <- c("20120101", "201302  ", "2014    ")
#'   y <- naaccr_date(x)
#'   y
#'   data.table::year(y)
#'   data.table::month(y)
#'   data.table::mday(y)
naaccr_date <- function(date_literal) {
  d <- strptime(date_string, format = '%Y%m%d')
  year_part  <- as.integer(substr(date_string, 1L, 4L))
  month_part <- as.integer(substr(date_string, 5L, 6L))
  day_part   <- as.integer(substr(date_string, 7L, 8L))
  is_incomplete <- is.na(d)
  d$year[is_incomplete] <- year_part[ is_incomplete] - 1900L
  d$mon[ is_incomplete] <- month_part[is_incomplete] - 1L
  d$mday[is_incomplete] <- day_part[  is_incomplete]
  d
}
