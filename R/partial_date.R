#' @noRd
month_days <- c(31L, 28L, 31L, 30L, 31L, 30L, 31L, 31L, 30L, 31L, 30L, 31L)


#' @noRd
is_leap_year <- function(y) {
  (y %% 4L == 0L) & !((y %% 100L) == 0L & (y %% 400L) != 0L)
}


#' @noRd
date_ymd <- function(year, month, day) {
  y <- as.integer(year)
  m <- as.integer(month)
  d <- as.integer(day)
  n <- max(length(y), length(m), length(d))
  y <- rep_len(y, n)
  m <- rep_len(m, n)
  d <- rep_len(d, n)
  date_string <- rep(NA_character_, n)
  no_na <- !(is.na(y) | is.na(m) | is.na(d))
  date_string[no_na] <- sprintf("%04d-%02d-%02d", y[no_na], m[no_na], d[no_na])
  as.Date(date_string)
}


#' Dates without all known parts
#' @param year  Integer of the calendar year.
#' @param month Integer of the month of the year.
#' @param day   Integer of the day of the month.
#' @return A \code{partial_date} object, which mostly acts like a \code{Date}
#'   object. Known parts of the dates can be extracted using the
#'   \code{\link[data.table]{year}}, \code{\link[data.table]{month}}, and
#'   \code{\link[data.table]{mday}} functions.
#' @seealso \code{\link{date_bounds}}, \code{\link{mday}}, \code{\link{month}},
#'   \code{\link{year}}.
#' @examples
#'   p <- partial_date(c(2001, 2002, 2003), c(4, 9, NA), c(1, NA, 5))
#'   p
#'
#'   # Basic arithmetic can make inferences
#'   p - 1
#'
#'   # 30 days from any day in September will be in October
#'   partial_date(2002, 9, NA) + 30
#' @export
partial_date <- function(year, month, day) {
  y <- as.integer(year)
  m <- as.integer(month)
  d <- as.integer(day)
  n <- max(length(y), length(m), length(d))
  y <- rep_len(y, n)
  m <- rep_len(m, n)
  d <- rep_len(d, n)
  month_limit <- month_days[m]
  month_limit[is_leap_year(y) & m == 2L] <- 29L
  invalid <- d < 1L | d > month_limit | m < 1L | m > 12L
  if (any(invalid, na.rm = TRUE)) {
    warning("Impossible day values replaced with NA")
    y[invalid] <- NA
    m[invalid] <- NA
    d[invalid] <- NA
  }
  out <- date_ymd(y, m, d)
  names(out) <- names(y)
  create_partial_date(out, y, m, d)
}


#' @export
#' @rdname partial_date
is.partial_date <- function(x) {
  inherits(x, "partial_date")
}


#' Versatile and efficient builder, but not a good public API
#' @noRd
create_partial_date <- function(dates, y, m, d) {
  dates <- as.Date(dates)
  n <- length(dates)
  attr(dates, "year") <- rep_len(as.integer(y), n)
  attr(dates, "month") <- rep_len(as.integer(m), n)
  attr(dates, "day") <- rep_len(as.integer(d), n)
  class(dates) <- c("partial_date", class(dates))
  names(dates) <- names(dates)
  dates
}


#' @export
as.Date.partial_date <- function(x, ...) {
  out <- as.Date(as.integer(x), origin = as.Date("1970-01-01"), ...)
  names(out) <- names(x)
  out
}


#' @export
as.POSIXlt.partial_date <- function(x, ...) {
  dates <- as.Date(x)
  out <- as.POSIXlt(dates, ...)
  na <- is.na(out)
  if (any(na)) {
    out$year[na] <- year(x)[na]
    out$mon[na] <- month(x)[na]
    out$mday[na] <- mday(x)[na]
    out$sec[na] <- 0L
    out$min[na] <- 0L
    out$hour[na] <- 0L
  }
  out
}


#' @param x Object to be coerced or tested.
#' @param ... Arguments passed to or from other methods.
#'   For \code{as.partial_date}, these are usually passed to
#'   \code{\link[base]{as.POSIXlt}}.
#' @export
#' @rdname partial_date
as.partial_date <- function(x, ...) {
  UseMethod("as.partial_date")
}


#' @export
#' @noRd
as.partial_date.partial_date <- function(x, ...) {
  x
}


#' @export
as.partial_date.default <- function(x, ...) {
  dates <- as.POSIXlt(x, ...)
  as.partial_date(dates)
}


#' @importFrom data.table year month mday
#' @export
as.partial_date.POSIXlt <- function(x, ...) {
  # Break some abstraction for efficiency
  y <- year(x)
  m <- month(x)
  d <- mday(x)
  out <- as.Date(x)
  names(out) <- names(x)
  create_partial_date(out, y, m, d)
}


#' @import data.table
#' @import stringi
#' @export
as.partial_date.character <- function(x, fmt = "%Y%m%d", ...) {
  n <- max(length(x), length(fmt))
  x <- rep_len(x, n)
  fmt <- rep_len(fmt, n)
  supported_fmt <- unique(date_parts[["fmt"]])
  if (any(!fmt %in% supported_fmt)) {
    warning(
      "Where fmt is not supported, partial dates are NA for all components.",
      " Supported formats: ", paste0('"', supported_fmt, '"', collapse = ", ")
    )
  }
  dates <- as.POSIXlt(x, format = fmt, ...)
  y <- year(dates)
  m <- month(dates)
  d <- mday(dates)
  incomplete <- is.na(dates)
  if (any(incomplete)) {
    x_inc <- x[incomplete]
    fmt_inc <- rep_len(fmt, length(x))[incomplete]
    y_subs <- date_parts[list(fmt = fmt_inc, part = "year"), on = c("fmt", "part")]
    y[incomplete] <- stri_sub(x_inc, y_subs[["from"]], y_subs[["to"]])
    m_subs <- date_parts[list(fmt = fmt_inc, part = "month"), on = c("fmt", "part")]
    m[incomplete] <- stri_sub(x_inc, m_subs[["from"]], m_subs[["to"]])
    d_subs <- date_parts[list(fmt = fmt_inc, part = "day"), on = c("fmt", "part")]
    d[incomplete] <- stri_sub(x_inc, d_subs[["from"]], d_subs[["to"]])
    # Don't allow impossible parts
    m <- as.integer(m)
    m[!between(m, 1L, 13L)] <- NA
    d <- as.integer(d)
    d[!between(d, 1L, 31L)] <- NA
    # Dates with all parts but impossible values are not to be trusted
    impossible <- is.na(dates) & !is.na(y) & !is.na(m) & !is.na(d)
    bad_month <- !(between(m, 1L, 13L) | is.na(m))
    bad_day <- !(between(d, 1L, 31L) | is.na(d))
    wrong <- impossible | bad_month | bad_day
    y[wrong] <- NA
    m[wrong] <- NA
    d[wrong] <- NA
  }
  create_partial_date(dates, y, m, d)
}


#' @export
#' @noRd
`[.partial_date` <- function(x, i) {
  create_partial_date(as.Date(x)[i], year(x)[i], month(x)[i], mday(x)[i])
}


#' @export
#' @noRd
`[<-.partial_date` <- function(x, i, value) {
  if (length(i) != length(value)) {
    stop("More elements supplied than there are to replace")
  }
  dates <- as.Date(x)
  y <- year(x)
  m <- month(x)
  d <- mday(x)
  value <- as.partial_date(value)
  dates[i] <- as.Date(value)
  y[i] <- year(value)
  m[i] <- month(value)
  d[i] <- mday(value)
  create_partial_date(dates, y, m, d)
}


#' @export
#' @noRd
`[[.partial_date` <- function(x, i) {
  create_partial_date(as.Date(x)[[i]], year(x)[[i]], month(x)[[i]], mday(x)[[i]])
}


#' @export
#' @noRd
`[[<-.partial_date` <- function(x, i, value) {
  if (length(i) != length(value)) {
    stop("More elements supplied than there are to replace")
  }
  dates <- as.Date(x)
  y <- year(x)
  m <- month(x)
  d <- mday(x)
  value <- as.partial_date(value)
  dates[[i]] <- as.Date(value)
  y[[i]] <- year(value)
  m[[i]] <- month(value)
  d[[i]] <- mday(value)
  create_partial_date(dates, y, m, d)
}


#' Extract parts of a date
#'
#' @param x A datetime object (e.g., \code{\link{partial_date}} or one of the
#'   base \code{\link[base]{DateTimeClasses}}).
#' @param ... Arguments passed to or from other methods.
#' @param value Object used to replace the values of \code{x}.
#' @return
#'   \itemize{
#'     \item{\code{mday}}{
#'       An \code{integer} vector of the day of the month for each value of \code{x}.
#'     }
#'     \item{\code{month}}{
#'       An \code{integer} vector of the month for each value of \code{x}.
#'     }
#'     \item{\code{year}}{
#'       An \code{integer} vector of the year for each value of \code{x}.
#'     }
#'   }
#'
#'   \code{year<-}, \code{month<-} and \code{mday<-} modify the values of \code{x}.
#' @export
#' @rdname date-parts
year <- function(x, ...) UseMethod("year")

#' @importFrom data.table year
#' @export
#' @noRd
year.default <- function(x, ...) data.table::year(x)

#' @export
#' @noRd
year.partial_date <- function(x, ...) attr(x, "year")

#' @export
#' @rdname date-parts
`year<-` <- function(x, value) UseMethod("year<-")

#' @export
#' @noRd
`year<-.partial_date` <- function(x, value) {
  partial_date(year = as.integer(value), month = month(x), day = mday(x))
}


#' @export
#' @rdname date-parts
month <- function(x, ...) UseMethod("month")

#' @importFrom data.table month
#' @export
#' @noRd
month.default <- function(x, ...) data.table::month(x)

#' @export
#' @noRd
month.partial_date <- function(x, ...) attr(x, "month")

#' @export
#' @rdname date-parts
`month<-` <- function(x, value) UseMethod("month<-")

#' @export
#' @noRd
`month<-.partial_date` <- function(x, value) {
  partial_date(year = year(x), month = as.integer(value), day = mday(x))
}


#' @export
#' @rdname date-parts
mday <- function(x, ...) UseMethod("mday")

#' @importFrom data.table mday
#' @export
#' @noRd
mday.default <- function(x, ...) data.table::mday(x)

#' @export
#' @noRd
mday.partial_date <- function(x, ...) attr(x, "day")

#' @export
#' @rdname date-parts
`mday<-` <- function(x, value) UseMethod("mday<-")

#' @export
#' @noRd
`mday<-.partial_date` <- function(x, value) {
  partial_date(year = year(x), month = month(x), day = as.integer(value))
}


#' @export
#' @noRd
print.partial_date <- function(x, ...) {
  ytext <- formatC(year(x), width = 4, flag = "0", format = "d")
  ytext[is.na(year(x))] <- "????"
  mtext <- formatC(month(x), width = 2, flag = "0", format = "d")
  mtext[is.na(month(x))] <- "??"
  dtext <- formatC(mday(x), width = 2, flag = "0", format = "d")
  dtext[is.na(mday(x))] <- "??"
  full_text <- stri_join(ytext, mtext, dtext, sep = "-")
  names(full_text) <- names(x)
  cat("An object of class \"partial_date\"\n")
  print(full_text, ...)
}


#' Get the earliest and latest possible values of a partial date
#'
#' @param x \code{\link{partial_date}} object.
#' @return A \code{data.frame} with two columns containing \code{Date} vectors:
#'   \code{"earliest"} and \code{"latest"}.
#'   Each row is the earliest and latest possible dates for each value of \code{x}.
#' @examples
#'   p <- as.partial_date(c("20050908", "201102", "201202  ", "2015  31"))
#'   date_bounds(p)
#' @import data.table
#' @export
date_bounds <- function(x) {
  if (!is.partial_date(x)) x <- as.partial_date(x)
  y <- year(x)
  m <- month(x)
  d <- mday(x)
  early <- data.table(y = y, m = m, d = d)
  late <- data.table::copy(early)
  na_m <- which(is.na(m))
  na_d <- which(is.na(d))
  set(early, i = na_m, j = "m", value = 1L)
  set(early, i = na_d, j = "d", value = 1L)
  set(late, i = na_m, j = "m", value = 12L)
  max_month <- month_days[m]
  max_month[is_leap_year(y) & m == 2L] <- 29L
  max_month[na_m] <- 31L
  set(late, i = na_d, j = "d", value = max_month[na_d])
  out <- data.frame(
    earliest = date_ymd(early[["y"]], early[["m"]], early[["d"]]),
    latest = date_ymd(late[["y"]], late[["m"]], late[["d"]])
  )
  row.names(out) <- names(x)
  out
}


#' @export
#' @noRd
`+.partial_date` <- function(e1, e2) {
  if (nargs() == 1L) return(e1)
  if (inherits(e1, "Date") && inherits(e2, "Date")) {
    stop('binary + is not defined for "Date" or "partial_date" objects')
  }
  # Easier if e1 is definitely a partial date
  if (!is.partial_date(e1) && is.partial_date(e2)) {
    temp <- e1
    e1 <- e2
    e2 <- temp
  }
  if (inherits(e2, "difftime")) {
    e2 <- switch(attr(e2, "units"),
      secs = e2 / 86400, mins = e2/1440, hours = e2/24, days = e2, weeks = 7 * e2
    )
  }
  orig_bounds <- date_bounds(e1)
  new_bounds <- lapply(orig_bounds, `+`, e2)
  y_agree <- year(new_bounds[["earliest"]]) == year(new_bounds[["latest"]])
  m_agree <- y_agree & month(new_bounds[["earliest"]]) == month(new_bounds[["latest"]])
  d_agree <- new_bounds[["earliest"]] == new_bounds[["latest"]]
  y_agree <- which(y_agree)
  m_agree <- which(m_agree)
  d_agree <- which(d_agree)
  y <- m <- d <- rep_len(NA_integer_, length(new_bounds[["earliest"]]))
  y[y_agree] <- year(new_bounds[["earliest"]][y_agree])
  m[m_agree] <- month(new_bounds[["earliest"]][m_agree])
  d[d_agree] <- mday(new_bounds[["earliest"]][d_agree])
  partial_date(y, m, d)
}


#' @export
#' @noRd
`-.partial_date` <- function(e1, e2) {
  if (is.partial_date(e2)) {
    stop('Can only subtract from "partial_date" objects')
  }
  e1 + -e2
}
