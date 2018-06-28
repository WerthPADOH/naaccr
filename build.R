# Rebuild the package from scratch
library(devtools)
library(testthat)


source_subprocess <- function(source_file, ...) {
  system2(command = "Rscript", args = source_file, ...)
}


# Internal data ----------------------------------------------------------------
# Run "data-raw/request-naaccr-info.R" to update the file
# "data-raw/naaccr_info_from_api.csv". Because of our proxy, the script is not
# reliable enough to include in an automated build.
source_subprocess("data-raw/naaccr_items.R")
source_subprocess("data-raw/create-country_codes.R")
naaccr_items <- readRDS("data-raw/naaccr_items.rds")
item_types   <- readRDS("data-raw/item_types.rds")
devtools::use_data(naaccr_items, item_types, internal = TRUE, overwrite = TRUE)

# Tests ------------------------------------------------------------------------
results <- devtools::test()
results_df <- as.data.frame(results)
if (any(results_df[["failed"]] > 0 | results_df[["error"]] > 0)) {
  stop("Testing failed")
}

# Build ------------------------------------------------------------------------
devtools::document()
devtools::build(binary = TRUE)
