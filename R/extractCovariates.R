#' @export
extractCovariates <- function(connectionDetails, 
                              analysisDetails){
  
  cohortTable <- analysisDetails$cohortTable
  cdmDatabaseSchema <- analysisDetails$cdmDatabaseSchema
  cohortDatabaseSchema <- analysisDetails$cohortDatabaseSchema
  cohortId <- analysisDetails$cohortIds
  # projectRoot <- system.file(package = "Multimorbidity")
  # covariateSettings <- analysisDetails$covariateSettings
  
  cohortDefinitionSet <- CohortGenerator::getCohortDefinitionSet(settingsFileName = "inst/eunomiaDefinitions/multimorbidityDefinitions/Ho_et_al/settings/CohortsToCreate.csv", 
                                                                 jsonFolder = "inst/eunomiaDefinitions/multimorbidityDefinitions/Ho_et_al/cohorts", 
                                                                 sqlFolder = "inst/eunomiaDefinitions/multimorbidityDefinitions/Ho_et_al/sql/sql_server")
  covariateCohorts <- tibble(
    cohortId = cohortDefinitionSet$cohortId,
    cohortName = cohortDefinitionSet$cohortName
  )
  
  covariateSettings1 <- FeatureExtraction::createTemporalSequenceCovariateSettings(useDemographicsGender = TRUE, 
                                                                   useDemographicsAge = TRUE)
  
  covariateSettings2 <- createCohortBasedTemporalSequenceCovariateSettings(
    analysisId = 999,
    covariateCohorts = covariateCohorts,
    valueType = "binary",timePart = "DAY", timeInterval = 1, sequenceEndDay = 54750, sequenceStartDay = 0
  )
  
  covariateSettings <- list(covariateSettings1, covariateSettings2)
  
  covariateData <- FeatureExtraction::getDbCovariateData(
    connectionDetails = connectionDetails,
    cdmDatabaseSchema = cdmDatabaseSchema,
    cohortDatabaseSchema = cohortDatabaseSchema,
    cohortTable = cohortTable,
    cohortIds = cohortId,
    rowIdField = "subject_id",
    covariateSettings = covariateSettings
  )
  
  covs <- FeatureExtraction::getDbCovariateData(connectionDetails = connectionDetails, 
                                                cdmDatabaseSchema = cdmDatabaseSchema, 
                                                cohortTable = cohortTable, 
                                                cohortDatabaseSchema = cohortDatabaseSchema,
                                                cohortIds = cohortId, 
                                                covariateSettings = covariateSettings)
  
  FeatureExtraction::saveCovariateData(covs, file = file.path(saveDirectory, "Mulitmorbidity_covs"))
  
  return(invisible())
  
}
