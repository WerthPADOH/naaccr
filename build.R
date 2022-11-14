# Rebuild the package from scratch
library(devtools)
library(testthat)
library(rmarkdown)


source_subprocess <- function(source_file, ...) {
  system2(command = "Rscript", args = source_file, ...)
}


# Internal data ----------------------------------------------------------------
# Run "data-raw/request-naaccr-info.R" to update the file
# "data-raw/naaccr_info_from_api.csv". Because of our proxy, the script is not
# reliable enough to include in an automated build.
if (dir.exists("data")) {
  unlink("data", recursive = TRUE)
}
dir.create("data")
if (dir.exists("data-raw/sys-data")) {
  unlink("data-raw/sys-data", recursive = TRUE)
}
dir.create("data-raw/sys-data")
data_scripts <- list.files("data-raw", "^create-.*\\.R$", full.names = TRUE)
for (script in data_scripts) {
  source_subprocess(script)
}
sys_data_files <- list.files("data-raw/sys-data", full.names  = TRUE)
sys_objects <- new.env()
for (sdf in sys_data_files) {
  load(sdf, envir = sys_objects)
}
save(
  list = names(sys_objects), envir = sys_objects, file = "R/sysdata.rda",
  version = 2, compress = "xz"
)

# Tests ------------------------------------------------------------------------
results <- devtools::test()
results_df <- as.data.frame(results)
if (any(results_df[["failed"]] > 0 | results_df[["error"]] > 0)) {
  stop("Testing failed")
}

# Build ------------------------------------------------------------------------
devtools::document()
old_opts <- options(width = 80)
rmarkdown::render("README.Rmd")
options(old_opts)
description <- readLines("DESCRIPTION")
description <- description[!startsWith(tolower(description), "roxygen")]
writeLines(description, "DESCRIPTION")
built_path <- devtools::build(binary = FALSE)
devtools::build(binary = TRUE)
check_results <- devtools::check_built(built_path)

if (length(check_results[["notes"]])) {
  message(paste0(check_results[["notes"]], collapse = "\n\n"))
}
if (length(check_results[["warnings"]])) {
  warning(paste0(check_results[["errors"]], collapse = "\n\n"))
}
if (length(check_results[["errors"]])) {
  stop(paste0(check_results[["errors"]], collapse = "\n\n"))
}
