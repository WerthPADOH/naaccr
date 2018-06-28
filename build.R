# Rebuild the package from scratch
library(devtools)
library(testthat)


# Internal data ----------------------------------------------------------------
# Run "data-raw/request-naaccr-info.R" to update the file
# "data-raw/naaccr_info_from_api.csv". Because of our proxy, the script is not
# reliable enough to include in an automated build.
system2(command = "Rscript", args = "data-raw/naaccr_items.R")
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
