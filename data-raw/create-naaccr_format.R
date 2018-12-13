# Create datasets of all NAACCR format versions
library(data.table)
library(stringi)

format_files <- list.files(
  path       = "data-raw/record-formats",
  pattern    = "\\.csv$",
  full.names = TRUE
)
names(format_files) <- stri_extract_last_regex(format_files, "\\d+")
format_list <- lapply(format_files, fread, sep = ",", header = TRUE)
naaccr_format <- rbindlist(format_list, idcol = "version")
naaccr_format[, version := as.integer(version)]

# Add non-format-specific info
field_info <- fread("data-raw/field_info.csv")
naaccr_format[
  field_info,
  on = "item",
  ":="(name = name, type = type)
]

save(naaccr_format, file = "data-raw/sys-data/naaccr_format.RData")

format_env <- new.env()
for (number in unique(naaccr_format[["version"]])) {
  sub_format <- naaccr_format[version == number]
  set(sub_format, j = "version", value = NULL)
  setcolorder(
    sub_format,
    c(
      "name", "item", "start_col", "end_col", "type", "alignment", "padding",
      "name_literal"
    )
  )
  setattr(sub_format, "class", c("record_format", class(sub_format)))
  format_name <- sprintf("naaccr_format_%.0f", number)
  format_env[[format_name]] <- sub_format
}

save(
  list  = ls(envir = format_env),
  envir = format_env,
  file  = "data/naaccr-formats.RData"
)
