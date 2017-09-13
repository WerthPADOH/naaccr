setClass(
  "partial_date",
  contains = "Date",
  slots = c(
    year  = "integer",
    month = "integer",
    day   = "integer"
  )
)


#' Dates without all known parts
#' @param year  Integer of the calendar year.
#' @param month Integer of the month of the year.
#' @param day   Integer of the day of the month.
#' @return A \code{partial_date} object, which mostly acts like a \code{Date}
#'   object. Known parts of the dates can be extracted using the
#'   \code{\link[data.table]{year}}, \code{\link[data.table]{month}}, and
#'   \code{\link[data.table]{mday}} functions.
#' @export
partial_date <- function(year, month, day) {
  year  <- as.integer(year)
  month <- as.integer(month)
  day   <- as.integer(day)
  date_string <- sprintf("%04d-%02d-%02d", year, month, day)
  date_vector <- as.Date(date_string)
  new(
    "partial_date",
    date_vector,
    year  = year,
    month = month,
    day   = day
  )
}


setMethod(
  "[",
  "partial_date",
  function(x, i) {
    partial_date(
      year  = x@year[i],
      month = x@month[i],
      day   = x@day[i]
    )
  }
)


setMethod(
  "[<-",
  "partial_date",
  function(x, i, value) {
    partial_date(
      year  = replace(x@year,  i, value@year[i]),
      month = replace(x@month, i, value@month[i]),
      day   = replace(x@day,   i, value@day[i])
    )
  }
)


setMethod("year",  "partial_date", function(x) x@year)
setMethod("month", "partial_date", function(x) x@month)
setMethod("mday",  "partial_date", function(x) x@day)


setMethod(
  "print",
  "partial_date",
  function(x, ...) {
    cat("An object of class \"partial_date\"\n")
    callNextMethod()
  }
)
