# Rebuild the package from scratch
library(devtools)


source_subprocess <- function(source_file, ...) {
  system2(command = "Rscript", args = source_file, ...)
}


# Internal data
source_subprocess("data-raw/request-naaccr-info.R")
source_subprocess("data-raw/naaccr_items.R")
naaccr_items <- readRDS("data-raw/naaccr_items.rds")
item_types   <- readRDS("data-raw/item_types.rds")
devtools::use_data(naaccr_items, item_types, internal = TRUE, overwrite = TRUE)
