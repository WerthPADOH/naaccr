# Create the code-label dataset for factoring fields
library(data.table)
library(stringi)
library(ISOcodes)

# Create country code file -----------------------------------------------------
country_codes <- ISO_3166_1[
  , c("Alpha_3", "Name", "Official_name", "Common_name")
]
setDT(country_codes)
country_codes <- country_codes[
  is.na(Official_name),
  Official_name := Name
][
  is.na(Common_name),
  Common_name := Name
][
  ,
  list(
    code          = Alpha_3,
    label         = Common_name,
    means_missing = FALSE,
    description   = Official_name
  )
]
custom_countries <- fread("data-raw/custom-country-codes.csv")
country_codes <- rbind(country_codes, custom_countries)
fwrite(country_codes, "data-raw/code-labels/iso_country.csv", quote = TRUE)

# Combine codes ----------------------------------------------------------------
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
