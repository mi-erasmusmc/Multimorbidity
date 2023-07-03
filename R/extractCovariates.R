extractCovariates <- function(connectionDetails, 
                              analysisDetails){
  
  cohortTable <- analysisDetails$cohortTable
  cdmDatabaseSchema <- analysisDetails$cdmDatabaseSchema
  cohortDatabaseSchema <- analysisDetails$cohortDatabaseSchema
  cohortId <- analysisDetails$cohortId
  # projectRoot <- system.file(package = "Multimorbidity")
  covariateSettings <- analysisDetails$covariateSettings
  
  # covSets <- FeatureExtraction::createCovariateSettings(useConditionOccurrenceLongTerm = TRUE, 
  #                                                       longTermStartDays = 0, 
  #                                                       endDays = 99999)
  
  covs <- FeatureExtraction::getDbCovariateData(connectionDetails = connectionDetails, 
                                                cdmDatabaseSchema = cdmDatabaseSchema, 
                                                cohortTable = cohortTable, 
                                                cohortDatabaseSchema = cohortDatabaseSchema,
                                                cohortId = cohortId, 
                                                covariateSettings = covariateSettings)
  
  FeatureExtraction::saveCovariateData(covs, file = "Mulitmorbidity_covs")
  
  return(invisible())
  
}