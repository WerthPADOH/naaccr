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
  "afpPostOrchiectomyRange",
  "afpPreOrchiectomyRange",
  "afpPretreatmentInterpretation",
  "ambiguousTerminologyDx",
  "anemia",
  "autopsy",
  "bilirubinPretreatmentUnitOfMeasure",
  "brainMolecularMarkers",
  "ca125PretreatmentInterpretation",
  "casefindingSource",
  "ceaPretreatmentInterpretation",
  "censusCodSys19708090",
  "censusIndCode19702000",
  "censusIndCode2010",
  "censusOccCode19702000",
  "censusOccCode2010",
  "censusOccIndSys7000",
  "censusTrCert19708090",
  "censusTrCertainty2000",
  "censusTrCertainty2010",
  "censusTrPovertyIndictr",
  "censusTractCertainty2020",
  "chromosome3Status",
  "chromosome8qStatus",
  "classOfCase",
  "cocAccreditedFlag",
  "cocCodingSysCurrent",
  "cocCodingSysOriginal",
  "codingSystemForEod",
  "computedEthnicity",
  "computedEthnicitySource",
  "creatininePretreatmentUnitOfMeasure",
  "derivedAjccFlag",
  "derivedSeerClinStgGrp",
  "derivedSeerCmbMSrc",
  "derivedSeerCmbNSrc",
  "derivedSeerCmbStgGrp",
  "derivedSeerCmbTSrc",
  "derivedSeerPathStgGrp",
  "derivedSs1977",
  "derivedSs1977Flag",
  "derivedSs2000",
  "derivedSs2000Flag",
  "derivedSummaryStage2018",
  "diagnosticConfirmation",
  "esophagusAndEgjTumorEpicenter",
  "extranodalExtensionClin",
  "extranodalExtensionHeadAndNeckClinical",
  "extranodalExtensionPath",
  "fibrosisScore",
  "figoStage",
  "followUpSource",
  "followUpSourceCentral",
  "gisCoordinateQuality",
  "gleasonPatternsClinical",
  "gleasonPatternsPathological",
  "gleasonTertiaryPattern",
  "grade",
  "gradeIcdO1",
  "gradePathSystem",
  "gradePathValue",
  "hcgPostOrchiectomyRange",
  "hcgPreOrchiectomyRange",
  "her2IhcSummary",
  "her2IshSummary",
  "highRiskHistologicFeatures",
  "icdO2ConversionFlag",
  "icdO3ConversionFlag",
  "icdRevisionComorbid",
  "icdRevisionNumber",
  "industrySource",
  "invasionBeyondCapsule",
  "ipsilateralAdrenalGlandInvolvement",
  "jak2",
  "kitGeneImmunohistochemistry",
  "kras",
  "laterality",
  "ldhPostOrchiectomyRange",
  "ldhPreOrchiectomyRange",
  "ldhPretreatmentLevel",
  "lnAssessmentMethodFemoralInguinal",
  "lnAssessmentMethodParaAortic",
  "lnAssessmentMethodPelvic",
  "lnDistantAssessmentMethod",
  "lnDistantMediastinalScalene",
  "lnHeadAndNeckLevels1To3",
  "lnHeadAndNeckLevels4To5",
  "lnHeadAndNeckLevels6To7",
  "lnHeadAndNeckOther",
  "lnLaterality",
  "lnStatusFemoralInguinalParaAorticPelvic",
  "lymphocytosis",
  "majorVeinInvolvement",
  "maritalStatusAtDx",
  "medicalRecordNumber",
  "methylationOfO6MethylguanineMethyltransferase",
  "microsatelliteInstability",
  "militaryRecordNoSuffix",
  "morphCodingSysCurrent",
  "morphCodingSysOriginl",
  "multTumRptAsOnePrim",
  "multigeneSignatureMethod",
  "naaccrRecordVersion",
  "nextFollowUpSource",
  "nhiaDerivedHispOrigin",
  "occupationSource",
  "oncotypeDxRiskLevelDcis",
  "oncotypeDxRiskLevelInvasive",
  "overRideAcsnClassSeq",
  "overRideAgeSiteMorph",
  "overRideCocSiteType",
  "overRideCs1",
  "overRideCs10",
  "overRideCs11",
  "overRideCs12",
  "overRideCs13",
  "overRideCs14",
  "overRideCs15",
  "overRideCs16",
  "overRideCs17",
  "overRideCs18",
  "overRideCs19",
  "overRideCs2",
  "overRideCs20",
  "overRideCs3",
  "overRideCs4",
  "overRideCs5",
  "overRideCs6",
  "overRideCs7",
  "overRideCs8",
  "overRideCs9",
  "overRideHistology",
  "overRideHospseqDxconf",
  "overRideHospseqSite",
  "overRideIllDefineSite",
  "overRideLeukLymphoma",
  "overRideNameSex",
  "overRideReportSource",
  "overRideSeqnoDxconf",
  "overRideSiteBehavior",
  "overRideSiteEodDxDt",
  "overRideSiteLatEod",
  "overRideSiteLatMorph",
  "overRideSiteLatSeqno",
  "overRideSiteTnmStggrp",
  "overRideSiteType",
  "overRideSsNodespos",
  "overRideSsTnmM",
  "overRideSsTnmN",
  "overRideSurgDxconf",
  "overRideTnm3",
  "overRideTnmStage",
  "overRideTnmTis",
  "pathReportType1",
  "pathReportType2",
  "pathReportType3",
  "pathReportType4",
  "pathReportType5",
  "pediatricStage",
  "pediatricStagedBy",
  "pediatricStagingSystem",
  "peripheralBloodInvolvement",
  "peritonealCytology",
  "phase1RadiationExternalBeamPlanningTech",
  "phase1RadiationPrimaryTreatmentVolume",
  "phase1RadiationToDrainingLymphNodes",
  "phase1RadiationTreatmentModality",
  "phase2RadiationExternalBeamPlanningTech",
  "phase2RadiationPrimaryTreatmentVolume",
  "phase2RadiationToDrainingLymphNodes",
  "phase2RadiationTreatmentModality",
  "phase3RadiationExternalBeamPlanningTech",
  "phase3RadiationPrimaryTreatmentVolume",
  "phase3RadiationToDrainingLymphNodes",
  "phase3RadiationTreatmentModality",
  "pleuralEffusion",
  "primaryPayerAtDx",
  "profoundImmuneSuppression",
  "prostatePathologicalExtension",
  "qualityOfSurvival",
  "race1",
  "race2",
  "race3",
  "race4",
  "race5",
  "raceCodingSysCurrent",
  "raceCodingSysOriginal",
  "raceNapiia",
  "radBoostRxModality",
  "radLocationOfRx",
  "radRegionalRxModality",
  "radTreatmentVolume",
  "radiationTreatmentDiscontinuedEarly",
  "readmSameHosp30Days",
  "reasonForNoRadiation",
  "reasonForNoSurgery",
  "recordType",
  "recurrenceType1st",
  "registryType",
  "residualTumorVolumePostCytoreduction",
  "responseToNeoadjuvantTherapy",
  "rqrsNcdbSubmissionFlag",
  "ruralurbanContinuum1993",
  "ruralurbanContinuum2003",
  "ruralurbanContinuum2013",
  "rxCodingSystemCurrent",
  "rxHospBrm",
  "rxHospChemo",
  "rxHospDxStgProc",
  "rxHospHormone",
  "rxHospOther",
  "rxHospPalliativeProc",
  "rxHospRadiation",
  "rxHospScopeRegLnSur",
  "rxHospSurgApp2010",
  "rxHospSurgOthRegDis",
  "rxSummBrm",
  "rxSummChemo",
  "rxSummDxStgProc",
  "rxSummHormone",
  "rxSummOther",
  "rxSummPalliativeProc",
  "rxSummRadToCns",
  "rxSummRadiation",
  "rxSummScopeRegLnSur",
  "rxSummSurgOthRegDis",
  "rxSummSurgRadSeq",
  "rxSummSurgicalMargins",
  "rxSummSystemicSurSeq",
  "rxSummTransplntEndocr",
  "rxSummTreatmentStatus",
  "sCategoryClinical",
  "sCategoryPathological",
  "seerCodingSysCurrent",
  "seerCodingSysOriginal",
  "seerSummaryStage1977",
  "seerSummaryStage2000",
  "seerTypeOfFollowUp",
  "separateTumorNodules",
  "serumAlbuminPretreatmentLevel",
  "serumBeta2MicroglobulinPretreatmentLevel",
  "sex",
  "siteCodingSysCurrent",
  "siteCodingSysOriginal",
  "spanishHispanicOrigin",
  "subsqRx2ndCourseBrm",
  "subsqRx3rdCourseBrm",
  "subsqRx4thCourseBrm",
  "summaryStage2018",
  "survFlagActiveFollowup",
  "survFlagPresumedAlive",
  "thrombocytopenia",
  "tnmClinDescriptor",
  "tnmClinStagedBy",
  "tnmEditionNumber",
  "tnmPathStagedBy",
  "tumorGrowthPattern",
  "tumorMarker1",
  "tumorMarker2",
  "tumorMarker3",
  "typeOfReportingSource",
  "uric2000",
  "uric2010",
  "visceralAndParietalPleuralInvasion"
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

# Some schemes are shared by  multiple variables
code_maps[
  xml_name == "pathReportType1",
  xml_name := "pathReportType"
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
