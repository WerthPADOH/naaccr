# Create datasets of all NAACCR format versions
library(data.table)
library(stringi)

format_files <- list.files(
  path       = "data-raw/record-formats",
  pattern    = "\\.csv$",
  full.names = TRUE
)
names(format_files) <- stri_extract_last_regex(format_files, "\\d+")
format_list <- lapply(format_files, fread, sep = ",", header = TRUE)
naaccr_format <- rbindlist(format_list, idcol = "version")
naaccr_format[, version := as.integer(version)]

# Add non-format-specific info
field_info <- fread("data-raw/field_info.csv")
naaccr_format[
  field_info,
  on = "item",
  ":="(name = name, type = type)
]

saveRDS(naaccr_format, file = "inst/extdata/naaccr_format.rds")
