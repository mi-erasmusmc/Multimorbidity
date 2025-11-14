#' @export
createCohortBasedTemporalSequenceCovariateSettings <- function(analysisId,
                                                       covariateCohortDatabaseSchema = NULL,
                                                       covariateCohortTable = NULL,
                                                       covariateCohorts,
                                                       valueType = "binary",
                                                       timePart = "DAY", 
                                                       timeInterval = 1,
                                                       sequenceEndDay = -1,
                                                       sequenceStartDay = -730,
                                                       includedCovariateIds = c(),
                                                       warnOnAnalysisIdOverlap = TRUE) {
  errorMessages <- checkmate::makeAssertCollection()
  checkmate::assertInt(analysisId, lower = 1, upper = 999, add = errorMessages)
  checkmate::assertCharacter(covariateCohortDatabaseSchema, len = 1, null.ok = TRUE, add = errorMessages)
  checkmate::assertCharacter(covariateCohortTable, len = 1, null.ok = TRUE, add = errorMessages)
  checkmate::assertDataFrame(covariateCohorts, min.rows = 1, add = errorMessages)
  checkmate::assertNames(colnames(covariateCohorts), must.include = c("cohortId", "cohortName"), add = errorMessages)
  checkmate::assertChoice(valueType, c("binary", "count"), add = errorMessages)
  checkmate::assertIntegerish(sequenceStartDay, add = errorMessages)
  checkmate::assertIntegerish(sequenceEndDay, add = errorMessages)
  checkmate::assertTRUE(all(sequenceStartDay <= sequenceEndDay), add = errorMessages)
  # .assertCovariateId(includedCovariateIds, null.ok = TRUE, add = errorMessages)
  checkmate::assertLogical(warnOnAnalysisIdOverlap, len = 1, add = errorMessages)
  checkmate::reportAssertions(collection = errorMessages)
  
  if (warnOnAnalysisIdOverlap) {
    FeatureExtraction:::warnIfPredefined(analysisId, TRUE)
  }
  
  # covariateSettings <- list(
  #   temporal = TRUE,
  #   temporalSequence = FALSE
  # )
  covariateSettings <- list(
    temporal = FALSE,
    temporalSequence = TRUE
  )
  
  formalNames <- names(formals(Multimorbidity::createCohortBasedTemporalSequenceCovariateSettings))
  for (name in formalNames) {
    value <- get(name)
    covariateSettings[[name]] <- value
  }
  attr(covariateSettings, "fun") <- "Multimorbidity::getCohortBasedCovariatesData"
  class(covariateSettings) <- "covariateSettings"
  return(covariateSettings)
}