# Convert NAACCR's SAS program for reading records to a table of information.
# The SAS programs come from NAACCR's website
# The naaccr-xml-items-180.csv comes from https://github.com/imsweb/naaccr-xml
library(stringi)
library(data.table)
library(magrittr)


group_fields <- c(419L, 521L, 779L, 1670L, 1690L, 1710L, 1970L)


read_format_source <- function(source_file, naaccr_version) {
  read_function <- if (naaccr_version == 18L) {
    read_format_source_v18
  } else if (naaccr_version %in% 13:16) {
    read_format_source_v13_to_v17
  } else {
    read_format_source_v12
  }
  info <- read_function(source_file)
  is_item <- !is.na(info[["name_literal"]])
  all_tems <- unique(info[is_item])
  all_tems[!(item %in% group_fields)]
}


read_format_source_v18 <- function(source_file) {
  info <- fread(
    source_file,
    sep = ",",
    header = TRUE,
    col.names = c(
      "item", "name_literal", "start_col", "width", "record_type", "xml_name",
      "parent"
    )
  )
  info[, end_col := start_col + width - 1L]
  info
}


read_format_source_v13_to_v17 <- function(sas_file) {
  read_pattern <- stri_join(
    "^input\\s+@(\\d+)",    # Start column
    "N\\d+_(\\d+)",         # Item number
    "\\$char(\\d+)",        # Field width
    "label.*?'\\d+_(.*?)'", # Item name
    sep = ".*?"
  )
  info <- stri_read_lines(sas_file) %>%
    stri_match_first_regex(read_pattern, case_insensitive = TRUE)
  info <- as.data.table(info[, -1])
  setnames(info, c("start_col", "item", "width", "name_literal"))
  integer_columns <- c("start_col", "item", "width")
  info[
    ,
    (integer_columns) := lapply(.SD, as.integer),
    .SDcols = integer_columns
  ]
  info[, end_col := start_col + width - 1L]
  # Remove NPCR-specific fields
  info <- info[item < 8000L]
  info
}


read_format_source_v12 <- function(sas_file) {
  read_pattern <- stri_join(
    "^input\\s+N\\d+_(\\d+)", # Item number
    "\\$\\s+(\\d+)-(\\d+)",   # Start and end column
    "label.*?'\\d+_(.*?)'",   # Item name
    sep = ".*?"
  )
  info <- stri_read_lines(sas_file) %>%
    stri_match_first_regex(read_pattern, case_insensitive = TRUE)
  info <- as.data.table(info[, -1L])
  setnames(info, c("item", "start_col", "end_col", "name_literal"))
  integer_columns <- c("item", "start_col", "end_col")
  info[
    ,
    (integer_columns) := lapply(.SD, as.integer),
    .SDcols = integer_columns
  ]
  info
}


write_record_format <- function(record_format, outpath) {
  out_data <- record_format[, c("item", "name_literal", "start_col", "end_col")]
  write.csv(
    x         = out_data,
    file      = outpath,
    row.names = FALSE
  )
}


version_files <- data.table(
  version = c(12L, 13L, 14L, 15L, 16L, 18L),
  infile = file.path(
    "ignore/format-sources",
    c(
      "SASstatementsForNAACCRV12ReadWrite.sas",
      "SASReadWriteNAACCRV_13.sas",
      "SASReadWriteNAACCRV_14WithCERPCORVars-3.sas",
      "ReadWriteNAACCR_V15 with CER PCOR variables.sas",
      "ReadWriteNAACCR_V16 with CER PCOR variables.sas",
      "naaccr-xml-items-180.csv"
    )
  )
)
version_files[
  ,
  ":="(
    format_data = mapply(
      FUN            = read_format_source,
      source_file    = infile,
      naaccr_version = version,
      SIMPLIFY       = FALSE
    ),
    outfile     = file.path(
      "data-raw/record-formats",
      paste0("version-", version, ".csv")
    )
  )
]


for (ii in seq_len(nrow(version_files))) {
  write_record_format(
    version_files[["format_data"]][[ii]],
    version_files[["outfile"]][[ii]]
  )
}
