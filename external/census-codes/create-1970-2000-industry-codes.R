# Create code-label tables from industry code files provided by the Census
# https://www.census.gov/topics/employment/industry-occupation/guidance/code-lists.html
#
# **Do not use this to edit the code table file!**
# This script is only meant to easily generate the file. Edits should be done in
# the CSV and version controlled.
library(readxl)
library(data.table)
library(stringi)


# Industry 2000 ----------------------------------------------------------------
industry_crosswalk <- read_xls(
  path  = "external/census-codes/industry-crosswalk-90-00-02-07-12.xls",
  sheet = "1990-2012",
  range = "A26:M307",
  col_names = c(
    "census_1990", "naics_1997", "census_2000", "category_2000",
    "naics_2002", "census_2002", "category_2002",
    "naics_2007", "census_2007", "category_2007",
    "naics_2012", "census_2012", "category_2012"
  ),
  col_types = "text"
)
setDT(industry_crosswalk)
industry_crosswalk[
  ,
  description := category_2012
][
  ,
  label := stri_join(
    tolower(substr(description, 1, 1)),
    substr(description, 2, nchar(description))
  )
][
  label == "armed Forces, Branch not specified",
  label := "armed forces, branch not specified"
][
  label == "military Reserves or National Guard",
  label := "Military Reserves or National Guard"
][
  label == "postal Service",
  label := "Postal Service"
][
  ,
  label := stri_replace_all_regex(label, " \\(.*?\\)", "")
][
  ,
  label := stri_replace_all_regex(label, ",? except [^,]*,?", "")
][
  ,
  label := stri_replace_all_regex(label, ", n\\.e\\.c\\.,?", "")
][
  ,
  label := stri_replace_all_fixed(label, "u. S.", "U.S.")
]

# Codes did not change meaning between 1990 and 2000 Census
# In fact, only one code (992) was reused, and it meant the same in both
industry_codes <- industry_crosswalk[
  ,
  list(
    code = c(census_1990, census_2000),
    label = c(label, label),
    means_missing = FALSE,
    description = description
  )
][
  startsWith(code, "New") | startsWith(code, "Old"),
  code := NA
][
  ,
  code := stri_replace_all_regex(code, "\\D", "")
][
  !nzchar(code),
  code := NA
][
  ,
  code := stri_pad_left(code, width = 3, pad = "0")
][
  !is.na(code)
]

industry_codes <- unique(industry_codes)

fwrite(
  industry_codes,
  "data-raw/code-labels/censusIndCode19702000.csv",
  sep = ",",
  quote = TRUE
)
