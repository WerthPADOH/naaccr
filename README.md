naaccr
================

[![Build status](https://travis-ci.org/WerthPADOH/naaccr.svg?branch=master)](https://travis-ci.org/WerthPADOH/naaccr)

Summary
-------

The `naaccr` R package enables researchers to easily read and begin analyzing cancer incidence records stored in the [North American Association of Central Cancer Registries](https://www.naaccr.org/) (NAACCR) file format.

Usage
-----

`naaccr` focuses on two tasks: arranging the records and preparing the fields for analysis.

### Records

The `naaccr_record` class defines objects which store cancer incidence records. It inherits from `data.frame`, and for now only makes sure a dataset has a standard set of columns. While `naaccr_record` has a singular-sounding name, it can contain multiple records as rows.

The `read_naaccr` function creates a `naaccr_record` object from a NAACCR-formatted file.

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
#> Loading required package: sentinel

records <- read_naaccr(record_file, version = 18)
records[1:5, c("maritalStatusAtDx", "race1", "race2", "race3")]
#>   maritalStatusAtDx race1                      race2
#> 1         separated white no further race documented
#> 2          divorced white no further race documented
#> 3           married white no further race documented
#> 4           married white no further race documented
#> 5         separated white no further race documented
#>                        race3
#> 1 no further race documented
#> 2 no further race documented
#> 3 no further race documented
#> 4 no further race documented
#> 5 no further race documented
```

By default, `read_naaccr` reads all fields defined in a format. For example, the NAACCR 18 format used above has 791 fields. Rarely would an analysis need even 100 fields. By specifying which fields to keep, one can improve time and memory efficiency.

``` r
dim(records)
#> [1]  20 791
format(object.size(records))
#> [1] "669832 bytes"
records_slim <- read_naaccr(
  input       = record_file,
  version     = 18,
  keep_fields = c("ageAtDiagnosis", "countyAtDx", "primarySite")
)
dim(records_slim)
#> [1] 20  3
format(object.size(records_slim))
#> [1] "2368 bytes"
```

Like with most classes, one can create a new `naaccr_record` object with the function of the same name. The result will have the given columns.

``` r
nr <- naaccr_record(
  primarySite = "C010",
  dateOfBirth = "19450521"
)
nr[, c("primarySite", "dateOfBirth")]
#>   primarySite dateOfBirth
#> 1        C010  1945-05-21
```

The `as.naaccr_record` function can transform an existing data frame. It does require any existing columns to use NAACCR's XML names.

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

The NAACCR format uses similar schemes for a lot of fields, and the `naaccr` package includes functions to help translate them.

`naaccr_boolean` translates "yes/no" fields. By default, it assumes `"0"` stands for "no", and `"1"` stands for "yes."

``` r
naaccr_boolean(c("0", "1", "2"))
#> [1] FALSE  TRUE    NA
```

Some fields use `"1"` for `FALSE` and `"2"` for `TRUE`. Use the `false_value` parameter to work with these.

``` r
naaccr_boolean(c("0", "1", "2"), false_value = "1")
#> [1]    NA FALSE  TRUE
```

#### Categorical fields

The `naaccr_factor` function translates values using a specific field's category codes.

``` r
naaccr_factor(c("01", "31", "65"), "primaryPayerAtDx")
#> [1] not insured Medicaid    TRICARE    
#> 16 Levels: not insured self-pay ... Indian/Public Health Service
```

#### Numeric with special missing

Some fields contain primarily continuous or count data but also use special codes. One name for this type of code is a "sentinel value." The `naaccr_sentineled` function creates a vector of the `"sentineled"` class.

``` r
rnp <- naaccr_sentineled(c(10, 20, 90, 95, 99, NA), "regionalNodesPositive")
rnp
#> [1] 10                  20                  = 90               
#> [4] positive aspiration unknown             NA                 
#> sentinel values: "" "= 90" "positive aspiration" "positive, NOS" "no nodes examined" "unknown"
```

For more on working with `sentineled` vectors, see the documentation for the `sentinel` package: `help(package="sentinel")`.
