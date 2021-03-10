# Get the NAACCR format definitions and documentation from SEER's API
# This script only queries format details if they're not already in an
# `external/format-sources/version-XX.json` file.
# SEER caps its API usage, so try not to overdo it (https://api.seer.cancer.gov)
library(httr)
library(jsonlite)
library(magrittr)
library(data.table)
library(xml2)
library(rvest)
library(stringi)


req_header <- add_headers(
  "X-SEERAPI-Key" = Sys.getenv("SEER_API_KEY"),
  "Accept-Charset" = "utf-8"
)


query_seer_api <- function(...) {
  res <- GET("https://api.seer.cancer.gov", path = c(...), req_header, accept_json())
  stop_for_status(res)
  out <- content(res, as = "text", encoding = "UTF-8")
  res_headers <- headers(res)
  attr(out, "rate_limit_remaining") <- as.integer(res_headers["x-ratelimit-remaining"])
  out
}


# Query details for all items in a format and save results in JSON file
query_format <- function(version, outfile, type = c("flat", "xml")) {
  type <- match.arg(type)
  item_resp <- query_seer_api("rest/naaccr", type, version)
  items <- parse_json(item_resp, simplifyDataFrame = TRUE)
  req_limit <- attr(item_resp, "rate_limit_remaining")
  if (nrow(items) > req_limit) {
    stop(
      "Number of items (", nrow(items), ") exceeds remaining requests ",
      "allowed this hour (", req_limit, ")"
    )
  }
  details <- vapply(
    X = items[["item"]],
    FUN = function(num) query_seer_api("rest/naaccr", type, version, "item", num),
    FUN.VALUE = character(1)
  )
  combined_json <- c("[", paste0(details, collapse = ",\n"), "]")
  out_con <- file(outfile, open = "w", encoding = "UTF-8")
  on.exit(try(close(out_con)), add = TRUE)
  writeLines(combined_json, out_con)
}


flat_versions <- query_seer_api("rest/naaccr/flat/versions") %>%
  parse_json(simplifyDataFrame = TRUE) %>%
  `[[`("version")
xml_versions <- query_seer_api("rest/naaccr/xml/versions") %>%
  parse_json(simplifyDataFrame = TRUE) %>%
  `[[`("version")
flat_outfiles <- paste0("external/format-sources/flat-version-", flat_versions, ".json")
xml_outfiles <- paste0("external/format-sources/xml-version-", xml_versions, ".json")

#---- Use the files to create the format data ----

# Some info is only in a <table> in the HTML-formatted documentation
parse_info_table <- function(doc_html) {
  info <- doc_html %>%
    lapply(read_html) %>%
    lapply(
      xml_find_first,
      xpath = "//table[contains(@class, 'naaccr-summary-table')]"
    ) %>%
    lapply(html_table) %>%
    rbindlist()
  clean_names <- names(info) %>%
    stri_replace_all_fixed("#", "") %>%
    stri_trim_both() %>%
    stri_trans_tolower()
  setnames(info, clean_names)
  mapping <- c(
    "item" = "item",
    "source of standard" = "source",
    "implemented year" = "year_added",
    "year implemented" = "year_added",
    "implemented version" = "version_added",
    "version implemented" = "version_added",
    "retired year" = "year_retired",
    "year retired" = "year_retired",
    "retired version" = "version_retired",
    "version retired" = "version_retired"
  )
  sub_mapping <- mapping[names(mapping) %in% names(info)]
  setnames(info, old = names(sub_mapping), new = sub_mapping)
  column_types <- c(
    item = "integer",
    source = "character",
    year_added = "integer",
    version_added = "character",
    year_retired = "integer",
    version_retired = "character"
  )
  for (column in names(column_types)) {
    values <- if (column %in% names(info)) {
      info[[column]]
    } else {
      rep(NA, nrow(info))
    }
    set(info, j = column, value = as(values, Class = column_types[column]))
  }
  info[
    stri_detect_regex(version_added, "\\D"),
    version_added := NA
  ][
    stri_detect_regex(version_retired, "\\D"),
    version_retired := NA
  ][
    ,
    ":="(
      version_added = as.integer(version_added),
      version_retired = as.integer(version_retired)
    )
  ]
  info[, names(column_types), with = FALSE]
}


create_flat_format <- function(format_file) {
  details <- read_json(format_file)
  items <- rbindlist(details, fill = TRUE)
  setnames(
    items,
    old = c("name", "default_value", "padding_char", "id"),
    new = c("name_literal", "default", "padding", "name")
  )
  items[, width := end_col - start_col + 1L]
  if (!("section" %in% names(items))) {
    set(items, j = "section", value = NA_character_)
  }
  # If a field has subfields, then it's redundant with them
  is_not_superfield <- vapply(items[["subfield"]], is.null, logical(1))
  items <- items[is_not_superfield]
  info_table <- parse_info_table(items[["documentation"]])
  items <- info_table[
    items,
    on = "item"
  ]
  set(items, j = c("subfield", "documentation"), value = NULL)
  unique(items)
}


create_xml_format <- function(format_file) {
  details <- read_json(format_file)
  items <- rbindlist(details, fill = TRUE)
  setnames(
    items,
    old = c("parent_xml_element", "name", "length", "id"),
    new = c("parent", "name_literal", "width", "name")
  )
  if ("start_col" %in% names(items)) {
    items[, end_col := start_col + width - 1L]
  } else {
    set(items, j = c("start_col", "end_col"), value = NA_integer_)
  }
  # rbindlist makes one row for every value in record_types, so flatten that out
  items[, record_types := unlist(record_types)]
  items[
    ,
    ":="(
      include_incidence = "I" %in% record_types,
      include_confidential = "C" %in% record_types,
      include_abstract = "A" %in% record_types
    ),
    by = list(item)
  ]
  set(items, j = "record_types", value = NULL)
  items <- items[, .SD[1], by = list(item)]
  items[
    startsWith(pad_type, "right"), alignment := "left"
  ][
    startsWith(pad_type, "left"), alignment := "right"
  ][
    endsWith(pad_type, "Blank"), padding := " "
  ][
    endsWith(pad_type, "Zero"), padding := "0"
  ]
  set(items, j = c("documentation", "pad_type", "trim_type"), value = NULL)
  items
}


flat_formats <- lapply(flat_outfiles, create_flat_format)
names(flat_formats) <- flat_versions
combined_flat_format <- rbindlist(flat_formats, idcol = "version", use.names = TRUE)
combined_flat_format[, ":="(
  version = as.integer(version),
  alignment = factor(tolower(alignment), c("left", "right"))
)]

xml_formats <- lapply(xml_outfiles, create_xml_format)
names(xml_formats) <- xml_versions
combined_xml_format <- rbindlist(xml_formats, idcol = "version", use.names = TRUE)
combined_xml_format[, ":="(
  version = as.integer(version),
  alignment = factor(tolower(alignment), c("left", "right"))
)]

naaccr_format <- merge(
  combined_flat_format, combined_xml_format,
  by = c("item", "version"), all = TRUE, suffixes = c(".flat", ".xml")
)
# Assume the XML format takes precedence
shared_columns <- setdiff(
  intersect(names(combined_flat_format), names(combined_xml_format)),
  c("item", "version")
)
flat_shared <- paste0(shared_columns, ".flat")
xml_shared <- paste0(shared_columns, ".xml")
for (ii in seq_along(shared_columns)) {
  flat_values <- naaccr_format[[flat_shared[ii]]]
  xml_values <- naaccr_format[[xml_shared[ii]]]
  na_xml <- which(is.na(xml_values))
  set(naaccr_format, j = shared_columns[ii], value = xml_values)
  set(naaccr_format, i = na_xml, j = shared_columns[ii], value = flat_values[na_xml])
}
set(naaccr_format, j = c(flat_shared, xml_shared), value = NULL)

# New information is added in subsequent versions, so back-propagate it
# Also forward-propagate information that's dropped by new versions
propagate_columns <- c(
  "name", "parent", "section", "year_added", "version_added", "year_retired",
  "start_col", "end_col", "version_retired", "data_type", "default", "source",
  "name_literal", "alignment", "padding", "width", "allow_unlimited_text",
  "include_incidence", "include_confidential", "include_abstract"
)


back_propagate <- function(x) {
  if (all(is.na(x)) || all(!is.na(x))) return(x)
  first_i <- which(!is.na(x))[1]
  x[seq_len(first_i - 1)] <- x[first_i]
  x
}


forward_propagate <- function(x) {
  na_x <- is.na(x)
  if (all(na_x) || all(na_x)) return(x)
  valued_i <- which(!na_x)
  replacement <- findInterval(seq_along(x), valued_i)
  x[replacement]
}

naaccr_format[
  order(version),
  c(propagate_columns) := lapply(.SD, back_propagate),
  by = list(item),
  .SDcols = propagate_columns
][
  order(version),
  c(propagate_columns) := lapply(.SD, forward_propagate),
  by = list(item),
  .SDcols = propagate_columns
]

# Retired fields get a name that's just the descriptive name in XML ID-format
# Also some other data found by reading the manuals
# https://www.naaccr.org/data-standards-data-dictionary-version-archive/
retired_fields <- fread(
  "data-raw/record-formats/retired-fields.csv",
  na.strings = "",
  colClasses = c(
    item = "integer",
    name = "character",
    source = "character",
    year_added = "integer",
    version_added = "integer",
    year_retired = "integer",
    version_retired = "integer",
    section = "character",
    parent = "character"
  )
)
naaccr_format[
  retired_fields,
  on = "item",
  ":="(
    name = i.name,
    source = i.source,
    year_added = i.year_added,
    version_added = i.version_added,
    year_retired = i.year_retired,
    version_retired = i.version_retired,
    section = i.section,
    parent = i.parent
  )
]

# Version 1.4 of the XML standard truncated names to be 32 characters max
name_truncations <- fread("data-raw/record-formats/xml-1.4-name-truncations.csv")
naaccr_format[
  name_truncations,
  on = c(name = "old"),
  name := new
]

# Some items were added in version 16, but not implemented until version 18,
# and had their name changed
renamed_items_16 <- c(762, 764, 772, 774, 776)
renames <- naaccr_format[
  version == 18 & item %in% renamed_items_16,
  list(version = 16, item, name_18 = name, name_literal_18 = name_literal)
]
naaccr_format[
  renames,
  on = c("version", "item"),
  ":="(name = name_18, name_literal = name_literal_18)
]

# Save the NAACCR-defined formats to files, which should be committed to Git
setcolorder(
  naaccr_format,
  c(
    "version", "name", "item", "start_col", "end_col", "alignment", "padding",
    "data_type", "width", "name_literal", "default", "allow_unlimited_text",
    "parent", "section", "source",
    "year_added", "version_added", "year_retired", "version_retired",
    "include_incidence", "include_confidential", "include_abstract"
  )
)
for (v in unique(naaccr_format[["version"]])) {
  sub_format <- naaccr_format[version == v][order(item)]
  sub_format[, version := NULL]
  outpath <- paste0("data-raw/record-formats/version-", v, ".csv")
  fwrite(sub_format, outpath, sep = ",", quote = TRUE)
}
