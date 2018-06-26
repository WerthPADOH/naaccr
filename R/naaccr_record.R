#' Analysis-ready NAACCR records
#'
#' Subclass of \code{data.frame} for doing analysis with NAACCR records.
#'
#' While \code{\link{read_naaccr}} creates a \code{data.frame} of only NAACCR
#' fields as \code{character} columns, \code{naaccr_record} creates a
#' \code{data.frame} ready for analysis: columns are of appropriate classes,
#' coded values are replaced with factors, and unknowns are replaced with
#' \code{NA}.
#'
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


#' Assignment by reference if needed
#'
#' Only attempt to apply \code{set} on a \code{data.table} if something will
#' actually be set.
#'
#' @param x,i,j,value Passed onto \code{\link[data.table]{set}}.
#' @return \code{x} is modified by reference and returned invisibly.
#' @import data.table
#' @noRd
safe_set <- function(x, i = NULL, j, value) {
  is_non_empty_i <- is.null(i) | length(i) > 0
  is_non_empty_j <- length(j) > 0
  if (is_non_empty_i && is_non_empty_j) {
    set(x, i, j, value)
  }
  invisible(x)
}


#' @rdname as.naaccr_record
#' @import data.table
#' @export
as.naaccr_record.data.frame <- function(x, ...) {
  latest_items <- naaccr_items[naaccr_version == max(naaccr_version)]
  matched_items <- latest_items[list(names(x)), on = 'xml_name']
  record <- as.data.table(x)
  setnames(record, matched_items[['xml_name']])
  missing_columns <- setdiff(latest_items[['xml_name']], names(record))
  safe_set(record, j = missing_columns, value = NA_character_)

  type_columns <- split(item_types[["name"]], item_types[["type"]])
  safe_set(
    record,
    j     = type_columns[["integer"]],
    value = lapply(
      record[, type_columns[["integer"]], with = FALSE],
      as.integer
    )
  )
  safe_set(
    record,
    j     = type_columns[["numeric"]],
    value = lapply(
      record[, type_columns[["numeric"]], with = FALSE],
      as.numeric
    )
  )
  safe_set(
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
    ageAtDiagnosis          = clean_age(ageAtDiagnosis),
    # Location
    addrAtDxCity            = clean_address_city(addrAtDxCity),
    addrCurrentCity         = clean_address_city(addrCurrentCity),
    followUpContactCity     = clean_address_city(followUpContactCity),
    addrAtDxPostalCode      = clean_postal(addrAtDxPostalCode),
    addrCurrentPostalCode   = clean_postal(addrCurrentPostalCode),
    followUpContactPostal   = clean_postal(followUpContactPostal),
    addrAtDxNoStreet        = clean_address_number_and_street(addrAtDxNoStreet),
    addrCurrentNoStreet     = clean_address_number_and_street(addrCurrentNoStreet),
    censusBlockGrp197090    = clean_census_block(censusBlockGrp197090),
    censusBlockGroup2000    = clean_census_block(censusBlockGroup2000),
    censusBlockGroup2010    = clean_census_block(censusBlockGroup2010),
    censusTract19708090     = clean_census_tract(censusTract19708090),
    censusTract2000         = clean_census_tract(censusTract2000),
    censusTract2010         = clean_census_tract(censusTract2010),
    # secondary to diagnosis
    comorbidComplication1   = clean_icd_9_cm(comorbidComplication1),
    comorbidComplication2   = clean_icd_9_cm(comorbidComplication2),
    comorbidComplication3   = clean_icd_9_cm(comorbidComplication3),
    comorbidComplication4   = clean_icd_9_cm(comorbidComplication4),
    comorbidComplication5   = clean_icd_9_cm(comorbidComplication5),
    comorbidComplication6   = clean_icd_9_cm(comorbidComplication6),
    comorbidComplication7   = clean_icd_9_cm(comorbidComplication7),
    comorbidComplication8   = clean_icd_9_cm(comorbidComplication8),
    comorbidComplication9   = clean_icd_9_cm(comorbidComplication9),
    comorbidComplication10  = clean_icd_9_cm(comorbidComplication10),
    # facility
    archiveFin              = clean_facility_id(archiveFin),
    followingRegistry       = clean_facility_id(followingRegistry),
    institutionReferredFrom = clean_facility_id(institutionReferredFrom),
    institutionReferredTo   = clean_facility_id(institutionReferredTo),
    reportingFacility       = clean_facility_id(reportingFacility)
  )]

  record <- setDF(record)
  class(record) <- c('naaccr_record', class(record))
  record
}
