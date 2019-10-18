# Create the 1970-2000 Census occupation codes
# https://www.census.gov/topics/employment/industry-occupation/guidance/code-lists.html
#
# **Do not use this to edit the code table file!**
# This script is only meant to easily generate the file. Edits should be done in
# the CSV and version controlled.
library(pdftools)
library(stringi)
library(magrittr)
library(data.table)


# 2000 to SOC crosswalk --------------------------------------------------------
pdf_lines <- pdf_text("external/census-codes/occ2000t.pdf") %>%
  stri_split_lines() %>%
  unlist() %>%
  stri_trim_both() %>%
  stri_subset_regex("^\\d{1,2}$", negate = TRUE) # remove page numbers

line_data <- data.table(
  index = seq_along(pdf_lines),
  code = stri_extract_first_regex(pdf_lines, "^\\d{3}\\b"),
  label = pdf_lines %>%
    stri_replace_all_regex("^\\d{3}\\b", "") %>%
    stri_replace_all_regex("\\b(\\d{2}-\\d{4}|none)\\b", "") %>%
    stri_trans_tolower()
)

code_data <- line_data[!is.na(code), list(index, code)]
label_data <- line_data[!is.na(label), list(index, label)]
occupation_codes <- code_data[
  label_data,
  on = "index",
  roll = TRUE
][
  !is.na(code)
][
  ,
  list(
    label = label %>%
      paste0(collapse = " ") %>%
      stri_replace_all_regex("\\s{2,}", " ") %>%
      stri_trim_both()
  ),
  keyby = list(code)
][
  ,
  ":="(
    means_missing = FALSE,
    description = label
  )
]

fwrite(
  occupation_codes,
  "data-raw/code-labels/censusOccCode19702000.csv",
  sep = ",",
  quote = TRUE
)
