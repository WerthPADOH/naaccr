# Create the code-label dataset for factoring fields
library(data.table)
library(stringi)
library(maps)

# Dynamically create the ISO country code file so it's up to date
country_codes <- unique(maps::iso3166[, c("a3", "ISOname")])
setDT(country_codes)
setnames(country_codes, c("code", "label"))
country_codes <- country_codes[!stri_detect_fixed(code, "?")]
# Remove some duplicate codes, which are territories
country_codes <- country_codes[
  !(code == "CHN" & label != "China") &
    !(code == "FRA" & label != "France")
]
custom_countries <- fread("data-raw/custom-country-codes.csv")
country_codes <- rbind(country_codes, custom_countries)
country_codes[, description := label]
fwrite(country_codes, "data-raw/code-labels/iso_country.csv", quote = TRUE)

# Combine the code-label pairs from all files
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
