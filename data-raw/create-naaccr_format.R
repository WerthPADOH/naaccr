# Create datasets of all NAACCR format versions
library(data.table)
library(stringi)


format_files <- list.files(
  path       = "data-raw/record-formats",
  pattern    = "^version-\\d+\\.csv$",
  full.names = TRUE
)
names(format_files) <- stri_extract_last_regex(format_files, "\\d+")
format_list <- lapply(
  X = format_files,
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
    name_literal = "character",
    default = "character",
    parent = "character",
    section = "character",
    source = "character",
    year_added = "integer",
    version_added = "character",
    year_retired = "integer",
    version_retired = "character"
  )
)
naaccr_format <- rbindlist(format_list, idcol = "version")
naaccr_format[
  ,
  ":="(
    version = as.integer(version),
    alignment = factor(alignment, c("left", "right")),
    parent = factor(parent, c("NaaccrData", "Patient", "Tumor"))
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
    "version", "name", "item", "start_col", "end_col", "type", "alignment",
    "padding", "name_literal", "default", "parent", "section", "source",
    "year_added", "version_added", "year_retired", "version_retired"
  )
)

format_env <- new.env()
for (number in unique(naaccr_format[["version"]])) {
  sub_format <- naaccr_format[
    version == number,
    list(name, item, start_col, end_col, type, alignment, padding, name_literal, parent)
  ]
  setattr(sub_format, "class", c("record_format", class(sub_format)))
  format_name <- sprintf("naaccr_format_%.0f", number)
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
