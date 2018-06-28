# Create the dataset of occupation codes
# The source file is downloaded from CDC's PHIN VADS
# (Public Health Information Network Vocabulary Access and Distribution System)
# https://phinvads.cdc.gov/vads/ViewValueSet.action?id=1445D71C-F37F-4504-8B6C-BA48C5A3F4CA
library(data.table)
library(stringi)


occupation_codes <- fread(
  input      = "data-raw/PHVS_Occupation_CDC_Census2010_V1.txt",
  sep        = "\t",
  skip       = 3,
  header     = TRUE,
  colClasses = "character",
  col.names  = c(
    "code", "name", "preferred_name", "preferred_code", "code_system_oid",
    "code_system_name", "code_system_code", "code_system_version",
    "hl7_table_0396_code"
  )
)
occupation_codes <- occupation_codes[, list(code, name)]
occupation_codes[, name := tolower(name)]
occupation_codes[, name := stri_replace_last_fixed(name, " - niosh/nchs", "")]
save(occupation_codes, file = "data-raw/sys-data/occupation_codes.RData")
