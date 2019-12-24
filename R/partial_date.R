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
  y <- as.integer(year)
  m <- as.integer(month)
  d <- as.integer(day)
  date_string <- sprintf("%04d-%02d-%02d", y, m, d)
  out <- as.Date(date_string)
  names(out) <- names(y)
  create_partial_date(out, y, m, d)
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
  if (is.null(out$zone)) {
    out$zone <- as.POSIXlt(NA)$zone
  }
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
#' @rdname partial_date
#' @export
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
`[.partial_date` <- function(x, i) {
  create_partial_date(as.Date(x)[i], year(x)[i], month(x)[i], mday(x)[i])
}


#' @export
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
`[[.partial_date` <- function(x, i) {
  create_partial_date(as.Date(x)[[i]], year(x)[[i]], month(x)[[i]], mday(x)[[i]])
}


#' @export
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


#' Extract portions of dates
#' @export
#' @rdname partial_date
year <- function(x, ...) UseMethod("year")

#' @importFrom data.table year
#' @export
year.default <- data.table::year

#' @export
year.partial_date <- function(x, ...) attr(x, "year")


#' @export
#' @rdname partial_date
month <- function(x, ...) UseMethod("month")

#' @importFrom data.table month
#' @export
month.default <- data.table::month

#' @export
month.partial_date <- function(x, ...) attr(x, "month")


#' @export
#' @rdname partial_date
mday <- function(x, ...) UseMethod("mday")

#' @importFrom data.table mday
#' @export
mday.default <- data.table::mday

#' @export
mday.partial_date <- function(x, ...) attr(x, "day")


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
