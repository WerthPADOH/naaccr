# Create datasets of all NAACCR format versions
# The CSV files with details for flat file formats were handmade, using data
# from SEER's API (https://api.seer.cancer.gov)
# The XML files with details for the XML formats are from NAACCR. Download them
# from either NAACCR's website (https://www.naaccr.org/xml-data-exchange-standard/)
# or IMS's GitHub (https://github.com/imsweb/naaccr-xml/tree/master/src/main/resources)
library(data.table)
library(stringi)
library(xml2)


flat_format_files <- list.files(
  path       = "data-raw/record-formats",
  pattern    = "^version-\\d+\\.csv$",
  full.names = TRUE
)
names(flat_format_files) <- stri_extract_last_regex(flat_format_files, "\\d+")
formats_flat <- lapply(
  X = flat_format_files,
  FUN = fread,
  sep = ",",
  header = TRUE,
  na.strings = "",
  encoding = "UTF-8",
  colClasses = c(
    name = "character",
    item = "integer",
    start_col = "integer",
    end_col = "integer",
    alignment = "character",
    padding = "character",
    data_type = "character",
    width = "integer",
    name_literal = "character",
    default = "character",
    allow_unlimited_text = "logical",
    parent = "character",
    section = "character",
    source = "character",
    year_added = "integer",
    version_added = "integer",
    year_retired = "integer",
    version_retired = "integer",
    include_incidence = "logical",
    include_confidential = "logical",
    include_abstract = "logical"
  )
)
naaccr_flat <- rbindlist(formats_flat, idcol = "version")


read_xml_format <- function(path) {
  tree <- read_xml(path)
  tree <- xml_ns_strip(tree) # They use a dummy namespace, so ignore it
  item_defs <- xml_find_all(tree, "//ItemDef")
  start_columns <- as.integer(xml_attr(item_defs, "startColumn"))
  widths <- as.integer(xml_attr(item_defs, "length"))
  padding_raw <- xml_attr(item_defs, "padding")
  padding <- rep(" ", length(item_defs))
  padding[endsWith(padding_raw, "Zero")] <- "0"
  alignment <- rep("left", length(item_defs))
  alignment[startsWith(padding_raw, "left")] <- "right"
  unlimited_text <- (xml_attr(item_defs, "allowUnlimitedText") == "true")
  unlimited_text[is.na(unlimited_text)] <- FALSE
  record_types <- xml_attr(item_defs, "recordTypes")
  data.table(
    name = xml_attr(item_defs, "naaccrId"),
    item = as.integer(xml_attr(item_defs, "naaccrNum")),
    start_col = start_columns,
    end_col = start_columns + widths - 1L,
    alignment = alignment,
    padding = padding,
    data_type = xml_attr(item_defs, "dataType"),
    width = widths,
    name_literal = NA_character_,
    default = NA_character_,
    allow_unlimited_text = unlimited_text,
    parent = xml_attr(item_defs, "parentXmlElement"),
    section = NA_character_,
    source = NA_character_,
    year_added = NA_integer_,
    version_added = NA_character_,
    year_retired = NA_integer_,
    version_retired = NA_character_,
    include_incidence = stri_detect_fixed(record_types, "I"),
    include_confidential = stri_detect_fixed(record_types, "C"),
    include_abstract = stri_detect_fixed(record_types, "A")
  )
}


xml_format_files <- list.files(
  path = "data-raw/record-formats",
  pattern = "^naaccr-dictionary-\\d+\\.xml$",
  full.names = TRUE
)
names(xml_format_files) <- stri_extract_first_regex(xml_format_files, "(?<=-)\\d{2}")
formats_xml <- lapply(xml_format_files, read_xml_format)
naaccr_xml <- rbindlist(formats_xml, idcol = "version")

# Combine field info from SEER and NAACCR, prioritizing NAACCR's XML definitions
key_cols <- c("version", "item")
union_key <- unique(rbind(
  naaccr_flat[, key_cols, with = FALSE], naaccr_xml[, key_cols, with = FALSE]
))
naaccr_format <- naaccr_xml[union_key, on = key_cols, nomatch = NA]
fill_in <- naaccr_flat[union_key, on = key_cols, nomatch = NA]
for (column in setdiff(names(naaccr_format), key_cols)) {
  na_values <- is.na(naaccr_format[[column]])
  set(
    naaccr_format, i = which(na_values), j = column,
    value = fill_in[[column]][na_values]
  )
}

naaccr_format[
  ,
  ":="(
    version = as.integer(version),
    alignment = factor(alignment, c("left", "right"))
  )
]

# Add non-official data used by the package
field_info <- fread("data-raw/field_info.csv", encoding = "UTF-8")
naaccr_format[
  field_info,
  on = "item",
  type := factor(type, sort(unique(type)))
]
setcolorder(
  naaccr_format,
  c(
    "version", "name", "item", "start_col", "end_col", "alignment", "padding",
    "type", "data_type", "width", "name_literal", "default",
    "allow_unlimited_text", "parent", "section", "source",
    "year_added", "version_added", "year_retired", "version_retired",
    "include_incidence", "include_confidential", "include_abstract"
  )
)
setorderv(naaccr_format, c("version", "item"))

# Make sure there are no surprises
# No duplicate item IDs in a version
id_dupes <- duplicated(naaccr_format, by = c("version", "item"))
if (any(id_dupes)) {
  stop(sprintf(
    "naaccr_format has %d rows with the same version and item ID as another",
    sum(id_dupes)
  ))
}

# No overlapping columns
overlapping <- naaccr_format[
  !is.na(start_col),
  {
    after_start <- outer(start_col, start_col, `>=`)
    before_end <- outer(start_col, end_col, `<=`)
    overlaps <- after_start & before_end
    diag(overlaps) <- FALSE # Every item overlaps itself
    if (any(overlaps)) {
      overlap_indices <- which(overlaps, arr.ind = TRUE)
      overlap_rows <- unique(as.vector(overlap_indices))
      .SD[overlap_rows, list(version, item, name, start_col, end_col)]
    } else {
      NULL
    }
  },
  by = "version"
]
if (nrow(overlapping)) {
  stop(sprintf(
    "naaccr_format had %d fields that overlapped another field:",
    nrow(overlapping)
  ))
  print(overlapping)
}

# Create a format data set for each version
format_env <- new.env()
for (number in unique(naaccr_format[["version"]])) {
  sub_format <- naaccr_format[
    version == number,
    list(name, item, start_col, end_col, type, alignment, padding, parent, name_literal, width)
  ]
  format_name <- sprintf("naaccr_format_%2d", number)
  format_env[[format_name]] <- sub_format
}

for (column in names(sub_format)) {
  if (is.factor(sub_format[[column]])) {
    set(
      naaccr_format,
      j = column,
      value = factor(naaccr_format[[column]], levels(sub_format[[column]]))
    )
  }
}

save(naaccr_format, file = "data-raw/sys-data/naaccr_format.RData")
save(
  list  = ls(envir = format_env),
  envir = format_env,
  file  = "data-raw/sys-data/naaccr-formats.RData"
)
