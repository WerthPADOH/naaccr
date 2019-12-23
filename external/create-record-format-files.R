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


key_header <- add_headers("X-SEERAPI-Key" = Sys.getenv("SEER_API_KEY"))


query_seer_api <- function(...) {
  res <- GET("https://api.seer.cancer.gov", path = c(...), key_header)
  stop_for_status(res)
  content(res, as = "text")
}


# Query details for all items in a format and save results in JSON file
query_format <- function(version, outfile) {
  items <- query_seer_api("rest/naaccr", version) %>%
    parse_json(simplifyDataFrame = TRUE)
  details <- vapply(
    X = items[["item"]],
    FUN = function(num) query_seer_api("rest/naaccr", version, "item", num),
    FUN.VALUE = character(1)
  )
  combined_json <- c("[", paste0(details, collapse = ",\n"), "]")
  out_con <- file(outfile, open = "w", encoding = "UTF-8")
  on.exit(try(close(out_con)), add = TRUE)
  writeLines(combined_json, out_con)
}


versions <- query_seer_api("rest/naaccr/versions") %>%
  parse_json(simplifyDataFrame = TRUE) %>%
  `[[`("version")
version_files <- paste0("external/format-sources/version-", versions, ".json")
needs_queried <- !file.exists(version_files)

for (ii in which(needs_queried)) {
  query_format(version = versions[ii], outfile = version_files[ii])
}

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


create_version_format <- function(format_file) {
  details <- read_json(format_file)
  items <- rbindlist(details, fill = TRUE)
  setnames(
    items,
    old = c("name", "default_value", "padding_char"),
    new = c("name_literal", "default", "padding")
  )
  if (!("section" %in% names(items))) {
    set(items, j = "section", value = NA_character_)
  }
  # If a field has subfields, then it's redundant with them
  is_not_superfield <- vapply(items[["subfield"]], is.null, logical(1))
  items <- items[is_not_superfield]
  set(items, j = "subfield", value = NULL)
  info_table <- parse_info_table(items[["documentation"]])
  items <- info_table[
    items,
    on = "item"
  ][
    ,
    alignment := factor(tolower(alignment), c("left", "right"))
  ]
  items[
    ,
    c("parent", "name") := documentation %>%
      stri_match_first_regex( "<strong>NAACCR XML</strong>:\\s+(\\w+)\\.(\\w+)") %>%
      as.data.table() %>%
      `[`(TRUE, 2:3, with = FALSE)
  ]
  set(items, j = "documentation", value = NULL)
  unique(items)
}


formats <- lapply(version_files, create_version_format)
names(formats) <- versions
naaccr_format <- rbindlist(formats, idcol = "version", use.names = TRUE)
naaccr_format[, version := as.integer(version)]

# A lot of new info introduced in version 18, so back-propagate it
previous <- unique(naaccr_format[["version"]])
previous <- previous[previous < 18]
back_updates <- formats[["18"]][
  ,
  list(
    version = previous,
    name_18 = name,
    parent_18 = parent,
    section_18 = section,
    year_added_18 = year_added,
    version_added_18 = version_added,
    year_retired_18 = year_retired,
    version_retired_18 = version_retired
  ),
  by = item
]

naaccr_format[
  back_updates,
  on = c("version", "item"),
  ":="(
    name = ifelse(is.na(name), name_18, name),
    parent = ifelse(is.na(parent), parent_18, parent),
    section = ifelse(is.na(section), section_18, section),
    year_added = ifelse(is.na(year_added), year_added_18, year_added),
    version_added = ifelse(is.na(version_added), version_added_18, version_added),
    year_retired = ifelse(is.na(year_retired), year_retired_18, year_retired),
    version_retired = ifelse(is.na(version_retired), version_retired_18, version_retired)
  )
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

# Fix incorrect names
naaccr_format[
  item == 3874,
  name := "lnDistantAssessMethod"
][
  item == 3884,
  name := "lnStatusFemorInguinParaaortPelv"
]

# Save the NAACCR-defined formats to files, which should be committed to Git
setcolorder(
  naaccr_format,
  c(
    "version", "name", "item", "start_col", "end_col", "alignment", "padding",
    "name_literal", "default", "parent", "section", "source", "year_added",
    "version_added", "year_retired", "version_retired"
  )
)
for (v in unique(naaccr_format[["version"]])) {
  sub_format <- naaccr_format[version == v][order(item)]
  sub_format[, version := NULL]
  outpath <- paste0("data-raw/record-formats/version-", v, ".csv")
  fwrite(sub_format, outpath, sep = ",", quote = TRUE)
}
