# Use the NAACCR field descriptions from the SEER API to generate most of the
# data files for coded fields.
library(data.table)
library(xml2)
library(magrittr)
library(stringi)
library(maps)


load("data-raw/naaccr_info_from_api.RData")

naaccr_xml_info <- fread(
  input  = "data-raw/naaccr-xml-items-180.csv",
  sep    = ",",
  header = TRUE,
  col.names = c(
    "item", "name", "start_col", "width", "record_types", "xml_name",
    "xml_parent"
  ),
  colClasses = c(
    "integer", "character", "integer", "integer", "character", "character",
    "character"
  )
)
naaccr_info_from_api[
  naaccr_xml_info,
  on = c("item", "name"),
  xml_name := xml_name
]


parse_documentation <- function(doc_text) {
  doc_text <- doc_text %>%
    stri_replace_all_fixed("&nbsp;", " ", case_insensitive = TRUE) %>%
    stri_replace_all_fixed("<br/>", " ", case_insensitive = TRUE)
  doc_xml <- read_xml(paste0("<body>", doc_text, "</body>"))
  code_rows <- xml_find_all(
    doc_xml,
    paste(
      "//tr[@class='code-row'",
      "and child::td[@class='code-nbr']",
      "and child::td[@class='code-desc']]"
    )
  )
  codes <- code_rows %>%
    xml_find_all("td[@class='code-nbr']") %>%
    xml_text()
  descriptions <- code_rows %>%
    xml_find_all("td[@class='code-desc']") %>%
    xml_text()
  coded_and_described <- nzchar(codes) & nzchar(descriptions)
  list(
    code = codes[coded_and_described],
    description = descriptions[coded_and_described]
  )
}


# Only automate fields where the factor levels are fully documented by NAACCR
documented_factors <- c(
  "afpPostOrchiectomyRange", "ambiguousTerminologyDx", "anemia",
  "autopsy", "casefindingSource", "censusCodSys19708090", "censusOccIndSys7000",
  "censusTrCert19708090", "censusTrPovertyIndictr", "censusTrCertainty2010",
  "censusTractCertainty2020", "chromosome19qLossOfHeterozygosity",
  "chromosome1pLossOfHeterozygosity", "chromosome3Status", "chromosome8qStatus",
  "classOfCase", "cocCodingSysCurrent", "cocCodingSysOriginal",
  "codingSystemForEod", "computedEthnicity", "computedEthnicitySource",
  "creatininePretreatmentUnitOfMeasure", "derivedAjccFlag",
  "derivedSeerClinStgGrp", "derivedSeerCmbMSrc", "derivedSeerCmbNSrc",
  "derivedSeerCmbStgGrp", "derivedSeerCmbTSrc", "derivedSeerPathStgGrp",
  "derivedSummaryStage2018", "diagnosticConfirmation",
  "esophagusAndEgjTumorEpicenter", "estrogenReceptorPercentPositiveOrRange",
  "estrogenReceptorSummary", "estrogenReceptorTotalAllredScore",
  "extranodalExtensionClin", "extranodalExtensionHeadAndNeckClinical",
  "extranodalExtensionPath", "extravascularMatrixPatterns", "fibrosisScore",
  "figoStage", "followUpSource", "followUpSourceCentral",
  "gisCoordinateQuality", "gleasonPatternsClinical",
  "gleasonPatternsPathological", "gleasonTertiaryPattern", "grade",
  "gradePathSystem", "gradePathValue", "hcgPostOrchiectomyRange",
  "hcgPreOrchiectomyRange", "her2IhcSummary", "her2IshSummary",
  "her2OverallSummary", "highRiskHistologicFeatures", "icdRevisionComorbid",
  "icdRevisionNumber", "icdO2ConversionFlag", "icdO3ConversionFlag",
  "industrySource", "invasionBeyondCapsule",
  "ipsilateralAdrenalGlandInvolvement", "jak2", "kitGeneImmunohistochemistry",
  "kras", "laterality", "ldhPostOrchiectomyRange", "ldhPreOrchiectomyRange",
  "lnAssessmentMethodFemoralInguinal", "lnAssessmentMethodParaAortic",
  "lnAssessmentMethodPelvic", "lnDistantAssessmentMethod",
  "lnDistantMediastinalScalene", "lnHeadAndNeckLevels1To3",
  "lnHeadAndNeckLevels4To5", "lnHeadAndNeckLevels6To7", "lnHeadAndNeckOther",
  "lnLaterality", "lnStatusFemoralInguinalParaAorticPelvic", "lymphocytosis",
  "majorVeinInvolvement", "maritalStatusAtDx",
  "methylationOfO6MethylguanineMethyltransferase", "microsatelliteInstability",
  "morphCodingSysCurrent", "morphCodingSysOriginl", "multTumRptAsOnePrim",
  "multigeneSignatureMethod", "naaccrRecordVersion", "nextFollowUpSource",
  "nhiaDerivedHispOrigin", "occupationSource", "oncotypeDxRiskLevelDcis",
  "oncotypeDxRiskLevelInvasive", "overRideAgeSiteMorph", "overRideCs20",
  "overRideHistology", "pathReportType1", "pathReportType2", "pathReportType3",
  "pathReportType4", "pathReportType5", "pediatricStagedBy",
  "pediatricStagingSystem", "peripheralBloodInvolvement", "peritonealCytology",
  outer(
    X = c("phase1", "phase2", "phase3"),
    Y = c(
      "RadiationExternalBeamPlanningTech", "RadiationPrimaryTreatmentVolume",
      "RadiationToDrainingLymphNodes", "RadiationTreatmentModality"
    ),
    FUN = stri_join
  ),
  "pleuralEffusion", "primaryPayerAtDx", "profoundImmuneSuppression",
  "qualityOfSurvival", "raceCodingSysCurrent", "raceCodingSysOriginal",
  "radBoostRxModality", "radiationTreatmentDiscontinuedEarly",
  "radLocationOfRx", "radRegionalRxModality", "radTreatmentVolume",
  "readmSameHosp30Days", "reasonForNoRadiation", "reasonForNoSurgery",
  "recordType", "recurrenceDate1stFlag", "recurrenceType1st", "registryType",
  "residualTumorVolumePostCytoreduction", "responseToNeoadjuvantTherapy",
  "rqrsNcdbSubmissionFlag", "ruralurbanContinuum1993",
  "ruralurbanContinuum2003", "ruralurbanContinuum2013", "rxCodingSystemCurrent",
  "rxDateBrmFlag", "rxDateChemoFlag", "rxDateDxStgProcFlag",
  "rxDateHormoneFlag", "rxDateMostDefinSurgFlag", "rxDateOtherFlag",
  "rxDateRadiationEndedFlag", "rxDateRadiationFlag", "rxDateSurgicalDischFlag",
  "rxDateSurgeryFlag", "rxDateSystemicFlag", "rxHospBrm", "rxHospChemo",
  "rxHospDxStgProc", "rxHospHormone", "rxHospOther", "rxHospPalliativeProc",
  "rxHospRadiation", "rxHospScopeRegLnSur", "rxHospSurgApp2010",
  "rxHospSurgOthRegDis", "rxSummBrm", "rxSummChemo", "rxSummDxStgProc",
  "rxSummHormone", "rxSummOther", "rxSummPalliativeProc", "rxSummRadToCns",
  "rxSummRadiation", "rxSummScopeRegLnSur", "rxSummSurgOthRegDis",
  "rxSummSurgRadSeq", "rxSummSurgicalMargins", "rxSummSystemicSurSeq",
  "rxSummTransplntEndocr", "rxSummTreatmentStatus", "sCategoryClinical",
  "sCategoryPathological", "seerCauseSpecificCod", "seerCodingSysCurrent",
  "seerCodingSysOriginal", "seerOtherCod", "seerSummaryStage1977",
  "seerSummaryStage2000", "seerTypeOfFollowUp", "separateTumorNodules",
  "serumAlbuminPretreatmentLevel", "serumBeta2MicroglobulinPretreatmentLevel",
  "sex", "siteCodingSysCurrent", "siteCodingSysOriginal",
  "spanishHispanicOrigin", "subsqRx2ndcrsDateFlag", "subsqRx3rdcrsDateFlag",
  "subsqRx4thcrsDateFlag", "summaryStage2018", "survFlagActiveFollowup",
  "survFlagPresumedAlive", "thrombocytopenia", "tnmClinDescriptor",
  "tnmClinStagedBy", "tnmEditionNumber", "tnmPathDescriptor", "tnmPathStagedBy",
  "tumorGrowthPattern", stri_join("tumorMarker", 1:3), "typeOfReportingSource",
  "uric2000", "uric2010", "visceralAndParietalPleuralInvasion"
)


code_maps <- naaccr_info_from_api[
  list(xml_name = documented_factors),
  on      = "xml_name",
  nomatch = 0
][
  naaccr_version == max(naaccr_version),
  parse_documentation(documentation),
  by = list(xml_name)
][
  !(stri_detect_fixed(code, "("))
][
  tolower(code) == "blank",
  code := ""
]

code_maps[
  ,
  code_file := paste0("data-raw/code-labels/", xml_name, ".csv")
][
  order(code),
  write.csv(
    x         = .SD[, list(code, label = tolower(description), description)],
    file      = .BY[["code_file"]],
    row.names = FALSE,
    quote     = TRUE
  ),
  by = code_file
]
