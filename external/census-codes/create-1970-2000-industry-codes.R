# Create code-label tables from industry code files provided by the Census
# https://www.census.gov/topics/employment/industry-occupation/guidance/code-lists.html
#
# **Do not use this to edit the code table file!**
# This script is only meant to easily generate the file. Edits should be done in
# the CSV and version controlled.
library(readxl)
library(data.table)


# Industry 2000 ----------------------------------------------------------------
industry_crosswalk <- read_xls(
  path  = "ignore/census-codes/industry-crosswalk-90-00-02-07-12.xls",
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
  label := paste0(
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
  label := gsub(" \\(.*?\\)", "", label)
][
  ,
  label := gsub(",? except [^,]*,?", "", label)
][
  ,
  label := gsub(", n\\.e\\.c\\.,?", "", label)
][
  ,
  label := gsub("u. S.", "U.S.", label, fixed = TRUE)
]

setorderv(industry_crosswalk, "census_2000")
industry_codes <- industry_crosswalk[
  !is.na(census_2000)
][
  order(census_2000),
  list(
    code = census_2000,
    label = label,
    means_missing = FALSE,
    description = description)
]

fwrite(
  industry_codes,
  "data-raw/code-labels/censusIndCode19702000.csv",
  sep = ",",
  quote = TRUE
)
