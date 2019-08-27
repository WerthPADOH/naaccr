# Create the dataset of industry and occupation codes
# The source files are downloaded from CDC's PHIN VADS
# (Public Health Information Network Vocabulary Access and Distribution System)
# Occupation 2010: https://phinvads.cdc.gov/vads/ViewValueSet.action?id=1445D71C-F37F-4504-8B6C-BA48C5A3F4CA
# Industry 2010: https://phinvads.cdc.gov/vads/ViewValueSet.action?id=2E3330DF-CBD5-43E3-A6B7-FF9BFA52680E
#
# **Do not use this to edit the code table file!**
# This script is only meant to easily generate the file. Edits should be done in
# the CSV and version controlled.
library(data.table)
library(stringi)


preprocess_phin <- function(infile, outfile) {
  raw_codes <- fread(
    input      = infile,
    sep        = "\t",
    skip       = 3,
    header     = TRUE,
    colClasses = "character"
  )
  codes <- raw_codes[, 1:2, with = FALSE]
  setnames(codes, c("code", "label"))
  codes[, label := tolower(label)]
  codes[, label := stri_replace_last_fixed(label, " - niosh/nchs", "")]
  codes[, means_missing := FALSE]
  codes[, description := label]
  setorderv(codes, "code")
  fwrite(codes, file = outfile, sep = ",", quote = TRUE)
}


preprocess_phin(
  "ignore/census-codes/PHVS_Occupation_CDC_Census2010_V1.txt",
  "data-raw/code-labels/censusOccCode2010.csv"
)
preprocess_phin(
  "ignore/census-codes/PHVS_Industry_CDC_Census2010.txt",
  "data-raw/code-labels/censusIndCode2010.csv"
)
