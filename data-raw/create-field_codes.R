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
custom_countries <- fread("data-raw/custom-country-codes.csv", encoding = "UTF-8")
country_codes <- rbind(country_codes, custom_countries)
fwrite(country_codes, "data-raw/code-labels/iso_country.csv", quote = TRUE)

# Combine field_codes ----------------------------------------------------------
code_files <- list.files("data-raw/code-labels", full.names = TRUE)
names(code_files) <- stri_replace_last_fixed(basename(code_files), ".csv", "")
field_codes <- rbindlist(
  lapply(
    code_files,
    fread,
    encoding = "UTF-8",
    colClasses = c(
      code = "character",
      label = "character",
      means_missing = "logical",
      description = "character"
    )
  ),
  idcol = "scheme"
)
field_codes[, description := NULL]
field_code_scheme <- fread("data-raw/field_code_scheme.csv")
setkeyv(field_codes, c("scheme", "code"))
setkeyv(field_code_scheme, "name")
save(
  field_codes, field_code_scheme,
  file = "data-raw/sys-data/field_codes.RData",
  version = 2
)

# Create field_sentinels -------------------------------------------------------
sent_files <- list.files("data-raw/sentinel-labels", full.names = TRUE)
names(sent_files) <- stri_replace_last_fixed(basename(sent_files), ".csv", "")
field_sentinels <- rbindlist(
  lapply(sent_files, fread, colClasses = "character", encoding = "UTF-8"),
  idcol = "scheme"
)
field_sentinel_scheme <- fread("data-raw/field_sentinel_scheme.csv")
setkeyv(field_sentinels, c("scheme", "sentinel"))
setkeyv(field_sentinel_scheme, "name")
save(
  field_sentinels, field_sentinel_scheme,
  file = "data-raw/sys-data/field_sentinels.RData",
  version = 2
)

# Create field_levels and field_levels_all -------------------------------------
code_levels <- field_code_scheme[
  field_codes,
  on = "scheme",
  allow.cartesian = TRUE,
  list(name, label, means_missing)
]
sent_levels <- field_sentinel_scheme[
  field_sentinels,
  on = "scheme",
  allow.cartesian = TRUE,
  list(name, label)
]

all_levels <- rbind(code_levels, sent_levels, fill = TRUE)
known_levels <- all_levels[means_missing == FALSE | is.na(means_missing)]
field_levels_all <- split(all_levels[["label"]], all_levels[["name"]])
field_levels <- split(known_levels[["label"]], known_levels[["name"]])
save(field_levels, field_levels_all, file = "data/field_levels.RData", version = 2)
