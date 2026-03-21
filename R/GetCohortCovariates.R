#' @export
getCohortBasedCovariatesData <- function(connection,
                                           oracleTempSchema = NULL,
                                           cdmDatabaseSchema,
                                           cohortTable = "#cohort_person",
                                           cohortId = -1,
                                           cohortIds = c(-1),
                                           cdmVersion = "5",
                                           rowIdField = "subject_id",
                                           covariateSettings,
                                           aggregated = FALSE,
                                           minCharacterizationMean = 0,
                                           tempEmulationSchema = getOption("sqlRenderTempEmulationSchema")) {
  errorMessages <- checkmate::makeAssertCollection()
  checkmate::assertClass(connection, "DatabaseConnectorConnection", add = errorMessages)
  checkmate::assertCharacter(oracleTempSchema, len = 1, null.ok = TRUE, add = errorMessages)
  checkmate::assertCharacter(tempEmulationSchema, len = 1, null.ok = TRUE, add = errorMessages)
  checkmate::assertCharacter(cdmDatabaseSchema, len = 1, null.ok = TRUE, add = errorMessages)
  checkmate::assertCharacter(cohortTable, len = 1, add = errorMessages)
  checkmate::assertIntegerish(cohortId, add = errorMessages)
  # checkmate::assertCharacter(cdmVersion, len = 1, add = errorMessages)
  checkmate::assertCharacter(rowIdField, len = 1, add = errorMessages)
  checkmate::assertClass(covariateSettings, "covariateSettings", add = errorMessages)
  checkmate::assertLogical(aggregated, len = 1, add = errorMessages)
  minCharacterizationMean <- utils::type.convert(minCharacterizationMean, as.is = TRUE)
  checkmate::assertNumeric(x = minCharacterizationMean, lower = 0, upper = 1, add = errorMessages)
  checkmate::reportAssertions(collection = errorMessages)
  if (!missing(cohortId)) {
    warning("cohortId argument has been deprecated, please use cohortIds")
    cohortIds <- cohortId
  }
  if (!is.null(oracleTempSchema) && oracleTempSchema != "") {
    rlang::warn("The 'oracleTempSchema' argument is deprecated. Use 'tempEmulationSchema' instead.",
                .frequency = "regularly",
                .frequency_id = "oracleTempSchema"
    )
    tempEmulationSchema <- oracleTempSchema
  }
  
  start <- Sys.time()
  message("Constructing covariates from other cohorts")
  
  covariateCohorts <- covariateSettings$covariateCohorts %>%
    dplyr::select("cohortId", "cohortName")
  
  DatabaseConnector::insertTable(connection,
                                 tableName = "#covariate_cohort_ref",
                                 data = covariateCohorts,
                                 dropTableIfExists = TRUE,
                                 createTable = TRUE,
                                 tempTable = TRUE,
                                 tempEmulationSchema = tempEmulationSchema,
                                 camelCaseToSnakeCase = TRUE
  )
  if (is.null(covariateSettings$covariateCohortTable)) {
    covariateCohortTable <- cohortTable
  } else if (is.null(covariateSettings$covariateCohortDatabaseSchema)) {
    covariateCohortTable <- covariateSettings$covariateCohortTable
  } else {
    covariateCohortTable <- paste(covariateSettings$covariateCohortDatabaseSchema,
                                  covariateSettings$covariateCohortTable,
                                  sep = "."
    )
  }
  
  if (covariateSettings$temporalSequence) {
    if (covariateSettings$valueType == "binary") {
      sqlFileName <- "CohortBasedBinaryCovariates.sql"
    } else {
      sqlFileName <- "CohortBasedCountCovariates.sql"
    }
    parameters <- list(
      covariateCohortTable = covariateCohortTable,
      analysisId = covariateSettings$analysisId,
      analysisName = "CohortTemporalSequence",
      timePart = covariateSettings$timePart, 
      timeInterval = covariateSettings$timeInterval,
      sequenceStartDay = covariateSettings$sequenceStartDay,
      sequenceEndDay = covariateSettings$sequenceEndDay
    )
    detail <- FeatureExtraction::createAnalysisDetails(
      analysisId = covariateSettings$analysisId,
      sqlFileName = sqlFileName,
      parameters = parameters,
      includedCovariateConceptIds = covariateSettings$includedCovariateIds,
      addDescendantsToInclude = FALSE,
      excludedCovariateConceptIds = c(),
      addDescendantsToExclude = FALSE,
      includedCovariateIds = c()
    )
    detailledSettings <- Multimorbidity::createDetailedTemporalSequenceCovariateSettings(
      analyses = list(detail),
      timePart = covariateSettings$timePart, 
      timeInterval = covariateSettings$timeInterval,
      sequenceStartDay = covariateSettings$sequenceStartDay,
      sequenceEndDay = covariateSettings$sequenceEndDay
    )
    
  } else {
    ParallelLogger::logError(paste0("Something went wrong"))}
  #   # Not temporal
  #   if (covariateSettings$valueType == "binary") {
  #     sqlFileName <- "CohortBasedBinaryCovariates.sql"
  #   } else {
  #     sqlFileName <- "CohortBasedCountCovariates.sql"
  #   }
  #   parameters <- list(
  #     covariateCohortTable = covariateCohortTable,
  #     analysisId = covariateSettings$analysisId,
  #     analysisName = "Cohort",
  #     startDay = covariateSettings$startDay,
  #     endDay = covariateSettings$endDay
  #   )
  #   detail <- createAnalysisDetails(
  #     analysisId = covariateSettings$analysisId,
  #     sqlFileName = sqlFileName,
  #     parameters = parameters,
  #     includedCovariateConceptIds = covariateSettings$includedCovariateIds,
  #     addDescendantsToInclude = FALSE,
  #     excludedCovariateConceptIds = c(),
  #     addDescendantsToExclude = FALSE,
  #     includedCovariateIds = c()
  #   )
  #   detailledSettings <- createDetailedCovariateSettings(analyses = list(detail))
  # }
  result <- FeatureExtraction::getDbDefaultCovariateData(
    connection = connection,
    tempEmulationSchema = tempEmulationSchema,
    cdmDatabaseSchema = cdmDatabaseSchema,
    cohortTable = cohortTable,
    cohortIds = cohortIds,
    cdmVersion = cdmVersion,
    rowIdField = rowIdField,
    covariateSettings = detailledSettings,
    aggregated = aggregated,
    minCharacterizationMean = minCharacterizationMean
  )
  
  sql <- "TRUNCATE TABLE #covariate_cohort_ref; DROP TABLE #covariate_cohort_ref;"
  DatabaseConnector::renderTranslateExecuteSql(
    connection = connection,
    sql = sql,
    progressBar = FALSE,
    reportOverallTime = FALSE,
    tempEmulationSchema = tempEmulationSchema
  )
  return(result)
}