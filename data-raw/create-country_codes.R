# Create the internal dataset of country codes
# These follow the ISO 3166 standard, plus some custom codes for vague locations
library(data.table)
library(stringi)
library(maps)


country_codes <- unique(maps::iso3166[, c("a3", "ISOname")])
setDT(country_codes)
setnames(country_codes, c("code", "name"))
country_codes <- country_codes[!stri_detect_fixed(code, "?")]
# Remove some duplicate codes, which are territories
country_codes <- country_codes[
  !(code == "CHN" & name != "China") &
    !(code == "FRA" & name != "France")
]
custom_codes <- fread("data-raw/custom-country-codes.csv")
country_codes <- rbind(country_codes, custom_codes)
save(country_codes, file = "data-raw/sys-data/country_codes.RData")
