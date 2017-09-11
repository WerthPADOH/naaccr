#' NAACCR record table class
#' Subclass of \code{data.frame} for working with NAACCR records
#' @param input Either a string with a file name (containing no \code{\\n}
#'   character), a \code{\link[base]{connection}} object, or the text records
#'   themselves as a character vector.
#' @param ... Arguments of the form \code{tag = value}, where \code{tag} is a
#'   valid NAACCR data item name and \code{value} is the vector of the item's
#'   values.
#' @param naaccr_version An integer specifying which NAACCR format should be
#'   used to parse the records. Only used if \code{input} is given.
#' @export
naaccr_record <- function(input, ..., naaccr_version = NULL) {
  if (is.null(naaccr_version)) {
    naaccr_version <- max(naaccr_items[['naaccr_version']])
  }
  input_data <- if (!missing(input)) {
    read_naaccr(input, naaccr_version)
  } else {
    character_values <- lapply(list(...), as.character)
    as.data.frame(character_values, stringsAsFactors = FALSE)
  }
  as.naaccr_record(input_data)
}


#' Coerce to a naaccr_record dataset
#' Convert objects into \code{naaccr_record} objects, if a method exists.
#' @param x An R object.
#' @param ... Additional arguments passed to or from methods.
#' @return An object of class \code{\link{naaccr_record}}
#' @seealso \code{\link{naaccr_record}}
#' @export
as.naaccr_record <- function(x, ...) {
  UseMethod('as.naaccr_record')
}


#' @rdname as.naaccr_record
#' @export
as.naaccr_record.list <- function(x, ...) {
  x_df <- as.data.frame(x, stringsAsFactors = FALSE)
  as.naaccr_record(x_df)
}


#' @rdname as.naaccr_record
#' @export
as.naaccr_record.data.frame <- function(x, ...) {
  latest_items <- naaccr_items[naaccr_version == max(naaccr_version)]
  normalized_names <- gsub('[^a-z0-9]+', ' ', tolower(names(x)))
  matched_items    <- latest_items[normalized_names, on = 'matching_name']
  record <- as.data.table(x)
  setnames(record, matched_items[['r_name']])
  missing_columns <- setdiff(latest_items[['r_name']], names(record))
  set(
    record,
    i     = NULL,
    j     = missing_columns,
    value = rep(NA_character_, nrow(record))
  )

  record[, ':='(
    # Patient
    Age_at_Diagnosis          = clean_age(Age_at_Diagnosis),
    # Location
    Addr_at_DX_City           = clean_address_city(Addr_at_DX_City),
    Addr_Current_City         = clean_address_city(Addr_Current_City),
    Follow_Up_Contact_City    = clean_address_city(Follow_Up_Contact_City),
    Addr_at_DX_Postal_Code    = clean_postal(Addr_at_DX_Postal_Code),
    Addr_Current_Postal_Code  = clean_postal(Addr_Current_Postal_Code),
    Follow_Up_Contact_Postal  = clean_postal(Follow_Up_Contact_Postal),
    Addr_at_DX_No_Street      = clean_address_number_and_street(Addr_at_DX_No_Street),
    Addr_Current_No_Street    = clean_address_number_and_street(Addr_Current_No_Street),
    Census_Block_Grp_1970_90  = clean_census_block(Census_Block_Grp_1970_90),
    Census_Block_Group_2000   = clean_census_block(Census_Block_Group_2000),
    Census_Block_Group_2010   = clean_census_block(Census_Block_Group_2010),
    Census_Tract_1970_80_90   = clean_census_tract(Census_Tract_1970_80_90),
    Census_Tract_2000         = clean_census_tract(Census_Tract_2000),
    Census_Tract_2010         = clean_census_tract(Census_Tract_2010),
    # Secondary to diagnosis
    Comorbid_Complication_1   = clean_icd_9_cm(Comorbid_Complication_1),
    Comorbid_Complication_2   = clean_icd_9_cm(Comorbid_Complication_2),
    Comorbid_Complication_3   = clean_icd_9_cm(Comorbid_Complication_3),
    Comorbid_Complication_4   = clean_icd_9_cm(Comorbid_Complication_4),
    Comorbid_Complication_5   = clean_icd_9_cm(Comorbid_Complication_5),
    Comorbid_Complication_6   = clean_icd_9_cm(Comorbid_Complication_6),
    Comorbid_Complication_7   = clean_icd_9_cm(Comorbid_Complication_7),
    Comorbid_Complication_8   = clean_icd_9_cm(Comorbid_Complication_8),
    Comorbid_Complication_9   = clean_icd_9_cm(Comorbid_Complication_9),
    Comorbid_Complication_10  = clean_icd_9_cm(Comorbid_Complication_10),
    # Facility
    Archive_FIN               = clean_facility_id(Archive_FIN),
    Following_Registry        = clean_facility_id(Following_Registry),
    Institution_Referred_From = clean_facility_id(Institution_Referred_From),
    Institution_Referred_To   = clean_facility_id(Institution_Referred_To),
    Reporting_Facility        = clean_facility_id(Reporting_Facility)
  )]

  record <- setDF(record)
  class(record) <- c('naaccr_record', class(record))
  record
}
