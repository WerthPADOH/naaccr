#' @noRd
#' @export
sentineled.default <- function(x, sentinels, labels, ...) {
  if (missing(labels)) {
    labels <- sentinels
  } else if ("" %in% labels) {
    warning("\"\" included in labels, which is also used for non-missing values")
  }
  sentinel_id <- match(x, sentinels)
  x[!is.na(sentinel_id)] <- NA
  s <- as.numeric(x)
  attributes(s) <- attributes(x)
  sents <- factor(labels[sentinel_id], union("", labels))
  sents[!is.na(x)] <- ""
  attr(s, "sentinels") <- sents
  class(s) <- c("sentineled", class(s))
  s
}


#' @noRd
#' @export
sentineled.sentineled <- function(x, sentinels, labels, ...) {
  x
}


#' @noRd
#' @export
sentineled.numeric <- function(x, sentinels, labels, ...) {
  if (missing(labels)) {
    labels <- sentinels
  } else if ("" %in% labels) {
    warning("\"\" included in labels, which is also used for non-missing values")
  }
  sentinel_num <- suppressWarnings(as.numeric(sentinels))
  sentinel_id <- match(x, sentinel_num)
  sentinel_id[is.na(x)] <- NA
  x[!is.na(sentinel_id)] <- NA
  sents <- factor(labels[sentinel_id], union("", labels))
  sents[!is.na(x)] <- ""
  attr(x, "sentinels") <- sents
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
#'   the same length. The \code{"sentinels"} attribute is an object of class
#'   \code{"factor"} and the same length classifying missing values. Its levels
#'   are \code{c("", labels)}; \code{""} is used for non-missing values and is
#'   included to simplify using the sentinels in expressions.
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
#'   sentineled(rs) == "refused"
#' @export
sentineled <- function(x, sentinels, labels = sentinels, ...) {
  UseMethod("sentineled")
}


#' @describeIn sentinels
#' @export
sentinels <- function(x) {
  attr(x, "sentinels")
}


#' @describeIn sentinels
#' @export
levels.sentineled <- function(x) {
  levels(sentinels(x))
}


#' @noRd
#' @export
`[.sentineled` <- function(x, i) {
  xi_num <- as.numeric(x)[i]
  s <- sentineled(xi_num, levels(x)[-1L])
  attr(s, "sentinels") <- sentinels(x)[i]
  s
}


#' @noRd
#' @export
`[[.sentineled` <- function(x, i, exact = TRUE) {
  s <- as.numeric(x)[[i]]
  attr(s, "sentinels") <- sentinels(x)[i]
  class(s) <- c("sentineled", class(s))
  s
}


#' @noRd
#' @export
`[<-.sentineled` <- function(x, i, value) {
  new_sent <- levels(x)[match(value, levels(x))]
  new_sent[!is.na(value) & is.na(new_sent)] <- ""
  x_sent <- sentinels(x)
  x_sent[i] <- new_sent
  is_value <- new_sent == ""
  x_num <- as.numeric(x)
  x_num[i][!is_value] <- NA
  x_num[i][is_value] <- as.numeric(value[is_value])
  structure(
    .Data = x_num,
    names = names(x),
    sentinels = x_sent,
    class = c("sentineled", class(x_num))
  )
}


#' @noRd
#' @export
`[[<-.sentineled` <- function(x, i, value) {
  if (is.na(value)) {
    new_sent  <- NA
    new_value <- NA
  } else if (value %in% levels(x)) {
    new_sent  <- value
    new_value <- NA
  } else {
    new_sent  <- ""
    new_value <- as.numeric(value)
  }
  x_sent <- sentinels(x)
  x_sent[[i]] <- new_sent
  x_num <- as.numeric(x)
  x_num[[i]] <- new_value
  structure(
    .Data = x_num,
    names = names(x),
    sentinels = x_sent,
    class = c("sentineled", class(x_num))
  )
}


#' @noRd
#' @export
print.sentineled <- function(x, ..., quote = FALSE) {
  xchar <- as.character(x)
  names(xchar) <- names(x)
  xchar[is.na(xchar)] <- paste0("<", as.character(sentinels(x)[is.na(xchar)]), ">")
  xchar[is.na(sentinels(x))] <- "NA"
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

#' @noRd
#' @export
format.sentineled <- function(x,
                              ...,
                              trim = FALSE,
                              width = NULL,
                              justify = NULL) {
  x_vec <- setNames(as.vector(x), names(x))
  # Numeric vectors are always right-justified
  if (is.numeric(x_vec)) {
    justify <- "right"
  }
  out <- format(x_vec, trim = trim, width = width, justify = justify, ...)
  sent_char <- as.character(sentinels(x))
  sent_index <- which(nzchar(sent_char, keepNA = TRUE))
  out[sent_index] <- paste0("<", sent_char[sent_index], ">")
  out <- format(out, width = width, justify = justify, ...)
  if (isTRUE(trim)) {
    out <- trimws(out)
  }
  out
}
