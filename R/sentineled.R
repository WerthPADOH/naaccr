#' @noRd
sentineled.default <- function(x, sentinels, labels = sentinels, ...) {
  sentinel_id <- match(x, sentinels)
  x[!is.na(sentinel_id)] <- NA
  s <- as.numeric(x)
  attr(s, "sentinels") <- factor(labels[sentinel_id], labels)
  class(s) <- c("sentineled", class(s))
  s
}


#' @noRd
sentineled.numeric <- function(x, sentinels, labels = sentinels, ...) {
  sentinel_num <- suppressWarnings(as.numeric(sentinels))
  sentinel_id <- match(x, sentinel_num)
  sentinel_id[is.na(x)] <- NA
  x[!is.na(sentinel_id)] <- NA
  attr(x, "sentinels") <- factor(labels[sentinel_id], labels)
  class(x) <- c("sentineled", class(x))
  x
}


#' Numeric vectors with different missing levels
#'
#' Creates a numeric vector which can have different "levels" for missing
#' values. Meant for handling fields which employ sentinel values: those with a
#' non-numeric meaning.
#'
#' @param x For \code{sentineled}, a vector to be converted, usually numeric or
#'   character. For the rest, an object of class \code{"sentineled"}.
#' @param sentinels A vector of values with non-numeric meaning.
#' @param labels An optional character vector of labels for the sentinel values
#'   (in the same order as \code{sentinels}).
#' @param ... Futher arguments passed to methods.
#' @return
#'   \code{sentineled} returns an object of class \code{"sentineled"}, which is
#'   a numeric vector the length of \code{x} with a \code{"sentinels"} attribute
#'   the same length. This is an object of class \code{"factor"} and the same
#'   length classifying missing values.
#'
#'   \code{sentinels} returns the \code{"sentinels"} attribute of \code{x}.
#'
#'   \code{levels} is a wrapper for \code{levels(sentinels(x))}.
#' @examples
#'   ages <- c(10, 50, 998, 999)
#'   sentineled(ages, c(998, 999), c("dubious", "not given"))
#'
#'   responses <- c(1:3, "X", "Y")
#'   rs <- sentineled(responses, c("X", "Y"), c("refused", "not asked"))
#'   which(is.na(rs))
#'   levels(rs)
#'   which(sentineled(rs) == "refused")
#' @export
sentineled <- function(x, sentinels, labels = sentinels, ...) {
  UseMethod("sentineled")
}


#' @describeIn sentinels
sentinels <- function(x) {
  attr(x, "sentinels")
}


#' @describeIn sentinels
levels.sentineled <- function(x) {
  levels(sentinels(x))
}


#' @noRd
`[.sentineled` <- function(x, i) {
  xi_num <- as.numeric(x)[i]
  s <- sentineled(xi_num, levels(x))
  attr(s, "sentinels") <- sentinels(x)[i]
  s
}


#' @noRd
`[[.sentineled` <- function(x, i, exact = TRUE) {
  xi_num <- as.numeric(x)[[i]]
  s <- sentineled(xi_num, levels(x))
  attr(s, "sentinels") <- sentinels(x)[i]
  s
}


#' @noRd
`[<-.sentineled` <- function(x, i, value) {
  new_sent <- levels(x)[match(value, levels(x))]
  x_sent <- sentinels(x)
  x_sent[i] <- new_sent
  is_sent <- !is.na(new_sent)
  x_num <- as.numeric(x)
  x_num[i][is_sent] <- NA
  x_num[i][!is_sent] <- as.numeric(value[!is_sent])
  structure(
    .Data = x_num,
    names = names(x),
    sentinels = x_sent,
    class = c("sentineled", class(x_num))
  )
}


#' @noRd
`[[<-.sentineled` <- function(x, i, value) {
  new_sent <- levels(x)[match(value, levels(x))]
  x_sent <- sentinels(x)
  x_sent[[i]] <- new_sent
  is_sent <- !is.na(new_sent)
  x_num <- as.numeric(x)
  x_num[[i]][is_sent] <- NA
  x_num[[i]][!is_sent] <- as.numeric(value[!is_sent])
  structure(
    .Data = x_num,
    names = names(x),
    sentinels = x_sent,
    class = c("sentineled", class(x_num))
  )
}


#' @noRd
print.sentineled <- function(x, ..., quote = FALSE) {
  xchar <- as.character(x)
  xchar[is.na(xchar)] <- paste0("<", as.character(sentinels(x)[is.na(xchar)]), ">")
  print(xchar, quote = quote)
  cat("sentinel values: ")
  if (length(levels(x)) > 0L) {
    cat(
      paste0('"', gsub('"', '\\"', levels(x), fixed = TRUE), '"'),
      sep = " "
    )
  } else {
    cat("<none>")
  }
  cat("\n")
  invisible(x)
}
