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


#' @export
#' @noRd
rep.partial_date <- function(x, ...) {
  partial_date(
    year = rep(year(x), ...),
    month = rep(month(x), ...),
    day = rep(mday(x), ...)
  )
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
  cat("An object of class \"partial_date\"\n")
  print(format(x), ...)
}


#' Get the earliest and latest possible values of a partial date
#'
#' @param x \code{\link{partial_date}} object.
#' @return \code{date_bounds} returns a \code{data.frame} with two columns
#'   containing \code{Date} vectors: \code{"earliest"} and \code{"latest"}.
#'   Each row is the earliest and latest possible dates for each value of \code{x}.
#'
#'   \code{midpoint_partial_date} returns a \code{Date} vector with the midpoint
#'   dates between each of the lower and upper bounds of values in \code{x}.
#' @examples
#'   p <- as.partial_date(c("20050908", "201102", "201202  ", "2015  31"))
#'   date_bounds(p)
#'   midpoint_partial_date(p)
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
#' @rdname date_bounds
midpoint_partial_date <- function(x) {
  out <- rep_len(NA_integer_, length(x))
  known <- !is.na(x)
  out[known] <- x[known]
  unbounded <- is.na(year(x))
  bounds <- date_bounds(x[!known & !unbounded])
  bounds[] <- lapply(bounds, as.numeric)
  out[!known & !unbounded] <- rowMeans(bounds)
  as.Date(out, origin = as.Date("1970-01-01"))
}

#' @export
#' @noRd
Ops.partial_date <- function(e1, e2) {
  message("I'm in ops!")
  if (nargs() == 1L) stop('unary %s not defined for "partial_date" objects')
  if (is.partial_date(e1)) e1 <- as.Date(e1)
  if (is.partial_date(e2)) e2 <- as.Date(e2)
  NextMethod(.Generic)
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
  out_length <- max(length(e1), length(e2))
  if (length(e1) < out_length) {
    e1 <- rep(e1, length.out = out_length)
  } else if (length(e2) < out_length) {
    e2 <- rep(e2, length.out = out_length)
  }
  out <- rep(partial_date(NA, NA, NA), length.out = out_length)
  simple <- rep_len(FALSE, out_length)
  no_change <- which(e2 == 0)
  out[no_change] <- e1[no_change]
  simple[no_change] <- TRUE
  all_known <- which(!simple & !is.na(e1))
  out[all_known] <- as.partial_date(as.Date(e1)[all_known] + e2[all_known])
  simple[all_known] <- TRUE
  add_na <- is.na(e2)
  simple[add_na] <- TRUE
  y_na <- is.na(year(e1))
  m_na <- is.na(month(e1))
  d_na <- is.na(mday(e1))
  # Handle combos of known/missing parts: ymd subbed with x for missing
  # ymx
  ymx <- which(!simple & !y_na & !m_na & d_na)
  if (length(ymx)) out[ymx] <- partial_algebra_ymx(e1[ymx], e2[ymx])
  # yxd
  yxd <- which(!simple & !y_na & m_na & !d_na)
  if (length(yxd)) out[yxd] <- partial_algebra_yxd(e1[yxd], e2[yxd])
  # xmd
  xmd <- which(!simple & y_na & !m_na & !d_na)
  if (length(xmd)) out[xmd] <- partial_algebra_xmd(e1[xmd], e2[xmd])
  # yxx
  yxx <- which(!simple & !y_na & m_na & d_na)
  if (length(yxx)) out[yxx] <- partial_algebra_yxx(e1[yxx], e2[yxx])
  # xmx has no inferrable parts
  # xxd
  xxd <- which(!simple & y_na & m_na & !d_na)
  if (length(xxd)) out[xxd] <- partial_algebra_xxd(e1[xxd], e2[xxd])
  out
}

#' @noRd
partial_algebra_ymx <- function(e1, e2) {
  orig_bounds <- date_bounds(e1)
  new_bounds <- orig_bounds + e2
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

#' @noRd
partial_algebra_yxd <- function(e1, e2) {
  y <- year(e1)
  d <- mday(e1)
  min_mdays <- rep_len(28L, length(e1))
  leap <- is_leap_year(y)
  min_mdays[leap] <- min_mdays[leap] + 1L
  new_day <- d + e2
  below <- new_day < 1L
  above <- new_day > min_mdays
  maybe_new_year <- new_day > 31L
  new_y <- y
  new_y[below | maybe_new_year] <- NA_integer_
  new_day[below | above] <- NA_integer_
  partial_date(year = new_y, month = NA_integer_, day = new_day)
}

#' @noRd
partial_algebra_xmd <- function(e1, e2) {
  m <- month(e1)
  d <- mday(e1)
  ee <- partial_date(year = 2002, month = m, day = d)
  new_date <- ee + e2
  leap_bounds <- as.Date(c("2001-02-28", "2002-02-28", "2003-02-28"))
  crossed_feb <- findInterval(ee, leap_bounds) != findInterval(new_date, leap_bounds)
  new_date[crossed_feb] <- NA
  partial_date(
    year = year(e1),
    month = replace(m, crossed_feb, NA_integer_),
    day = replace(d, crossed_feb, NA_integer_)
  )
}

#' @noRd
partial_algebra_yxx <- function(e1, e2) {
  y <- year(e1)
  leap <- is_leap_year(y)
  new_y <- rep_len(NA_integer_, length(y))
  one_back <- !leap & (e2 == -365 | (is_leap_year(y - 1L) & e2 == -366))
  new_y[one_back] <- y[one_back] - 1L
  one_forward <- !leap & (e2 == 365 | (is_leap_year(y + 1L) & e2 == 366))
  new_y[one_forward] <- y[one_forward] + 1L
  partial_date(year = new_y, month = NA_integer_, day = NA_integer_)
}

#' @noRd
partial_algebra_xxd <- function(e1, e2) {
  d <- mday(e1)
  new_day <- d + e2
  new_day[!between(new_day, 1L, 28L)] <- NA_integer_
  partial_date(year = NA_integer_, month = NA_integer_, day = new_day)
}

#' @export
#' @noRd
`-.partial_date` <- function(e1, e2) {
  if (is.partial_date(e2)) {
    stop('Can only subtract from "partial_date" objects')
  }
  e1 + -e2
}

#' @noRd
prep_binary_operands <- function(e1, e2) {
  if (!is.partial_date(e1)) e1 <- as.partial_date(e1)
  if (!is.partial_date(e2)) e2 <- as.partial_date(e2)
  if (length(e1) < length(e2)) {
    e1 <- rep(e1, length.out = length(e2))
  } else if (length(e1) > length(e2)) {
    e2 <- rep(e2, length.out = length(e1))
  }
  list(e1 = e1, e2 = e2)
}

#' @export
#' @noRd
`==.partial_date` <- function(e1, e2) {
  message("I'm in ==.partial_date!")
  prepped <- prep_binary_operands(e1, e2)
  e1 <- prepped[["e1"]]
  e2 <- prepped[["e2"]]
  year(e1) == year(e2) & month(e1) == month(e2) & mday(e1) == mday(e2)
}

#' @export
#' @noRd
`!=.partial_date` <- function(e1, e2) {
  !(e1 == e2)
}

#' @export
#' @noRd
`<.partial_date` <- function(e1, e2) {
  prepped <- prep_binary_operands(e1, e2)
  e1 <- prepped[["e1"]]
  e2 <- prepped[["e2"]]
  bounds1 <- date_bounds(e1)
  bounds2 <- date_bounds(e2)
  bounds1[, "latest"] < bounds2[, "earliest"]
}

#' @export
#' @noRd
`>.partial_date` <- function(e1, e2) {
  prepped <- prep_binary_operands(e1, e2)
  e1 <- prepped[["e1"]]
  e2 <- prepped[["e2"]]
  bounds1 <- date_bounds(e1)
  bounds2 <- date_bounds(e2)
  bounds1[, "earliest"] > bounds2[, "latest"]
}

#' @export
#' @noRd
`<=.partial_date` <- function(e1, e2) {
  prepped <- prep_binary_operands(e1, e2)
  e1 <- prepped[["e1"]]
  e2 <- prepped[["e2"]]
  bounds1 <- date_bounds(e1)
  bounds2 <- date_bounds(e2)
  bounds1[, "latest"] <= bounds2[, "earliest"]
}

#' @export
#' @noRd
`>=.partial_date` <- function(e1, e2) {
  prepped <- prep_binary_operands(e1, e2)
  e1 <- prepped[["e1"]]
  e2 <- prepped[["e2"]]
  bounds1 <- date_bounds(e1)
  bounds2 <- date_bounds(e2)
  bounds1[, "earliest"] >= bounds2[, "latest"]
}

#' @inheritParams base::mean.default
#' @param impute_fun Function applied to "impute" partial dates. Will be passed
#'   the \code{partial_date} from \code{x} as an argument and should return a
#'   \code{Date} vector.
#'   By default, uses \code{\link{midpoint_partial_date}}.
#'   If \code{NULL}, no imputation is done. Values with \code{NA} for year,
#'   month or day will be treated as \code{NA}.
#' @export
#' @rdname partial_date
mean.partial_date <- function(x, trim = 0, na.rm = FALSE,
                              impute_fun = midpoint_partial_date, ...) {
  if (!is.null(impute_fun)) {
    impute_fun <- match.fun(impute_fun)
    x <- impute_fun(x)
  }
  mean(as.Date(x), trim = trim, na.rm = na.rm, ...)
}

#' @param format Character string giving the format for printing a partial date.
#'   See \code{\link[base::strptime]{strftime}} for valid components.
#'   See Partial Date Formats below for details.
#' @section Partial Date Formats:
#'   \code{format} will attempt to use what is known about partial dates.
#'   If the year, month and day of a partial date value are all unknown, the
#'   output will be \code{NA}. However, if any part is known, a string will be
#'   returned for that value. In that string, any format components relying on
#'   missing parts will be replaced by one or more question marks (\code{"?"}).
#'
#'   Locale-dependent formats may not behave like they do with \code{Date}
#'   objects. This is because the format is intercepted and broken into parts to
#'   find out where the year, month and day values are inserted.
#'   All locale-dependent formats are replaced with the "standard"
#'   interpretations described in \code{\link[base::strptime]{strftime}}.
#' @importFrom stringi stri_replace_all_fixed stri_extract_all_regex
#' @export
#' @rdname
format.partial_date <- function(x, format = "", ...) {
  format[format == ""] <- "%Y-%m-%d"
  # Violates some locales, but need to know pieces to replace them
  format <- stri_replace_all_fixed(format, "%c", "%a %b %e %H:%M:%S %Y")
  format <- stri_replace_all_fixed(format, "%D", "%m/%d/%y")
  format <- stri_replace_all_fixed(format, "%F", "%Y-%m-%d")
  format <- stri_replace_all_fixed(format, "%h", "%b")
  format <- stri_replace_all_fixed(format, "%x", "%y/%m/%d")
  format <- stri_replace_all_fixed(format, "%+", "%a %b %e %H:%M:%S %Z %Y")
  fmt_specs <- unique(unlist(stri_extract_all_regex(format, "%[a-zA-Z]")))
  names(fmt_specs) <- fmt_specs
  pieces <- outer(
    X = as.POSIXlt(x), Y = fmt_specs,
    FUN = function(values, fmts) format(values, format = fmts)
  )
  totally_missing <- is.na(year(x)) & is.na(month(x)) & is.na(mday(x))
  is_partial <- is.na(x) & !totally_missing
  y_part <- year(x)[is_partial]
  m_part <- month(x)[is_partial]
  d_part <- mday(x)[is_partial]
  if ("%b" %in% colnames(pieces)) {
    b_fmt <- month.abb[m_part]
    abbr_widths <- stri_width(month.abb)
    unknown_abbr <- if (all(abbr_widths == abbr_widths[1L])) {
      stri_dup("?", times = abbr_widths[1L])
    } else {
      "?"
    }
    b_fmt[is.na(m_part)] <- unknown_abbr
    pieces[is_partial, "%b"] <- b_fmt
  }
  if ("%B" %in% colnames(pieces)) {
    B_fmt <- month.name[m_part]
    B_fmt[is.na(m_part)] <- "?"
    pieces[is_partial, "%B"] <- B_fmt
  }
  if ("%C" %in% colnames(pieces)) {
    C_fmt <- formatC(y_part %/% 100, width = 2L, flag = "0", format = "d")
    C_fmt[is.na(y_part)] <- "??"
    pieces[is_partial, "%C"] <- C_fmt
  }
  if ("%d" %in% colnames(pieces)) {
    d_fmt <- formatC(d_part, width = 2L, flag = "0", format = "d")
    d_fmt[is.na(d_part)] <- "??"
    pieces[is_partial, "%d"] <- d_fmt
  }
  if ("%e" %in% colnames(pieces)) {
    e_fmt <- formatC(d_part, format = "d")
    e_fmt[is.na(d_part)] <- "??"
    pieces[is_partial, "%e"] <- e_fmt
  }
  if ("%m" %in% colnames(pieces)) {
    m_fmt <- formatC(m_part, width = 2L, flag = "0", format = "d")
    m_fmt[is.na(m_part)] <- "??"
    pieces[is_partial, "%m"] <- m_fmt
  }
  if ("%y" %in% colnames(pieces)) {
    y_fmt <- formatC(y_part %% 100L, width = 2L, flag = "0", format = "d")
    y_fmt[is.na(y_part)] <- "??"
    pieces[is_partial, "%y"] <- y_fmt
  }
  if ("%Y" %in% colnames(pieces)) {
    Y_fmt <- formatC(y_part, flag = "0", format = "d")
    Y_fmt[is.na(y_part)] <- "????"
    pieces[is_partial, "%Y"] <- Y_fmt
  }

  out <- format
  for (spec in fmt_specs) {
    out <- stri_replace_all_fixed(out, spec, pieces[, spec])
  }
  names(out) <- names(x)
  out
}
