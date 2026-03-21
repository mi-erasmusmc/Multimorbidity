#' @export
# extractCovariates <- function(connectionDetails, 
#                               analysisDetails){
#   
#   cohortTable <- analysisDetails$cohortTable
#   cdmDatabaseSchema <- analysisDetails$cdmDatabaseSchema
#   cohortDatabaseSchema <- analysisDetails$cohortDatabaseSchema
#   cohortId <- analysisDetails$cohortIds
#   
#   cohortDefinitionSet <- CohortGenerator::getCohortDefinitionSet(settingsFileName = "inst/eunomiaDefinitions/multimorbidityDefinitions/Ho_et_al/settings/CohortsToCreate.csv", 
#                                                                  jsonFolder = "inst/eunomiaDefinitions/multimorbidityDefinitions/Ho_et_al/cohorts", 
#                                                                  sqlFolder = "inst/eunomiaDefinitions/multimorbidityDefinitions/Ho_et_al/sql/sql_server")
#   covariateCohorts <- dplyr::tibble(
#     cohortId = cohortDefinitionSet$cohortId,
#     cohortName = cohortDefinitionSet$cohortName
#   )
#   
#   covariateSettings1 <- FeatureExtraction::createTemporalSequenceCovariateSettings(useDemographicsGender = TRUE, 
#                                                                    useDemographicsAge = TRUE)
#   
#   covariateSettings2 <- createCohortBasedTemporalSequenceCovariateSettings(
#     analysisId = 999,
#     covariateCohorts = covariateCohorts,
#     valueType = "binary",timePart = "DAY", timeInterval = 1, sequenceEndDay = 54750, sequenceStartDay = 0
#   )
#   
#   covariateSettings <- list(covariateSettings1, covariateSettings2)
#   
#   # covariateData <- FeatureExtraction::getDbCovariateData(
#   #   connectionDetails = connectionDetails,
#   #   cdmDatabaseSchema = cdmDatabaseSchema,
#   #   cohortDatabaseSchema = cohortDatabaseSchema,
#   #   cohortTable = cohortTable,
#   #   cohortIds = cohortId,
#   #   rowIdField = "subject_id",
#   #   covariateSettings = covariateSettings
#   # )
#   
#   covs <- FeatureExtraction::getDbCovariateData(connectionDetails = connectionDetails, 
#                                                 cdmDatabaseSchema = cdmDatabaseSchema, 
#                                                 cohortTable = cohortTable, 
#                                                 cohortDatabaseSchema = cohortDatabaseSchema,
#                                                 # cohortIds = cohortId, 
#                                                 covariateSettings = covariateSettings)
#   
#   FeatureExtraction::saveCovariateData(covs, file = file.path(saveDirectory, "Mulitmorbidity_covs"))
#   
#   return(invisible())
#   
# }
extractCovariates <- function(connectionDetails, 
                              analysisDetails){
  
  cohortTable <- analysisDetails$cohortTable
  cdmDatabaseSchema <- analysisDetails$cdmDatabaseSchema
  cohortDatabaseSchema <- analysisDetails$cohortDatabaseSchema
  cohortId <- analysisDetails$cohortIds
  rawDataFolder <- analysisDetails$rawDataFolder
  saveDirectory <- analysisDetails$saveDirectory
  
  rawDataOuputFolder <- file.path(saveDirectory, rawDataFolder)
  
  cohortDefinitionSet <- CohortGenerator::getCohortDefinitionSet(settingsFileName = "inst/eunomiaDefinitions/multimorbidityDefinitions/Ho_et_al/settings/CohortsToCreate.csv", 
                                                                 jsonFolder = "inst/eunomiaDefinitions/multimorbidityDefinitions/Ho_et_al/cohorts", 
                                                                 sqlFolder = "inst/eunomiaDefinitions/multimorbidityDefinitions/Ho_et_al/sql/sql_server")
  covariateCohorts <- dplyr::tibble(
    cohortId = cohortDefinitionSet$cohortId,
    cohortName = cohortDefinitionSet$cohortName
  )
  
  # covariateSettings1 <- FeatureExtraction::createTemporalSequenceCovariateSettings(useDemographicsGender = TRUE, 
  #                                                                                  useDemographicsAge = TRUE)
  covariateSettings1 <- FeatureExtraction::createCovariateSettings(useDemographicsGender = TRUE,
                                                                   useDemographicsAge = TRUE)
  
  covariateSettings2 <- Multimorbidity::createCohortBasedTemporalSequenceCovariateSettings(
    analysisId = 999,
    covariateCohorts = covariateCohorts, 
    covariateCohortTable = "mm_cohorts",
    valueType = "binary",
    timePart = "DAY",
    timeInterval = 1,
    sequenceEndDay = 54750, 
    sequenceStartDay = 0
  )
  ParallelLogger::logInfo(paste("Extracting target cohort..."))
  covsTarget <- FeatureExtraction::getDbCovariateData(connectionDetails = connectionDetails, 
                                                      cdmDatabaseSchema = cdmDatabaseSchema, 
                                                      cohortTable = "denominator", 
                                                      cohortDatabaseSchema = cohortDatabaseSchema,
                                                      covariateSettings = covariateSettings1)
  FeatureExtraction::saveCovariateData(covsTarget, file = file.path(rawDataOuputFolder, "Multimorbidity_target"))
  
  covariateSettings <- list(covariateSettings1, covariateSettings2)
  
  ParallelLogger::logInfo(paste("Extracting cohort covariates..."))
  covs <- FeatureExtraction::getDbCovariateData(connectionDetails = connectionDetails, 
                                                cdmDatabaseSchema = cdmDatabaseSchema, 
                                                cohortTable = "denominator", 
                                                cohortDatabaseSchema = cohortDatabaseSchema,
                                                covariateSettings = covariateSettings2)
  
  FeatureExtraction::saveCovariateData(covs, file = file.path(rawDataOuputFolder, "Multimorbidity_covs"))
  
  return(invisible())
  
}