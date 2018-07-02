# Create the code-label dataset for factoring fields
library(data.table)
library(stringi)


code_files <- list.files("data-raw/code-labels", full.names = TRUE)
names(code_files) <- stri_replace_last_fixed(basename(code_files), ".csv", "")
field_codes <- rbindlist(
  lapply(code_files, fread, colClasses = "character"),
  idcol = "scheme"
)
field_codes[, description := NULL]
field_code_scheme <- fread("data-raw/field_code_scheme.csv")
save(
  field_codes, field_code_scheme,
  file = "data-raw/sys-data/field_codes.RData"
)
