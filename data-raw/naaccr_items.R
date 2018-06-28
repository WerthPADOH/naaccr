# Use the NAACCR info from SEER to create the naaccr_items table. This is a
# separate file from the one accessing the API to avoid sending HTTP requests
# unless necessary.
library(data.table)


naaccr_info_from_api <- fread('data-raw/naaccr_info_from_api.csv')
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
    width = end_col - start_col + 1L
  )
]
item_types <- fread("data-raw/item_interpreting_info.csv")
naaccr_xml_info <- fread(
  input  = "data-raw/naaccr-xml-items-180.csv",
  sep    = ",",
  header = TRUE,
  col.names = c(
    "item", "name", "start_col", "width", "record_types", "xml_name",
    "xml_parent"
  ),
  colClasses = c(
    "integer", "character", "integer", "integer", "character", "character",
    "character"
  )
)
naaccr_items[
  naaccr_xml_info,
  on = "item",
  xml_name := xml_name
]

save(naaccr_items, item_types, file = "data-raw/sys-data/naaccr_items.RData")
