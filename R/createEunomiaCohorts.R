#' @export
createEunomiaCohorts <- function(cohorts = NULL,
                          connectionDetails = NULL,
                          cdmDatabaseSchema = cdmDatabaseSchema,
                          cohortDatabaseSchema = cohortDatabaseSchema,
                          cohortTable = cohortTable,
                          incremental = FALSE,
                          rawDataFolder = "rawData",
                          saveDirectory = getwd()
){
  
  if (dirname(rawDataFolder) == "."){
    outputFolder = file.path(saveDirectory, rawDataFolder)
  } else {
    outputFolder = file.path(rawDataFolder)
  }
  
  projectRoot <- system.file(package = "Multimorbidity")
  
  
  ParallelLogger::logInfo(paste("Creating target cohort..."))
  cohortDefinitionSet <- CohortGenerator::getCohortDefinitionSet(settingsFileName = file.path(projectRoot, "eunomiaDefinitions", "target", "settings", "CohortsToCreate.csv"), 
                                                                 jsonFolder = file.path(projectRoot, "eunomiaDefinitions", "target", "cohorts"), 
                                                                 sqlFolder = file.path(projectRoot, "eunomiaDefinitions", "target", "sql", "sql_server")
  )
  
  cohortTableNames <- CohortGenerator::getCohortTableNames(cohortTable = cohortTable)
  
  CohortGenerator::createCohortTables(connectionDetails = connectionDetails, 
                                      cohortDatabaseSchema = cohortDatabaseSchema, 
                                      cohortTableNames = cohortTableNames, 
                                      incremental = incremental)
  
  CohortGenerator::generateCohortSet(connectionDetails = connectionDetails,
                                     cdmDatabaseSchema = cdmDatabaseSchema, 
                                     cohortDatabaseSchema = cohortDatabaseSchema,
                                     cohortTableNames = cohortTableNames, 
                                     cohortDefinitionSet = cohortDefinitionSet, 
                                     incremental = incremental, 
                                     incrementalFolder = outputFolder)
  
  # cohortCountsTarget <- CohortGenerator::getCohortCounts(
  #   connectionDetails = connectionDetails,
  #   cohortDatabaseSchema = cohortDatabaseSchema,
  #   cohortTable = cohortTableNames$cohortTable
  # )
  
  ParallelLogger::logInfo(paste("Cohorts created."))
  
  ParallelLogger::logInfo(paste("Creating phenotype cohorts..."))
  
  cohortDefinitionSet <- CohortGenerator::getCohortDefinitionSet(settingsFileName = file.path(projectRoot, "eunomiaDefinitions", "multimorbidityDefinitions", "Ho_et_al", "settings", "CohortsToCreate.csv"), 
                                                                 jsonFolder = file.path(projectRoot, "eunomiaDefinitions", "multimorbidityDefinitions", "Ho_et_al", "cohorts"), 
                                                                 sqlFolder = file.path(projectRoot, "eunomiaDefinitions", "multimorbidityDefinitions", "Ho_et_al", "sql", "sql_server"), 
  )
  
  cohortTableNames <- CohortGenerator::getCohortTableNames(cohortTable = cohortTable)
  
  CohortGenerator::createCohortTables(connectionDetails = connectionDetails, 
                                      cohortDatabaseSchema = cohortDatabaseSchema, 
                                      cohortTableNames = cohortTableNames, 
                                      incremental = TRUE)
  
  CohortGenerator::generateCohortSet(connectionDetails = connectionDetails,
                                     cdmDatabaseSchema = cdmDatabaseSchema, 
                                     cohortDatabaseSchema = cohortDatabaseSchema,
                                     cohortTableNames = cohortTableNames, 
                                     cohortDefinitionSet = cohortDefinitionSet, 
                                     incremental = TRUE, 
                                     incrementalFolder = outputFolder)
  
  cohortCounts <- CohortGenerator::getCohortCounts(
    connectionDetails = connectionDetails,
    cohortDatabaseSchema = cohortDatabaseSchema,
    cohortTable = cohortTableNames$cohortTable
  )
  
  ParallelLogger::logInfo(paste("Phenotype cohorts created."))
  ParallelLogger::logInfo(paste(cohortCounts))
  
  
  utils::write.csv(cohortCounts, file.path(outputFolder, paste0("cohortCounts_", gsub("-", "", Sys.Date()), ".csv")))
  return(dplyr::tibble(cohortCounts))
}