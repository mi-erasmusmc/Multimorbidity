#' @export
extractMultimorbidityCovariates <- function(connectionDetails,
                                            cohortTable, 
                                            cohortId, 
                                            covariateIds, 
                                            highQuality = FALSE){
  
  # connectionDetails class connectionDetails
  # cohortTable character vector
  # cohortId integer
  # covariateIds integer vector
  # highQuality logical
  
  connection <- DatabaseConnector::connect(connectionDetails = connectionDetails)
  on.exit(DatabaseConnector::disconnect(connection))
  
  andromedaMM <- Andromeda::andromeda()
  
  ParallelLogger::logInfo("Creating multimorbidity dataframe... This may take a while...")
  
  ParallelLogger::logTrace("Finding cohort subjects...")
  ## Cohort 
  andromedaMM$cohort <- dplyr::tbl(connection, cohortTable) %>%
    dplyr::filter(cohort_definition_id == cohortId) %>%
    dplyr::select(subject_id, cohort_start_date) %>%
    dplyr::collect()
  
  subjectIds <- andromedaMM$cohort %>% pull(subject_id)
  
  ParallelLogger::logTrace("Extracting information on conditions...")
  ## Conditions
  andromedaMM$conditions <- dplyr::tbl(connection, "condition_occurrence") %>%
    dplyr::filter(person_id %in% subjectIds) %>%
    dplyr::select(person_id, condition_concept_id, condition_start_date) %>%
    dplyr::group_by(person_id, condition_concept_id) %>%
    dplyr::distinct() %>%
    dplyr::slice_min(condition_start_date) %>%
    dplyr::ungroup() %>%
    dplyr::collect()
  #Need to add a filtering for condition_concept_id of interest
  
  ParallelLogger::logTrace("Extracting information on observation period...")
  ## Observation period
  andromedaMM$observation_period <- dplyr::tbl(connection, "observation_period") %>%
    dplyr::filter(person_id %in% subjectIds) %>%
    dplyr::select(person_id, observation_period_start_date, observation_period_end_date) %>%
    dplyr::collect()
  
  ParallelLogger::logTrace("Extracting information on demographics...")
  ## Person
  andromedaMM$person <- dplyr::tbl(connection, "person") %>%
    dplyr::filter(person_id %in% subjectIds) %>%
    dplyr::select(person_id, birth_datetime) %>%
    dplyr::collect()
  
  ParallelLogger::logTrace("Getting variable names...")
  ## Concept
  conceptIdsToInclude <- andromedaMM$conditions %>% dplyr::distinct(condition_concept_id) %>% dplyr::pull()
  andromedaMM$covariateNames <- dplyr::tbl(connection, "concept") %>%
    dplyr::filter(concept_id %in% conceptIdsToInclude) %>%
    dplyr::select(concept_id, concept_name) %>%
    dplyr::collect()
  
  ParallelLogger::logTrace("Putting it all together...")
  andromedaMM$df <- andromedaMM$cohort %>% 
    dplyr::inner_join(andromedaMM$conditions, by = join_by("subject_id" == "person_id")) %>%
    dplyr::inner_join(andromedaMM$observation_period, by = join_by("subject_id" == "person_id")) %>%
    dplyr::inner_join(andromedaMM$person, join_by("subject_id" == "person_id")) %>%
    dplyr::inner_join(andromedaMM$covariateNames, join_by("condition_concept_id" == "concept_id")) %>%
    dplyr::mutate(total_observation_time = observation_period_end_date - observation_period_start_date, 
                  observation_time_priorIndex = cohort_start_date - observation_period_start_date, 
                  observation_time_postIndex = observation_period_end_date - cohort_start_date) %>%
    dplyr::collect()%>%
    dplyr::mutate(age_at_diagnosis = base::floor(as.numeric(base::difftime(as.Date(condition_start_date), as.Date(birth_datetime), unit = "days"))/365))

  ParallelLogger::logInfo("Done.")
  return(andromedaMM$df)
}
