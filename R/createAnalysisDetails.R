#' @export
createAnalysisDetails <- function(cdmDatabaseSchema,
                                  cohortDatabaseSchema,
                                  cohortTableNames, 
                                  cohortDefinitionSet,
                                  cohortTable, 
                                  databaseId, 
                                  minCellCount, 
                                  baseUrl, 
                                  saveSettings, 
                                  databaseName, 
                                  outputFolder){
  
  settings <- list(cdmDatabaseSchema = cdmDatabaseSchema, 
                   cohortDatabaseSchema = cohortDatabaseSchema, 
                   cohortTableNames = cohortTableNames, 
                   cohortDefinitionSet = cohortDefinitionSet, 
                   cohortTable = cohortTable, 
                   databaseId = databaseId, 
                   minCellCount = minCellCount, 
                   baseUrl = baseUrl, 
                   saveSettings = saveSettings, 
                   databaseName = databaseName,
                   outputFolder = outputFolder
  )
  
  return(settings)
}