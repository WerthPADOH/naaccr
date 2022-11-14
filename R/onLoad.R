#' Convert the NAACCR format tables to actual record_format objects
#' Can only be done during package loading because R cannot find the data
#' objects during the build process.
#' @importFrom utils assignInMyNamespace
#' @noRd
.onLoad <- function(libname, pkgname) {
  new_formats <- vector("list", length(naaccr_formats))
  names(new_formats) <- names(naaccr_formats)
  ver_fmts <- names(naaccr_formats)
  format_names <- paste0("naaccr_format_", ver_fmts)
  format_names[nchar(ver_fmts) != 2L] <- NA
  for (ii in seq_along(ver_fmts)) {
    ver_num <- ver_fmts[[ii]]
    fmt <- naaccr_formats[[ver_num]]
    fmt <- as.record_format(fmt)
    new_formats[[ver_num]] <- fmt
    if (!is.na(format_names[ii])) {
      assignInMyNamespace(format_names[ii], fmt)
    }
  }
  assignInMyNamespace("naaccr_formats", new_formats)
}
