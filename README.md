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
#>   maritalStatusAtDx race1 race2 race3
#> 1         separated    01    88    88
#> 2          divorced    01    88    88
#> 3           married    01    88    88
#> 4           married    01    88    88
#> 5         separated    01    88    88
```

Like with most classes, one can create a new `naaccr_record` object with the function of the same name. The result will have all the necessary columns, each of the correct class. Any columns not provided will be filled with missing values.

``` r
nr <- naaccr_record(
  primarySite         = "C010",
  dateOfBirth         = "19450521"
)
nr[, c("primarySite", "dateOfBirth", "autopsy")]
#>   primarySite dateOfBirth autopsy
#> 1        C010  1945-05-21      NA
```

The `as.naaccr_record` function can transform an existing data frame. It does require any existing columns to use NAACCR's XML names.

``` r
prefab <- data.frame(
  ageAtDiagnosis = c(1, 120, 999),
  race1          = c("01", "02", "88")
)
as.naaccr_record(prefab)[, c("ageAtDiagnosis", "race1", "anemia")]
#>   ageAtDiagnosis race1 anemia
#> 1              1    01   <NA>
#> 2            120    02   <NA>
#> 3             NA    88   <NA>
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

NAACCR's dates follow the `YYYYMMDD` format, which R doesn't recognize. The `naaccr_date` function parses these strings into `Date` vectors.

``` r
naaccr_date("20180720")
#> [1] "2018-07-20 EDT"
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
