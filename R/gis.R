# Helper functions for GIS fields

#' Parse the 14 values from the \code{geocodingQualityCodeDetail} field
#'
#' @param value Character vector of values from the
#'   \code{geocodingQualityCodeDetail} field.
#'   Each value should be 14 characters long or \code{NA}.
#' @return A \code{data.frame} with the following columns:
#'   \describe{
#'     \item{\code{geocodingQualityInputType}}{
#'       (\code{factor}) Type of address given to geocoder.
#'       Has the following levels:
#'       \code{"full address"},
#'       \code{"street only"},
#'       \code{"number, no street"},
#'       \code{"city only"},
#'       \code{"zip and city"},
#'       \code{"zip only"},
#'       \code{"error"}
#'     }
#'     \item{\code{geocodingQualityStreetType}}{
#'       (\code{factor}) Type of street for address.
#'       Has the following levels:
#'       \code{"street"},
#'       \code{"PO box"},
#'       \code{"rural route"},
#'       \code{"highway contract route"},
#'       \code{"star route"},
#'       \code{"error"}
#'     }
#'     \item{\code{geocodingQualityStreet}}{
#'       (\code{factor}) Quality of match for the street name.
#'       Has the following levels:
#'       \code{"100\% match"},
#'       \code{"soundex match"},
#'       \code{"street name different"},
#'       \code{"missing street name"},
#'       \code{"error"}
#'     }
#'     \item{\code{geocodingQualityZip}}{
#'       (\code{factor}) Quality of match for the ZIP code.
#'       Has the following levels:
#'       \code{"100\% match"},
#'       \code{"5th digit different"},
#'       \code{"4th digit different"},
#'       \code{"3rd digit different"},
#'       \code{"2nd digit different"},
#'       \code{"1st digit different"},
#'       \code{"more than one digit different"},
#'       \code{"invalid ZIP"},
#'       \code{"error"}
#'     }
#'     \item{\code{geocodingQualityCity}}{
#'       (\code{factor}) Quality of match for the city name.
#'       Has the following levels:
#'       \code{"100\% match"},
#'       \code{"alias match"},
#'       \code{"soundex match"},
#'       \code{"no match"},
#'       \code{"error"}
#'     }
#'     \item{\code{geocodingQualityCityRefs}}{
#'       (\code{factor}) Number of city reference data sets that don't match the
#'       geocoding result.
#'       Has the following levels:
#'       \code{"all match"},
#'       \code{"1 reference unmatched"},
#'       \code{"2 to 4 references unmatched"},
#'       \code{"5 or more references unmatched"},
#'       \code{"no references matched"},
#'       \code{"error"}
#'     }
#'     \item{\code{geocodingQualityDirectionals}}{
#'       (\code{factor}) Whether the street directionals are present in the
#'       input and feature data sets.
#'       Has the following levels:
#'       \code{"all match"},
#'       \code{"missing feature pre and post directionals"},
#'       \code{"missing input pre and post directionals"},
#'       \code{"both pre and post directionals do not match"},
#'       \code{"feature missing post directional"},
#'       \code{"input missing post directional"},
#'       \code{"post directionals do not match"},
#'       \code{"missing feature pre directional"},
#'       \code{"missing feature pre directional and input post directional"},
#'       \code{"missing feature pre directional and post directionals do not match"},
#'       \code{"missing input pre directional"},
#'       \code{"missing input pre directional and missing feature post directional"},
#'       \code{"missing input pre directional and post directionals do not match"},
#'       \code{"pre directionals do not match"},
#'       \code{"pre directionals do not match and missing feature post directional"},
#'       \code{"pre directionals do not match and missing input post directional"}
#'     }
#'     \item{\code{geocodingQualityQualifiers}}{
#'       (\code{factor}) Whether the address qualifiers are present in the input
#'       and feature data sets.
#'       Has the following levels:
#'       \code{"all match"},
#'       \code{"missing feature pre and post qualifiers"},
#'       \code{"missing input pre and post qualifiers"},
#'       \code{"both pre and post qualifiers do not match"},
#'       \code{"feature missing post qualifier"},
#'       \code{"input missing post qualifier"},
#'       \code{"post qualifiers do not match"},
#'       \code{"missing feature pre qualifier"},
#'       \code{"missing feature pre qualifier and input post qualifier"},
#'       \code{"missing feature pre qualifier and post qualifiers do not match"},
#'       \code{"missing input pre qualifier"},
#'       \code{"missing input pre qualifier and missing feature post qualifier"},
#'       \code{"missing input pre qualifier and post qualifiers do not match"},
#'       \code{"pre qualifiers do not match"},
#'       \code{"pre qualifiers do not match and missing feature post qualifier"},
#'       \code{"pre qualifiers do not match and missing input post qualifier"}
#'     }
#'     \item{\code{geocodingQualityDistance}}{
#'       (\code{factor}) Average distance between the possible matched parcels
#'       and their respective possible matched streets.
#'       Has the following levels:
#'       \code{"< 10m"},
#'       \code{"10m-100m"},
#'       \code{"100m-500m"},
#'       \code{"500m-1km"},
#'       \code{"1km-5km"},
#'       \code{"> 5km"},
#'       \code{"error"}
#'     }
#'     \item{\code{geocodingQualityOutliers}}{
#'       (\code{factor}) Distribution of distances between the possible matched
#'       parcels and their respective possible matched streets.
#'       Has the following levels:
#'       \code{"100\% within 10m"},
#'       \code{"60\% within 10m and 40\% within 100m"},
#'       \code{"60\% within 10m and 40\% within 500m"},
#'       \code{"60\% within 10m and 40\% within 1km"},
#'       \code{"60\% within 10m and 40\% within 5km"},
#'       \code{"60\% within 10m and at least 1 over 5km exists"},
#'       \code{"30\% within 10m and 70\% within 100m"},
#'       \code{"30\% within 10m and 70\% within 500m"},
#'       \code{"30\% within 10m and 70\% within 1km"},
#'       \code{"30\% within 10m and 70\% within 5km"},
#'       \code{"30\% within 10m and at least 1 over 5km exists"},
#'       \code{"error"}
#'     }
#'     \item{\code{geocodingQualityCensusBlockGroups}}{
#'       (\code{factor}) Consistency of geocoded result against Census Block
#'       Group references.
#'       Has the following levels:
#'       \code{"all match"},
#'       \code{"at least one reference different"},
#'       \code{"no Census data"},
#'       \code{"error"}
#'     }
#'     \item{\code{geocodingQualityCensusTracts}}{
#'       (\code{factor}) Consistency of geocoded result against Census Tract
#'       references.
#'       Has the following levels:
#'       \code{"all match"},
#'       \code{"at least one reference different"},
#'       \code{"no Census data"},
#'       \code{"error"}
#'     }
#'     \item{\code{geocodingQualityCensusCounties}}{
#'       (\code{factor}) Consistency of geocoded result against Census County
#'       references.
#'       Has the following levels:
#'       \code{"all match"},
#'       \code{"at least one reference different"},
#'       \code{"no Census data"},
#'       \code{"error"}
#'     }
#'     \item{\code{geocodingQualityRefMatchCount}}{
#'       (\code{integer}) Number of reference data sets matched by geocoding
#'       result.
#'     }
#'   }
#' @importFrom stringi stri_length
#' @importFrom stringi stri_sub
#' @importFrom data.table setDF
#' @importFrom data.table setDT
#' @importFrom data.table set
#' @export
parse_geocoding_quality_codes <- function(value) {
  value <- as.character(value)
  valid <- which(stri_length(value) == 14L)
  vlen <- length(value)
  n_invalid <- vlen - length(valid) - sum(is.na(value))
  if (n_invalid > 0L) {
    warning(
      "Returning NA for ",
      formatC(n_invalid, big.mark = ",", format = "d"),
      " non-missing geocodingQualityCodeDetail values with length other than 14."
    )
  }
  codes <- list(
    geocodingQualityInputType = cbind(
      levels = c("M", "1", "2", "3", "4", "5", "F"),
      labels = c(
        "full address", "street only", "number, no street", "city only",
        "zip and city", "zip only", "error"
      )
    ),
    geocodingQualityStreetType = cbind(
      levels = c("M", "1", "2", "3", "4", "F"),
      labels = c(
        "street", "PO box", "rural route", "highway contract route",
        "star route", "error"
      )
    ),
    geocodingQualityStreet = cbind(
      levels = c("M", "1", "2", "3", "F"),
      labels = c(
        "100% match", "soundex match", "street name different",
        "missing street name", "error"
      )
    ),
    geocodingQualityZip = cbind(
      levels = c("M", "1", "2", "3", "4", "5", "6", "7", "F"),
      labels = c(
        "100% match", "5th digit different", "4th digit different",
        "3rd digit different", "2nd digit different", "1st digit different",
        "more than one digit different", "invalid ZIP", "error"
      )
    ),
    geocodingQualityCity = cbind(
      levels = c("M", "1", "2", "3", "F"),
      labels = c(
        "100% match", "alias match", "soundex match", "no match", "error"
      )
    ),
    geocodingQualityCityRefs = cbind(
      levels = c("M", "1", "2", "3", "4", "F"),
      labels = c(
        "all match", "1 reference unmatched", "2 to 4 references unmatched",
        "5 or more references unmatched", "no references matched", "error"
      )
    ),
    geocodingQualityDirectionals = cbind(
      levels = c(
        "M", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D",
        "E", "F"
      ),
      labels = c(
        "all match", "missing feature pre and post directionals",
        "missing input pre and post directionals",
        "both pre and post directionals do not match",
        "feature missing post directional", "input missing post directional",
        "post directionals do not match", "missing feature pre directional",
        "missing feature pre directional and input post directional",
        "missing feature pre directional and post directionals do not match",
        "missing input pre directional",
        "missing input pre directional and missing feature post directional",
        "missing input pre directional and post directionals do not match",
        "pre directionals do not match",
        "pre directionals do not match and missing feature post directional",
        "pre directionals do not match and missing input post directional"
      )
    ),
    geocodingQualityQualifiers = cbind(
      levels = c(
        "M", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D",
        "E", "F"
      ),
      labels = c(
        "all match", "missing feature pre and post qualifiers",
        "missing input pre and post qualifiers",
        "both pre and post qualifiers do not match",
        "feature missing post qualifier", "input missing post qualifier",
        "post qualifiers do not match", "missing feature pre qualifier",
        "missing feature pre qualifier and input post qualifier",
        "missing feature pre qualifier and post qualifiers do not match",
        "missing input pre qualifier",
        "missing input pre qualifier and missing feature post qualifier",
        "missing input pre qualifier and post qualifiers do not match",
        "pre qualifiers do not match",
        "pre qualifiers do not match and missing feature post qualifier",
        "pre qualifiers do not match and missing input post qualifier"
      )
    ),
    geocodingQualityDistance = cbind(
      levels = c("M", "1", "2", "3", "4", "5", "F"),
      labels = c(
        "< 10m", "10m-100m", "100m-500m", "500m-1km", "1km-5km", "> 5km",
        "error"
      )
    ),
    geocodingQualityOutliers = cbind(
      levels = c("M", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "F"),
      labels = c(
        "100% within 10m",
        "60% within 10m and 40% within 100m",
        "60% within 10m and 40% within 500m",
        "60% within 10m and 40% within 1km",
        "60% within 10m and 40% within 5km",
        "60% within 10m and at least 1 over 5km exists",
        "30% within 10m and 70% within 100m",
        "30% within 10m and 70% within 500m",
        "30% within 10m and 70% within 1km",
        "30% within 10m and 70% within 5km",
        "30% within 10m and at least 1 over 5km exists",
        "error"
      )
    ),
    geocodingQualityCensusBlockGroups = cbind(
      levels = c("M", "1", "2", "F"),
      labels = c(
        "all match", "at least one reference different", "no Census data",
        "error"
      )
    ),
    geocodingQualityCensusTracts = cbind(
      levels = c("M", "1", "2", "F"),
      labels = c(
        "all match", "at least one reference different", "no Census data",
        "error"
      )
    ),
    geocodingQualityCensusCounties = cbind(
      levels = c("M", "1", "2", "F"),
      labels = c(
        "all match", "at least one reference different", "no Census data",
        "error"
      )
    )
  )
  out <- lapply(
    codes,
    FUN = function(ctab) {
      factor(
        rep(NA_character_, vlen),
        levels = ctab[, "levels"],
        labels = ctab[, "labels"]
      )
    }
  )
  setDT(out)
  set(out, j = "geocodingQualityRefMatchCount", value = NA_integer_)
  # All X's means it was manually matched and equivalent to a full match
  # But we don't know the number of matched references, so that's NA
  value[value == "XXXXXXXXXXXXXX"] <- "MMMMMMMMMMMMM "
  if (length(valid) > 0L) {
    for (ii in seq_along(codes)) {
      field <- names(codes)[[ii]]
      lvls <- codes[[ii]][, "levels"]
      lbls <- codes[[ii]][, "labels"]
      value_codes <- stri_sub(value[valid], from = ii, to = ii)
      set(
        out, i = valid, j = field,
        value = factor(value_codes, levels = lvls, labels = lbls)
      )
    }
    ref_count_code <- stri_sub(value[valid], from = 14, to = 14)
    ref_count <- strtoi(ref_count_code, base = 16)
    ref_count[ref_count_code == "F"] <- NA_integer_
    set(out, i = valid, j = "geocodingQualityRefMatchCount", value = ref_count)
  }
  setDF(out)
  out
}
