# Create the field_sentinels internal dataset
library(data.table)
library(stringi)


code_files <- list.files("data-raw/sentinel-labels", full.names = TRUE)
names(code_files) <- stri_replace_last_fixed(basename(code_files), ".csv", "")
field_sentinels <- rbindlist(
  lapply(code_files, fread, colClasses = "character", encoding = "UTF-8"),
  idcol = "scheme"
)
field_sentinel_scheme <- fread("data-raw/field_sentinel_scheme.csv")
save(
  field_sentinels, field_sentinel_scheme,
  file = "data-raw/sys-data/field_sentinels.RData"
)
