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
data_scripts <- list.files("data-raw", "^create-.*\\.R$", full.names = TRUE)
for (script in data_scripts) {
  source_subprocess(script)
}
sys_data_files <- list.files("data-raw/sys-data", full.names  = TRUE)
sys_data_files <- normalizePath(sys_data_files)
sys_objects <- new.env()
for (sdf in sys_data_files) {
  load(sdf, envir = sys_objects)
}
save(list = names(sys_objects), envir = sys_objects, file = "R/sysdata.rda")

# Tests ------------------------------------------------------------------------
results <- devtools::test()
results_df <- as.data.frame(results)
if (any(results_df[["failed"]] > 0 | results_df[["error"]] > 0)) {
  stop("Testing failed")
}

# Build ------------------------------------------------------------------------
devtools::document()
rmarkdown::render("README.Rmd")
devtools::build(binary = FALSE)
devtools::build(binary = TRUE)
