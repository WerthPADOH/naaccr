naaccr
================

[![Build
status](https://travis-ci.org/WerthPADOH/naaccr.svg?branch=master)](https://travis-ci.org/WerthPADOH/naaccr)

## Summary

The `naaccr` R package enables researchers to easily read and begin
analyzing cancer incidence records stored in the [North American
Association of Central Cancer Registries](https://www.naaccr.org/)
(NAACCR) file format.

## Usage

`naaccr` focuses on two tasks: arranging the records and preparing the
fields for analysis.

### Records

The `naaccr_record` class defines objects which store cancer incidence
records. It inherits from `data.frame`, and for now only makes sure a
dataset has a standard set of columns. While `naaccr_record` has a
singular-sounding name, it can contain multiple records as rows.

The `read_naaccr` function creates a `naaccr_record` object from a
NAACCR-formatted file.

``` r
record_file <- system.file(
  "extdata/synthetic-naaccr-18-abstract.txt",
  package = "naaccr"
)
record_lines <- readLines(record_file)
## Marital status and race fields
cat(substr(record_lines[1:5], 206, 216), sep = "\n")
#> 30188888888
#> 40188888888
#> 20188888888
#> 20188888888
#> 30188888888
```

``` r
library(naaccr)

records <- read_naaccr(record_file, version = 18)
records[1:5, c("maritalStatusAtDx", "race1", "race2", "race3")]
#>   maritalStatusAtDx race1                      race2                      race3
#> 1         separated white no further race documented no further race documented
#> 2          divorced white no further race documented no further race documented
#> 3           married white no further race documented no further race documented
#> 4           married white no further race documented no further race documented
#> 5         separated white no further race documented no further race documented
```

By default, `read_naaccr` reads all fields defined in a format. For
example, the NAACCR 18 format used above has 791 fields. Rarely would an
analysis need even 100 fields. By specifying which fields to keep, one
can improve time and memory efficiency.

``` r
dim(records)
#> [1]  20 867
records_slim <- read_naaccr(
  input       = record_file,
  version     = 18,
  keep_fields = c("ageAtDiagnosis", "countyAtDx", "primarySite")
)
dim(records_slim)
#> [1] 20  3
```

Like with most classes, one can create a new `naaccr_record` object with
the function of the same name. The result will have the given columns.

``` r
nr <- naaccr_record(
  primarySite = "C010",
  dateOfBirth = "19450521"
)
nr[, c("primarySite", "dateOfBirth")]
#>   primarySite dateOfBirth
#> 1        C010  1945-05-21
```

The `as.naaccr_record` function can transform an existing data frame. It
does require any existing columns to use NAACCR’s XML names.

``` r
prefab <- data.frame(
  ageAtDiagnosis = c(1, 120, 999),
  race1          = c("01", "02", "88")
)
converted <- as.naaccr_record(prefab)
converted[, c("ageAtDiagnosis", "race1")]
#>   ageAtDiagnosis                      race1
#> 1              1                      white
#> 2            120                      black
#> 3             NA no further race documented
```

### Code translation

The NAACCR format uses similar schemes for a lot of fields, and the
`naaccr` package includes functions to help translate them.

`naaccr_boolean` translates “yes/no” fields. By default, it assumes
`"0"` stands for “no”, and `"1"` stands for “yes.”

``` r
naaccr_boolean(c("0", "1", "2"))
#> [1] FALSE  TRUE    NA
```

Some fields use `"1"` for `FALSE` and `"2"` for `TRUE`. Use the
`false_value` parameter to work with these.

``` r
naaccr_boolean(c("0", "1", "2"), false_value = "1")
#> [1]    NA FALSE  TRUE
```

#### Categorical fields

The `naaccr_factor` function translates values using a specific field’s
category codes.

``` r
naaccr_factor(c("01", "31", "65"), "primaryPayerAtDx")
#> [1] not insured Medicaid    TRICARE    
#> 16 Levels: not insured self-pay insurance, NOS ... Indian/Public Health Service
```

Some fields have multiple codes explaining why an actual value isn’t
known. By default, they’ll all be converted to `NA` so they can
propagate that information in R. But the reasons can be useful, so
`naaccr_factor` and `naaccr_record` both have a `keep_unknown`
parameter.

``` r
naaccr_factor(c("1", "9"), field = "sex")
#> [1] male <NA>
#> 6 Levels: male female other transsexual, NOS ... transsexual, natal female
naaccr_factor(c("1", "9"), field = "sex", keep_unknown = TRUE)
#> [1] male    unknown
#> 7 Levels: male female other transsexual, NOS ... unknown
naaccr_record(sex = c("1", "9"), race1 = c("01", "99"), keep_unknown = TRUE)
#>       sex   race1
#> 1    male   white
#> 2 unknown unknown
```

#### Numeric with special missing

Some fields contain primarily continuous or count data but also use
special codes. One name for this type of code is a “sentinel value.” The
`split_sentineled` function splits these fields in two.

``` r
rnp <- split_sentineled(c(10, 20, 90, 95, 99, NA), "regionalNodesPositive")
rnp
#>   regionalNodesPositive regionalNodesPositiveFlag
#> 1                    10                      <NA>
#> 2                    20                      <NA>
#> 3                    NA                     >= 90
#> 4                    NA       positive aspiration
#> 5                    NA                   unknown
#> 6                    NA                      <NA>
```

## Building

``` r
library(devtools)

deps <- packageDescription("naaccr", fields = c("Depends", "Imports", "Suggests"))
deps <- Filter(function(x) any(!is.na(x)), deps)
dep_names <- lapply(deps, function(x) devtools::parse_deps(x)[["name"]])
dep_names <- sort(unlist(dep_names))
dep_list <- paste0("- `", dep_names, "`", collapse = "\n")
```

To build the `naaccr` package, you’ll need the following R packages:

- `data.table`
- `devtools`
- `httr`
- `ISOcodes`
- `jsonlite`
- `magrittr`
- `rmarkdown`
- `roxygen2`
- `rvest`
- `stringi`
- `testthat`
- `utils`
- `XML`
- `xml2`

To document, build, and test the package, run the `build.R` script with
the package’s root as the working directory.

## Project files

First, know this project fills two roles:

1.  Creating a package to work with NAACCR data in R.
2.  Collecting the data needed to process NAACCR files in plain-text and
    machine-readable formats.

<!-- -->

    naaccr/
    ├ R/                  # R files to create the package objects
    ├ data-raw/           # Plain-text data files and scripts for processing them
    │ ├ code-labels/      # Mappings of codes to understandable labels
    │ ├ sentinel-labels/  # Mappings of sentinel values to understandable labels
    │ └ record-formats/   # Tables defining each NAACCR file format
    ├ external/           # Downloaded files and scripts to create files in `data-raw`
    ├ inst/
    │ └ extdata/          # Data files for examples in the documentation
    └ tests/              # tests and data using the `testthat` package

Files in `external` only need to be updated or run when NAACCR publishes
a new or revised format. In that case, refer to the comments in the `.R`
scripts in that directory for where to download the new files.

Think of these scripts as handy tools for generating `data-raw` files.
Some cleaning of their output may be required.

To run `create-record-format-files.R`, you’ll need to create an account
for the [SEER API](https://api.seer.cancer.gov/) from the National
Cancer Institute’s Surveillance, Epidemiology and End Results (SEER)
program. Store the API key as an environment variable named
`SEER_API_KEY`.
