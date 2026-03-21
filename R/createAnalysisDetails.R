#' @export
createAnalysisDetails <- function(cdmDatabaseSchema,
                                  cohortDatabaseSchema,
                                  cohortTable, 
                                  databaseId, 
                                  cohortIds,
                                  minCellCount, 
                                  baseUrl,
                                  rawDataFolder = "rawData",
                                  studyPopulationSettings, 
                                  frequentItemsetSettings, 
                                  databaseName, 
                                  saveDirectory){
  
  analysisDetailsAssertions <- checkmate::makeAssertCollection()
  
  checkmate::assertCharacter(cdmDatabaseSchema, add = analysisDetailsAssertions)
  checkmate::assertCharacter(cohortDatabaseSchema, add = analysisDetailsAssertions)
  checkmate::assertCharacter(cohortTable, add = analysisDetailsAssertions)
  checkmate::assertNumeric(minCellCount, add = analysisDetailsAssertions)
  
  checkmate::assert(
    # checkmate::checkClass(studyPopulationSettings, classes = "list", null.ok = FALSE),
    checkmate::checkClass(studyPopulationSettings, classes = "studyPopulationSettings", null.ok = FALSE),
    combine = "and",
    add = analysisDetailsAssertions
  )
  
  checkmate::assert(
    checkmate::checkClass(frequentItemsetSettings, classes = "list", null.ok = FALSE),
    # checkmate::checkClass(frequentItemsetSettings, classes = "freaquentPatternSettings", null.ok = FALSE),
    combine = "and",
    add = analysisDetailsAssertions
  )
  
  checkmate::assertCharacter(databaseName, null.ok = TRUE, add = analysisDetailsAssertions)
  checkmate::assertCharacter(databaseId, null.ok = TRUE, add = analysisDetailsAssertions)
  checkmate::assertCharacter(rawDataFolder, add = analysisDetailsAssertions)
  
  checkmate::assertCharacter(saveDirectory, add = analysisDetailsAssertions)
  
  checkmate::reportAssertions(analysisDetailsAssertions)
  
  settings <- list(cdmDatabaseSchema = cdmDatabaseSchema, 
                   cohortDatabaseSchema = cohortDatabaseSchema, 
                   cohortTableNames = cohortTableNames, 
                   cohortDefinitionSet = cohortDefinitionSet, 
                   cohortTable = cohortTable, 
                   databaseId = databaseId, 
                   cohortIds = cohortIds,
                   minCellCount = minCellCount, 
                   baseUrl = baseUrl, 
                   rawDataFolder = rawDataFolder,
                   studyPopulationSettings = studyPopulationSettings,
                   frequentItemsetSettings = frequentItemsetSettings,
                   databaseName = databaseName,
                   saveDirectory = saveDirectory
  )
  
  return(settings)
}

#' @export
createStudyPopulationSettings <- function(cohortTable = "studyPopulation", 
                                          cohortDateRange = c(as.Date("1990-01-01"), as.Date("2009-12-31")), 
                                          ageGroup = list(c(0, 150)), 
                                          sex = c("Both"), 
                                          daysPriorObservation = 0){
  
  studyPopulationAssertions <- checkmate::makeAssertCollection()
  
  checkmate::assertCharacter(cohortTable, add = studyPopulationAssertions)
  
  checkmate::assertDate(cohortDateRange, add = studyPopulationAssertions)
  
  checkmate::assert(
    checkmate::checkClass(ageGroup, classes = "list", null.ok = FALSE),
    checkmate::checkList(ageGroup, types = "numeric"),
    combine = "and",
    add = studyPopulationAssertions
  )
  
  checkmate::assertCharacter(sex, null.ok = FALSE, add = studyPopulationAssertions)
  
  checkmate::assertNumeric(daysPriorObservation, lower = 0, finite = TRUE, null.ok = FALSE, add = studyPopulationAssertions)
  
  checkmate::reportAssertions(studyPopulationAssertions)
  
  settings <- list(cohortTable = cohortTable,
                   cohortDateRange = cohortDateRange,
                   ageGroup = ageGroup,
                   sex = sex, 
                   daysPriorObservation = daysPriorObservation
  )
  
  class(settings) <- "studyPopulationSettings"
  
  return(settings)
}
