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

  type_columns <- split(item_types[["name"]], item_types[["type"]])
  set(
    record,
    j     = type_columns[["integer"]],
    value = lapply(
      record[, type_columns[["integer"]], with = FALSE],
      as.integer
    )
  )
  set(
    record,
    j     = type_columns[["numeric"]],
    value = lapply(
      record[, type_columns[["numeric"]], with = FALSE],
      as.numeric
    )
  )
  set(
    record,
    j     = type_columns[["Date"]],
    value = lapply(
      record[, type_columns[["Date"]], with = FALSE],
      as.Date,
      format = "%Y%m%d"
    )
  )

  record[, ':='(
    # Patient
    age_at_diagnosis          = clean_age(age_at_diagnosis),
    # Location
    addr_at_dx_city           = clean_address_city(addr_at_dx_city),
    addr_current_city         = clean_address_city(addr_current_city),
    follow_up_contact_city    = clean_address_city(follow_up_contact_city),
    addr_at_dx_postal_code    = clean_postal(addr_at_dx_postal_code),
    addr_current_postal_code  = clean_postal(addr_current_postal_code),
    follow_up_contact_postal  = clean_postal(follow_up_contact_postal),
    addr_at_dx_no_street      = clean_address_number_and_street(addr_at_dx_no_street),
    addr_current_no_street    = clean_address_number_and_street(addr_current_no_street),
    census_block_grp_1970_90  = clean_census_block(census_block_grp_1970_90),
    census_block_group_2000   = clean_census_block(census_block_group_2000),
    census_block_group_2010   = clean_census_block(census_block_group_2010),
    census_tract_1970_80_90   = clean_census_tract(census_tract_1970_80_90),
    census_tract_2000         = clean_census_tract(census_tract_2000),
    census_tract_2010         = clean_census_tract(census_tract_2010),
    # secondary to diagnosis
    comorbid_complication_1   = clean_icd_9_cm(comorbid_complication_1),
    comorbid_complication_2   = clean_icd_9_cm(comorbid_complication_2),
    comorbid_complication_3   = clean_icd_9_cm(comorbid_complication_3),
    comorbid_complication_4   = clean_icd_9_cm(comorbid_complication_4),
    comorbid_complication_5   = clean_icd_9_cm(comorbid_complication_5),
    comorbid_complication_6   = clean_icd_9_cm(comorbid_complication_6),
    comorbid_complication_7   = clean_icd_9_cm(comorbid_complication_7),
    comorbid_complication_8   = clean_icd_9_cm(comorbid_complication_8),
    comorbid_complication_9   = clean_icd_9_cm(comorbid_complication_9),
    comorbid_complication_10  = clean_icd_9_cm(comorbid_complication_10),
    # facility
    archive_fin               = clean_facility_id(archive_fin),
    following_registry        = clean_facility_id(following_registry),
    institution_referred_from = clean_facility_id(institution_referred_from),
    institution_referred_to   = clean_facility_id(institution_referred_to),
    reporting_facility        = clean_facility_id(reporting_facility)
  )]

  record <- setDF(record)
  class(record) <- c('naaccr_record', class(record))
  record
}
