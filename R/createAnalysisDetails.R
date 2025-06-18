#' @export
createAnalysisDetails <- function(cdmDatabaseSchema,
                                  cohortDatabaseSchema,
                                  cohortTable, 
                                  databaseId, 
                                  cohortIds,
                                  minCellCount, 
                                  baseUrl, 
                                  frequentItemsetSettings, 
                                  # outputFolder, 
                                  databaseName, 
                                  saveDirectory){
  
  settings <- list(cdmDatabaseSchema = cdmDatabaseSchema, 
                   cohortDatabaseSchema = cohortDatabaseSchema, 
                   cohortTableNames = cohortTableNames, 
                   cohortDefinitionSet = cohortDefinitionSet, 
                   cohortTable = cohortTable, 
                   databaseId = databaseId, 
                   cohortIds = cohortIds,
                   minCellCount = minCellCount, 
                   baseUrl = baseUrl, 
                   frequentItemsetSettings = frequentItemsetSettings,
                   databaseName = databaseName,
                   # outputFolder = outputFolder,
                   saveDirectory = saveDirectory
  )
  
  return(settings)
}