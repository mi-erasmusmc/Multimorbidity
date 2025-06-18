#' @export
createConceptSet <- function(conceptIds, 
                             conceptIdsToExclude, 
                             conceptSetName){
  
  if(!is.null(conceptIdsToExclude)){
    caprConceptSetExpression <- Capr::cs(Capr::descendants(conceptIds), 
                                         Capr::descendants(exclude(conceptIdsToExclude)), 
                                         name = paste0(conceptSetName))
  } else {
    aprConceptSetExpression <- Capr::cs(Capr::descendants(conceptIds), 
                                        name = paste0(conceptSetName))
  }
  
  return(caprConceptSetExpression)
}

#' @export
createCohortDefinition <- function(conceptSet){
  cd <- Capr::cohort(
    entry = Capr::entry(
      Capr::conditionOccurrence(conceptSet),
      observationWindow = continuousObservation(0)
    ),
    exit = Capr::exit(
      endStrategy = observationExit()
    )
  )
  return(cd)
}
