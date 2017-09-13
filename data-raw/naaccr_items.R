# Use the NAACCR info from SEER to create the naaccr_items table. This is a
# separate file from the one accessing the API to avoid sending HTTP requests
# unless necessary.
library(data.table)


load('data-raw/naaccr_info_from_api.RData')
naaccr_items <- naaccr_info_from_api[
  ,
  list(
    naaccr_version,
    item,
    name,
    start_col,
    end_col,
    alignment,
    padding_char,
    width         = end_col - start_col + 1L,
    r_name        = tolower(gsub('\\W+', '_', name)),
    matching_name = gsub('[^a-z0-9]+', ' ', tolower(name))
  )
]

item_types <- fread("data-raw/item_interpreting_info.csv")

devtools::use_data(naaccr_items, item_types, internal = TRUE, overwrite = TRUE)
