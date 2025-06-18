#' @export
createDetailedTemporalSequenceCovariateSettings <- function(analyses = list(),
                                                            timePart = "DAY", 
                                                            timeInterval = 1,
                                                    sequenceStartDay = -365,
                                                    sequenceEndDay = -1) {
  covariateSettings <- list(
    temporal = FALSE,
    temporalSequence = TRUE
  )
  formalNames <- names(formals(createDetailedTemporalSequenceCovariateSettings))
  for (name in formalNames) {
    covariateSettings[[name]] <- get(name)
  }
  attr(covariateSettings, "fun") <- "FeatureExtraction::getDbDefaultCovariateData"
  class(covariateSettings) <- "covariateSettings"
  return(covariateSettings)
}