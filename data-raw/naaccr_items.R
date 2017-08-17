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
    padding_char
  )
]

# Add which record types include each item -------------------------------------
naaccr_items[
  naaccr_version == 16L,
  record_type := cut(
    end_col,
    breaks         = c(0L, 3339L, 5564L, 22824L),
    labels         = c('I', 'C', 'A'),
    ordered_result = TRUE
  )
]

devtools::use_data(naaccr_items, internal = TRUE, overwrite = TRUE)
