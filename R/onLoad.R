#' Convert the NAACCR format tables to actual record_format objects
#' Can only be done during package loading because R cannot find the data
#' objects during the build process.
#' @importFrom utils assignInMyNamespace
#' @noRd
.onLoad <- function(libname, pkgname) {
  assignInMyNamespace("naaccr_format", as.record_format(naaccr_format))
  ver_fmts <- sprintf("naaccr_format_%2d", unique(naaccr_format[["version"]]))
  pkg_ns <- topenv()
  for (name in ver_fmts) {
    fmt <- get(name, envir = pkg_ns)
    assignInMyNamespace(name, as.record_format(fmt))
  }
}
